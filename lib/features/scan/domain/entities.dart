class PlantScanResponse {
  final String accessToken;
  final String modelVersion;
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
  final String health;
  final List<String> images;
  final String datetime;

  InputData({
    required this.latitude,
    required this.longitude,
    required this.similarImages,
    required this.health,
    required this.images,
    required this.datetime,
  });

  factory InputData.fromJson(Map<String, dynamic> json) {
    return InputData(
      latitude: json['latitude'],
      longitude: json['longitude'],
      similarImages: json['similar_images'],
      health: json['health'],
      images: List<String>.from(json['images']),
      datetime: json['datetime'],
    );
  }
}

class ScanResult {
  final Disease disease;
  final bool isHealthy;
  final bool isPlant;

  ScanResult({required this.disease, required this.isHealthy, required this.isPlant});

  factory ScanResult.fromJson(Map<String, dynamic> json) {
    return ScanResult(
      disease: Disease.fromJson(json['disease']),
      isHealthy: json['is_healthy']['binary'],
      isPlant: json['is_plant']['binary'],
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

class Suggestion {
  final String id;
  final String name;
  final double probability;
  final List<SimilarImage> similarImages;

  Suggestion({
    required this.id,
    required this.name,
    required this.probability,
    required this.similarImages,
  });

  factory Suggestion.fromJson(Map<String, dynamic> json) {
    return Suggestion(
      id: json['id'],
      name: json['name'],
      probability: json['probability'].toDouble(),
      similarImages:
          (json['similar_images'] as List).map((item) => SimilarImage.fromJson(item)).toList(),
    );
  }
}

class SimilarImage {
  final String id;
  final String url;
  final String licenseName;
  final String licenseUrl;
  final String citation;
  final double similarity;
  final String urlSmall;

  SimilarImage({
    required this.id,
    required this.url,
    required this.licenseName,
    required this.licenseUrl,
    required this.citation,
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
