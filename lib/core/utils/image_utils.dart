import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_app/features/scan/domain/models/captured_image.dart';

class ImageUtils {
  /// Pick an image from the gallery or camera and return it as a CapturedImage object
  static Future<CapturedImage?> pickImage({
    required ImageSource source,
    int quality = 80,
  }) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source, imageQuality: quality);

      if (pickedFile == null) return null;

      final bytes = await pickedFile.readAsBytes();
      final name = pickedFile.name;

      return CapturedImage(path: kIsWeb ? null : pickedFile.path, bytes: bytes, name: name);
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }

  /// Convert image bytes to a base64 string for API requests
  static String bytesToBase64(Uint8List bytes) {
    return base64Encode(bytes);
  }

  /// Get the file extension from a file name
  static String getFileExtension(String fileName) {
    return fileName.split('.').last.toLowerCase();
  }
}
