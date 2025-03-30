import 'package:geolocator/geolocator.dart';
import 'package:plant_app/features/scan/data/scan_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scan_controller.g.dart';

// Model class for similar images in the response
class SimilarImage {
  final String id;
  final String url;
  final String? urlSmall;
  final double similarity;
  final String? licenseName;
  final String? licenseUrl;
  final String? citation;

  SimilarImage({
    required this.id,
    required this.url,
    this.urlSmall,
    required this.similarity,
    this.licenseName,
    this.licenseUrl,
    this.citation,
  });

  factory SimilarImage.fromJson(Map<String, dynamic> json) {
    return SimilarImage(
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      urlSmall: json['url_small'],
      similarity: (json['similarity'] as num?)?.toDouble() ?? 0.0,
      licenseName: json['license_name'],
      licenseUrl: json['license_url'],
      citation: json['citation'],
    );
  }
}

// Model class for plant identification suggestion
class PlantSuggestion {
  final String id;
  final String name;
  final double probability;
  final List<SimilarImage> similarImages;

  PlantSuggestion({
    required this.id,
    required this.name,
    required this.probability,
    required this.similarImages,
  });

  factory PlantSuggestion.fromJson(Map<String, dynamic> json) {
    final similarImagesList =
        (json['similar_images'] as List?)?.map((img) => SimilarImage.fromJson(img)).toList() ??
        [];

    return PlantSuggestion(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Plant',
      probability: (json['probability'] as num?)?.toDouble() ?? 0.0,
      similarImages: similarImagesList,
    );
  }
}

// Model for disease details
class DiseaseDetails {
  final String language;
  final String entityId;

  DiseaseDetails({required this.language, required this.entityId});

  factory DiseaseDetails.fromJson(Map<String, dynamic> json) {
    return DiseaseDetails(
      language: json['language'] ?? 'en',
      entityId: json['entity_id'] ?? '',
    );
  }
}

// Model for disease suggestion
class DiseaseSuggestion {
  final String id;
  final String name;
  final double probability;
  final List<SimilarImage> similarImages;
  final DiseaseDetails? details;

  DiseaseSuggestion({
    required this.id,
    required this.name,
    required this.probability,
    required this.similarImages,
    this.details,
  });

  factory DiseaseSuggestion.fromJson(Map<String, dynamic> json) {
    final similarImagesList =
        (json['similar_images'] as List?)?.map((img) => SimilarImage.fromJson(img)).toList() ??
        [];

    return DiseaseSuggestion(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Issue',
      probability: (json['probability'] as num?)?.toDouble() ?? 0.0,
      similarImages: similarImagesList,
      details: json['details'] != null ? DiseaseDetails.fromJson(json['details']) : null,
    );
  }

  // Format probability as percentage
  String get probabilityFormatted => '${(probability * 100).toStringAsFixed(1)}%';
}

// Model for question option
class QuestionOption {
  final int suggestionIndex;
  final String entityId;
  final String name;
  final String translation;

  QuestionOption({
    required this.suggestionIndex,
    required this.entityId,
    required this.name,
    required this.translation,
  });

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      suggestionIndex: json['suggestion_index'] ?? 0,
      entityId: json['entity_id'] ?? '',
      name: json['name'] ?? '',
      translation: json['translation'] ?? '',
    );
  }
}

// Model for question in disease diagnosis
class DiseaseQuestion {
  final String text;
  final String translation;
  final QuestionOption? yesOption;
  final QuestionOption? noOption;

  DiseaseQuestion({
    required this.text,
    required this.translation,
    this.yesOption,
    this.noOption,
  });

  factory DiseaseQuestion.fromJson(Map<String, dynamic> json) {
    final options = json['options'] as Map<String, dynamic>? ?? {};

    return DiseaseQuestion(
      text: json['text'] ?? '',
      translation: json['translation'] ?? '',
      yesOption: options['yes'] != null ? QuestionOption.fromJson(options['yes']) : null,
      noOption: options['no'] != null ? QuestionOption.fromJson(options['no']) : null,
    );
  }
}

// Model for disease analysis
class DiseaseAnalysis {
  final List<DiseaseSuggestion> suggestions;
  final DiseaseQuestion? question;

  DiseaseAnalysis({required this.suggestions, this.question});

  factory DiseaseAnalysis.fromJson(Map<String, dynamic> json) {
    final suggestionsList =
        (json['suggestions'] as List?)?.map((s) => DiseaseSuggestion.fromJson(s)).toList() ??
        [];

    return DiseaseAnalysis(
      suggestions: suggestionsList,
      question: json['question'] != null ? DiseaseQuestion.fromJson(json['question']) : null,
    );
  }

  // Get the top disease suggestion
  DiseaseSuggestion? get topSuggestion => suggestions.isNotEmpty ? suggestions[0] : null;
}

// Model for health assessment
class HealthAssessment {
  final bool binary;
  final double threshold;
  final double probability;

  HealthAssessment({required this.binary, required this.threshold, required this.probability});

