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
