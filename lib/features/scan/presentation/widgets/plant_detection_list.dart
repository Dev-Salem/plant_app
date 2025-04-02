import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_app/core/errors/error_messages.dart';
import 'package:plant_app/features/scan/data/scan_repository.dart';
import 'package:plant_app/features/scan/domain/entities.dart';
import 'package:plant_app/features/scan/presentation/widgets/plant_details_view.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PlantDetectionList extends ConsumerWidget {
  const PlantDetectionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use autoDispose and watch plantDetectionsProvider
    final plantsAsync = ref.watch(plantDetectionsProvider);

    return plantsAsync.when(
      data: (plants) {
        if (plants.isEmpty) {
          return const EmptyPlantState();
        }
        return PlantsList(plants: plants);
      },
      loading:
          () => const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
            ),
          ),
      error:
          (error, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  Text(
                   ErrorHandler.getFriendlyErrorMessage(error as Exception),
                    style: const TextStyle(color: Colors.red),
                  ),
                  TextButton(
                    onPressed: () => ref.invalidate(plantDetectionsProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}

class EmptyPlantState extends StatelessWidget {
  const EmptyPlantState({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.eco_outlined, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No plant scans yet',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Your recent plant scans will appear here',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animate().fade(duration: 400.ms, delay: 600.ms);
  }
}

class PlantsList extends StatelessWidget {
  final List<PlantScanResponse> plants;

  const PlantsList({super.key, required this.plants});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: plants.length,
      itemBuilder: (context, index) {
        final plant = plants[index];
        return _buildPlantCard(context, plant, index);
      },
    );
  }

  Widget _buildPlantCard(BuildContext context, PlantScanResponse plant, int index) {
    String plantName = "Unknown Plant";
    String condition = "Unknown";
    double confidence = 0.0;

    // Get plant name from crop or disease suggestions
    if (plant.result.crop.suggestions.isNotEmpty) {
      plantName = plant.result.crop.suggestions.first.name;
      condition = plant.result.crop.suggestions.first.scientificName;
      confidence = plant.result.crop.suggestions.first.probability;
    } else if (plant.result.disease.suggestions.isNotEmpty) {
      plantName = plant.result.disease.suggestions.first.name;
      condition = plant.result.disease.suggestions.first.name;
      confidence = plant.result.disease.suggestions.first.probability;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PlantDetailsView(scanResult: plant)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Plant image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child:
                    plant.input.images.isNotEmpty
                        ? Image.network(
                          plant.input.images.first,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image, color: Colors.grey),
                            );
                          },
                        )
                        : Container(
                          width: 80,
                          height: 80,
                          color: Colors.green[200],
                          child: const Icon(Icons.spa, color: Colors.white),
                        ),
              ),
              const SizedBox(width: 16),
              // Plant info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plantName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Condition: $condition',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Confidence indicator
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: confidence,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              confidence > 0.7
                                  ? Colors.green
                                  : confidence > 0.4
                                  ? Colors.orange
                                  : Colors.red,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(confidence * 100).toInt()}%',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    ).animate().fade(duration: 400.ms, delay: (400 + (index * 100)).ms);
  }
}