  factory HealthAssessment.fromJson(Map<String, dynamic> json) {
    return HealthAssessment(
      binary: json['binary'] ?? false,
      threshold: (json['threshold'] as num?)?.toDouble() ?? 0.5,
      probability: (json['probability'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Format probability as percentage
  String get probabilityFormatted => '${(probability * 100).toStringAsFixed(1)}%';
}

// Model class to represent scan result
class ScanResult {
  final String imagePath;
  final DateTime scanDate;
  final String modelVersion;
  final bool isPlant;
  final List<PlantSuggestion> suggestions;
  final double latitude;
  final double longitude;
  final String status;
  // New fields for health analysis
  final DiseaseAnalysis? diseaseAnalysis;
  final HealthAssessment? healthAssessment;
  final String? accessToken;

  ScanResult({
    required this.imagePath,
    required this.scanDate,
    required this.modelVersion,
    required this.isPlant,
    required this.suggestions,
    required this.latitude,
    required this.longitude,
    required this.status,
    this.diseaseAnalysis,
    this.healthAssessment,
    this.accessToken,
  });

  // Get the top suggestion (most likely plant)
  PlantSuggestion? get topSuggestion => suggestions.isNotEmpty ? suggestions[0] : null;

  // Convenience getters for displaying data
  String get plantName => topSuggestion?.name ?? 'Unknown Plant';
  double get confidence => topSuggestion?.probability ?? 0.0;

  // Format confidence as percentage
  String get confidenceFormatted => '${(confidence * 100).toStringAsFixed(1)}%';

  // Get top disease with highest probability
  DiseaseSuggestion? get topDisease => diseaseAnalysis?.topSuggestion;

  // Check if plant is healthy
  bool get isHealthy => healthAssessment?.binary ?? true;

  // Get health probability
  double get healthProbability => healthAssessment?.probability ?? 1.0;

  // Format health probability as percentage
  String get healthProbabilityFormatted => healthAssessment?.probabilityFormatted ?? '100%';

  factory ScanResult.fromJson(Map<String, dynamic> json, String imagePath) {
    final input = json['input'] as Map<String, dynamic>? ?? {};
    final result = json['result'] as Map<String, dynamic>? ?? {};
    final isPlantData = result['is_plant'] as Map<String, dynamic>? ?? {};

    // Parse disease data if available
    final diseaseData = result['disease'] as Map<String, dynamic>?;
    final diseaseAnalysis = diseaseData != null ? DiseaseAnalysis.fromJson(diseaseData) : null;

    // Parse health assessment
    final healthData = result['is_healthy'] as Map<String, dynamic>?;
    final healthAssessment = healthData != null ? HealthAssessment.fromJson(healthData) : null;

    // Parse classification if available (for backward compatibility)
    final classification = result['classification'] as Map<String, dynamic>? ?? {};
    final suggestionsList =
        (classification['suggestions'] as List?)
            ?.map((s) => PlantSuggestion.fromJson(s))
            .toList() ??
        [];

    return ScanResult(
      imagePath: imagePath,
      scanDate: DateTime.now(),
      modelVersion: json['model_version'] ?? 'Unknown',
      isPlant: (isPlantData['binary'] as bool?) ?? false,
      suggestions: suggestionsList,
      latitude: (input['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (input['longitude'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'UNKNOWN',
      diseaseAnalysis: diseaseAnalysis,
      healthAssessment: healthAssessment,
      accessToken: json['access_token'],
    );
  }
}

// ScanState provider to store recent scans
@Riverpod(keepAlive: true)
class RecentScansNotifier extends _$RecentScansNotifier {
  @override
  List<ScanResult> build() {
    return [];
  }

  void addScan(ScanResult scan) {
    state = [scan, ...state];
  }
}

// Current scan provider
@riverpod
class CurrentScanNotifier extends _$CurrentScanNotifier {
  @override
  ScanResult? build() {
    return null;
  }

  void setScan(ScanResult scan) {
    state = scan;
  }
}

// Refactored to use AsyncNotifier like AuthController
@riverpod
class ScanNotifier extends _$ScanNotifier {
  @override
  FutureOr<void> build() async {}

  Future<void> scanPlant(String imagePath, {Function? onSuccess}) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      // Get current location
      final position = await Geolocator.getCurrentPosition();

      // Call repository method
      final scanRepository = ref.read(scanRepositoryProvider);
      final result = await scanRepository.scanPlant(
        imagePath: imagePath,
        longitude: position.longitude,
        latitude: position.latitude,
      );

      // Create scan result
      final scanResult = ScanResult.fromJson(result, imagePath);

      // Update recent scans
      ref.read(recentScansNotifierProvider.notifier).addScan(scanResult);

      // Set current scan
      ref.read(currentScanNotifierProvider.notifier).setScan(scanResult);
    });

    if (!state.hasError && onSuccess != null) {
      onSuccess();
    }
  }

  // Get recent diagnoses from the RecentScansNotifier
  List<ScanResult> getRecentDiagnoses() {
    return ref.read(recentScansNotifierProvider);
  }
}
