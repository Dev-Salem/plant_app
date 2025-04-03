import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:plant_app/core/constants/appwrite_constants.dart';
import 'package:plant_app/core/utils/image_utils.dart';
import 'package:plant_app/features/auth/data/auth_repository.dart';
import 'package:plant_app/features/scan/domain/entities.dart';
import 'package:plant_app/features/scan/domain/models/captured_image.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scan_repository.g.dart';

class ScanRepository {
  ScanRepository({required this.client});
  final Client client;

  Future<PlantScanResponse> scanPlantWithImage({
    required CapturedImage capturedImage,
    required double longitude,
    required double latitude,
  }) async {
    final functions = Functions(client);

    // Convert image to base64 string
    final String base64Image = ImageUtils.bytesToBase64(capturedImage.bytes);

    // Prepare the payload
    final payload = {
      'images': [base64Image],
      'longitude': longitude,
      'latitude': latitude,
    };
    final body = json.encode(payload);

    // Execute function
    final execution = await functions.createExecution(
      functionId: AppwriteConstants.scanPlantFunctionId,
      body: body,
    );

    final response = json.decode(execution.responseBody) as Map<String, dynamic>;
    return PlantScanResponse.fromJson(response);
  }

  // Legacy method for backward compatibility
  Future<PlantScanResponse> scanPlant({
    required String imagePath,
    required double longitude,
    required double latitude,
  }) async {
    if (kIsWeb) {
      throw UnsupportedError(
        'Direct file path is not supported on web. Use scanPlantWithImage instead.',
      );
    }

    final File imageFile = File(imagePath);
    final List<int> imageBytes = await imageFile.readAsBytes();

    // Create CapturedImage from file
    final capturedImage = CapturedImage(
      path: imagePath,
      bytes: Uint8List.fromList(imageBytes),
      name: imagePath.split('/').last,
    );

    return scanPlantWithImage(
      capturedImage: capturedImage,
      longitude: longitude,
      latitude: latitude,
    );
  }

  Future<void> saveAccessToken(String token) async {
    final databases = Databases(client);
    final account = await Account(client).get();
    // Create document with the token
    await databases.createDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.accessTokensCollection,
      documentId: ID.unique(),
      data: {'access-token': token, "user-id": account.$id},
    );
  }

  Future<void> deleteAccessToken(String token) async {
    final databases = Databases(client);
    final account = await Account(client).get();
    final documents = await databases.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.accessTokensCollection,
      queries: [Query.equal('user-id', account.$id), Query.equal('token', token)],
    );
    final document = documents.documents.first;
    await databases.deleteDocument(
      databaseId: document.$databaseId,
      collectionId: document.$collectionId,
      documentId: document.$id,
    );
  }

  Future<List<PlantScanResponse>> getScans() async {
    final accessTokens = (await _getAccessTokens()).toSet();
    log("Get scans was called with these tokens: $accessTokens");

    if (accessTokens.isEmpty) {
      return [];
    }

    final results = await Future.wait(accessTokens.map((token) => getScan(token)));

    return results;
  }

  Future<PlantScanResponse> getScan(String token) async {
    final execution = await Functions(client).createExecution(
      functionId: AppwriteConstants.getPlantIdFunctionId,
      body: json.encode({"access-token": token}),
    );
    final response = json.decode(execution.responseBody) as Map<String, dynamic>;
    return PlantScanResponse.fromJson(response);
  }

  Future<List<String>> _getAccessTokens() async {
    final databases = Databases(client);
    final account = await Account(client).get();
    final documents = await databases.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.accessTokensCollection,
      queries: [Query.equal('user-id', account.$id)],
    );
    return documents.documents.map((d) => d.data["access-token"] as String).toList();
  }
}

@Riverpod(keepAlive: true)
ScanRepository scanRepository(Ref ref) {
  final client = ref.watch(appwriteClientProvider);
  return ScanRepository(client: client);
}

// Updated provider to handle CapturedImage
final scanResultWithImageProvider = FutureProvider.family<PlantScanResponse, CapturedImage>((
  ref,
  CapturedImage capturedImage,
) async {
  final position = await Geolocator.getCurrentPosition();
  final scanRepository = ref.read(scanRepositoryProvider);
  final result = await scanRepository.scanPlantWithImage(
    capturedImage: capturedImage,
    longitude: position.longitude,
    latitude: position.latitude,
  );
  return result;
});

// Legacy provider for backward compatibility
final scanResultProvider = FutureProvider.family<PlantScanResponse, String>((
  ref,
  String imagePath,
) async {
  final position = await Geolocator.getCurrentPosition();
  final scanRepository = ref.read(scanRepositoryProvider);
  final result = await scanRepository.scanPlant(
    imagePath: imagePath,
    longitude: position.longitude,
    latitude: position.latitude,
  );
  return result;
});

@riverpod
Future<List<PlantScanResponse>> plantDetections(Ref ref) async {
  return ref.watch(scanRepositoryProvider).getScans();
}
