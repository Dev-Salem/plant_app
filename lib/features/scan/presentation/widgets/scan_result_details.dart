import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:plant_app/features/scan/domain/entities.dart';

class ScanResultDetails extends StatelessWidget {
  final PlantScanResponse scanResponse;

  const ScanResultDetails({super.key, required this.scanResponse});

  @override
  Widget build(BuildContext context) {
    // This widget is kept for backward compatibility
    // Main functionality has been moved to PlantDetailsView

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Plant Scan Summary',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          const SizedBox(height: 12),

          // Basic plant info
          Text(
            'Plant identified as: ${_getPlantName()}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),

          Text(
            'Health status: ${scanResponse.result.isHealthy ? "Healthy" : "Needs attention"}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: scanResponse.result.isHealthy ? Colors.green : Colors.orange,
            ),
          ),

          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.home),
            label: const Text('Back to Home'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    ).animate().fade(duration: 400.ms);
  }

  String _getPlantName() {
    if (scanResponse.result.disease.suggestions.isNotEmpty) {
      return scanResponse.result.disease.suggestions.first.name;
    }
    return "Unknown Plant";
  }
}
