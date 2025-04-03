import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_app/src/features/scan/data/scan_repository.dart';
import 'package:plant_app/src/features/scan/domain/models/captured_image.dart';
import 'package:plant_app/src/features/scan/presentation/widgets/plant_details_view.dart';

class ScanResultScreen extends ConsumerWidget {
  final CapturedImage? capturedImage;
  final String? imagePath;

  const ScanResultScreen({super.key, this.capturedImage, this.imagePath});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Handle both CapturedImage and legacy String path
    if (capturedImage == null && imagePath == null) {
      return _buildErrorScreen(context, "No image provided");
    }

    final scanResultAsync =
        capturedImage != null
            ? ref.watch(scanResultWithImageProvider.call(capturedImage!))
            : ref.watch(scanResultProvider.call(imagePath!));

    return scanResultAsync.when(
      loading:
          () => Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Colors.green),
                  const SizedBox(height: 24),
                  Text(
                    'Analyzing your plant...',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
          ),
      error: (error, stack) {
        log(error.toString());
        log(stack.toString());
        return _buildErrorScreen(context, error.toString());
      },
      data: (scanResult) => Scaffold(body: PlantDetailsView(scanResult: scanResult)),
    );
  }

  Widget _buildErrorScreen(BuildContext context, String errorMessage) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Error'),
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
              const SizedBox(height: 24),
              Text(
                'Something went wrong',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ).animate().fade(duration: 300.ms).slideY(begin: 0.2, end: 0),
      ),
    );
  }
}
