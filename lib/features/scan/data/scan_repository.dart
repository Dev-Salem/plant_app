import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:collection';
import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:plant_app/features/auth/data/auth_repository.dart';
import 'package:plant_app/features/scan/domain/entities.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scan_repository.g.dart';

class ScanRepository {
  ScanRepository({required this.client});
  final Client client;
  Future<PlantScanResponse> scanPlant({
    required String imagePath,
    required double longitude,
    required double latitude,
  }) async {
    try {
      final functions = Functions(client);

      // Read the image file and convert it to base64
      final File imageFile = File(imagePath);
      final List<int> imageBytes = await imageFile.readAsBytes();
      final String base64Image = base64Encode(imageBytes);

      // Prepare the payload for the function
      // Note: Don't include the data:image/jpeg;base64 prefix here
      // as we handle that in the Appwrite function
      final payload = {
        'images': [base64Image],
        'longitude': longitude,
        'latitude': latitude,
      };
      final body = json.encode(payload);

      // Execute the Appwrite function
      final execution = await functions.createExecution(
        functionId: '67e94c1a0014fbb416bc', // Replace with your actual function ID
        body: body,
      );
      // log('Function execution response: ${execution.toMap()}');

      // Check for errors in the function execution
      if (execution.status != 'completed' || execution.errors.isNotEmpty) {
        log(execution.errors);
        throw Exception('Function execution failed: ${execution.errors}');
      }
      log("\n===================\n");
      // Parse and return the response
      final response = json.decode(execution.responseBody) as Map<String, dynamic>;
      log("\n===================\n");
      log(response.toString());
      log("\n===================\n");
      return PlantScanResponse.fromJson(response);
    } catch (e) {
      // Log the error and rethrow
      log('Error in scanPlant: $e');
      rethrow;
    }
  }

  Future<void> saveAccessToken(String token) async {
    try {
      final databases = Databases(client);
      final account = await Account(client).get();
      // Create document with the token
      await databases.createDocument(
        databaseId: 'planty-db-id', // Replace with your database ID
        collectionId: 'access-tokens', // Replace with your collection ID
        documentId: ID.unique(),
        data: {'access-token': token, "user-id": account.$id},
      );
    } catch (e) {
      log('Error saving access token: $e');
      rethrow;
    }
  }

  Future<void> deleteAccessToken(String token) async {
    try {
      final databases = Databases(client);
      final account = await Account(client).get();
      final documents = await databases.listDocuments(
        databaseId: "planty-db-id",
        collectionId: 'access-tokens',
        queries: [Query.equal('user-id', account.$id), Query.equal('token', token)],
      );
      final document = documents.documents.first;
      await databases.deleteDocument(
        databaseId: document.$databaseId,
        collectionId: document.$collectionId,
        documentId: document.$id,
      );
    } catch (e) {
      log('Error saving access token: $e');
      rethrow;
    }
  }

  Future<List<PlantScanResponse>> getScans() async {
    try {
      final accessTokens = (await _getAccessTokens()).toSet();
      log("Getting scans for tokens: $accessTokens");

      if (accessTokens.isEmpty) {
        return [];
      }

      // Use Future.wait to properly await all async operations
      final results = await Future.wait(accessTokens.map((token) => getScan(token)));

      return results;
    } catch (e) {
      log('Error fetching scans: $e');
      rethrow;
    }
  }

  Future<PlantScanResponse> getScan(String token) async {
    try {
      final execution = await Functions(client).createExecution(
        functionId: 'get-plant-id',
        body: json.encode({"access-token": token}),
      );
      final response = json.decode(execution.responseBody) as Map<String, dynamic>;
      return PlantScanResponse.fromJson(response);
    } catch (e) {
      log('Error saving access token: $e');
      rethrow;
    }
  }

  Future<List<String>> _getAccessTokens() async {
    final databases = Databases(client);
    final account = await Account(client).get();
    final documents = await databases.listDocuments(
      databaseId: "planty-db-id",
      collectionId: 'access-tokens',
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

final scanResultProvider = FutureProvider.family<PlantScanResponse, String>((
  ref,
  String imagePath,
) async {
  final position = await Geolocator.getCurrentPosition();

  // Call repository method
  final scanRepository = ref.read(scanRepositoryProvider);
  final result = await scanRepository.scanPlant(
    imagePath: imagePath,
    longitude: position.longitude,
    latitude: position.latitude,
  );
  return result;
});

// Change this to be auto-refreshable
@riverpod
Future<List<PlantScanResponse>> plantDetections(Ref ref) async {
  // This will ensure the provider is properly re-executed when refreshed
  return ref.watch(scanRepositoryProvider).getScans();
}
