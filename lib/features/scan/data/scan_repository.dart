import 'dart:convert';
import 'dart:developer';
import 'dart:io';
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
    final functions = Functions(client);

    final File imageFile = File(imagePath);
    final List<int> imageBytes = await imageFile.readAsBytes();
    final String base64Image = base64Encode(imageBytes);

    final payload = {
      'images': [base64Image],
      'longitude': longitude,
      'latitude': latitude,
    };
    final body = json.encode(payload);

    final execution = await functions.createExecution(
      functionId: '67e94c1a0014fbb416bc',
      body: body,
    );

    final response = json.decode(execution.responseBody) as Map<String, dynamic>;
    return PlantScanResponse.fromJson(response);
  }

  Future<void> saveAccessToken(String token) async {
    final databases = Databases(client);
    final account = await Account(client).get();
    // Create document with the token
    await databases.createDocument(
      databaseId: 'planty-db-id', // Replace with your database ID
      collectionId: 'access-tokens', // Replace with your collection ID
      documentId: ID.unique(),
      data: {'access-token': token, "user-id": account.$id},
    );
  }

  Future<void> deleteAccessToken(String token) async {
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
    final execution = await Functions(
      client,
    ).createExecution(functionId: 'get-plant-id', body: json.encode({"access-token": token}));
    final response = json.decode(execution.responseBody) as Map<String, dynamic>;
    return PlantScanResponse.fromJson(response);
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
