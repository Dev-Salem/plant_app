class PlantScanResponse {
  final String accessToken;
  final String modelVersion;
  final String? customId;
  final InputData input;
  final ScanResult result;
  final String status;
  final bool slaCompliantClient;
  final bool slaCompliantSystem;
  final double created;
  final double completed;

  PlantScanResponse({
    required this.accessToken,
    required this.modelVersion,
    this.customId,
    required this.input,
    required this.result,
    required this.status,
    required this.slaCompliantClient,
    required this.slaCompliantSystem,
    required this.created,
    required this.completed,
  });

  factory PlantScanResponse.fromJson(Map<String, dynamic> json) {
    return PlantScanResponse(
      accessToken: json['access_token'],
      modelVersion: json['model_version'],
      customId: json['custom_id'],
      input: InputData.fromJson(json['input']),
      result: ScanResult.fromJson(json['result']),
      status: json['status'],
      slaCompliantClient: json['sla_compliant_client'],
      slaCompliantSystem: json['sla_compliant_system'],
      created: json['created'].toDouble(),
      completed: json['completed'].toDouble(),
    );
  }
}

class InputData {
  final double latitude;
  final double longitude;
  final bool similarImages;
  final List<String> images;
  final String datetime;

  InputData({
    required this.latitude,
    required this.longitude,
    required this.similarImages,
    required this.images,
    required this.datetime,
  });

  factory InputData.fromJson(Map<String, dynamic> json) {
    return InputData(
      latitude: json['latitude'],
      longitude: json['longitude'],
      similarImages: json['similar_images'],
      images: List<String>.from(json['images']),
      datetime: json['datetime'],
    );
  }
}

class ScanResult {
  final Disease disease;
  final PlantStatus isPlant;
  final Crop crop;

  ScanResult({required this.disease, required this.isPlant, required this.crop});

  factory ScanResult.fromJson(Map<String, dynamic> json) {
    return ScanResult(
      disease: Disease.fromJson(json['disease']),
      isPlant: PlantStatus.fromJson(json['is_plant']),
      crop: Crop.fromJson(json['crop']),
    );
  }
}

class PlantStatus {
  final double probability;
  final double threshold;
  final bool binary;

  PlantStatus({required this.probability, required this.threshold, required this.binary});

  factory PlantStatus.fromJson(Map<String, dynamic> json) {
    return PlantStatus(
      probability: json['probability'].toDouble(),
      threshold: json['threshold'].toDouble(),
      binary: json['binary'],
    );
  }
}

class Disease {
  final List<Suggestion> suggestions;

  Disease({required this.suggestions});

  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      suggestions:
          (json['suggestions'] as List).map((item) => Suggestion.fromJson(item)).toList(),
    );
  }
}

class Crop {
  final List<Suggestion> suggestions;

  Crop({required this.suggestions});

  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      suggestions:
          (json['suggestions'] as List).map((item) => Suggestion.fromJson(item)).toList(),
    );
  }
}

class Suggestion {
  final String id;
  final String name;
  final double probability;
  final List<SimilarImage> similarImages;
  final SuggestionDetails? details;
  final String scientificName;

  Suggestion({
    required this.id,
    required this.name,
    required this.probability,
    required this.similarImages,
    this.details,
    required this.scientificName,
  });

  factory Suggestion.fromJson(Map<String, dynamic> json) {
    return Suggestion(
      id: json['id'],
      name: json['name'],
      probability: json['probability'].toDouble(),
      similarImages:
          (json['similar_images'] as List).map((item) => SimilarImage.fromJson(item)).toList(),
      details: json['details'] != null ? SuggestionDetails.fromJson(json['details']) : null,
      scientificName: json['scientific_name'],
    );
  }
}

class SuggestionDetails {
  final String language;
  final String entityId;

  SuggestionDetails({required this.language, required this.entityId});

  factory SuggestionDetails.fromJson(Map<String, dynamic> json) {
    return SuggestionDetails(language: json['language'], entityId: json['entity_id']);
  }
}

class SimilarImage {
  final String id;
  final String url;
  final String? licenseName;
  final String? licenseUrl;
  final String? citation;
  final double similarity;
  final String urlSmall;

  SimilarImage({
    required this.id,
    required this.url,
    this.licenseName,
    this.licenseUrl,
    this.citation,
    required this.similarity,
    required this.urlSmall,
  });

  factory SimilarImage.fromJson(Map<String, dynamic> json) {
    return SimilarImage(
      id: json['id'],
      url: json['url'],
      licenseName: json['license_name'],
      licenseUrl: json['license_url'],
      citation: json['citation'],
      similarity: json['similarity'].toDouble(),
      urlSmall: json['url_small'],
    );
  }
}
