import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:plant_app/features/scan/domain/entities.dart';

class PlantDetailsView extends StatelessWidget {
  final PlantScanResponse scanResult;

  const PlantDetailsView({super.key, required this.scanResult});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildSliverAppBar(context),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildOverviewCard(),
                const SizedBox(height: 20),
                if (!_isHealthy()) ...[
                  _buildSectionTitle('Health Analysis'),
                  _buildHealthCard(),
                  const SizedBox(height: 20),
                ],
                if (scanResult.result.disease.suggestions.isNotEmpty) ...[
                  _buildSectionTitle('Similar Conditions'),
                  _buildSimilarPlantsSection(),
                  const SizedBox(height: 20),
                ],
                _buildSectionTitle('Scan Details'),
                _buildScanDetailsCard(),
                const SizedBox(height: 30),
                _buildActionButtons(context),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Plant image from scan
            Hero(
              tag: 'plant_image',
              child:
                  scanResult.input.images.isNotEmpty
                      ? Image.network(
                        scanResult.input.images.first,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.broken_image,
                              size: 80,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                      : Container(
                        color: Colors.green[200],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
            ),
            // Gradient overlay for better text visibility
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),
            // Bottom plant info
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plant name
                  Text(
                    _getPlantName(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(blurRadius: 3.0, color: Colors.black)],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Status badges row
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildStatusBadge(
                        _isHealthy() ? 'Healthy' : 'Unhealthy',
                        _isHealthy() ? Colors.green : Colors.orange,
                        Icons.favorite,
                      ),
                      _buildStatusBadge(
                        '${(_getTopConfidence() * 100).toStringAsFixed(0)}% Match',
                        _getConfidenceColor(_getTopConfidence()),
                        Icons.verified,
                      ),
                      if (!_isHealthy() && scanResult.result.disease.suggestions.isNotEmpty)
                        _buildStatusBadge(
                          'Needs Attention',
                          Colors.red,
                          Icons.warning_amber_rounded,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        collapseMode: CollapseMode.pin,
      ),
      backgroundColor: Colors.green[700],
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {
            // Share functionality could be implemented here
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Share feature coming soon')));
          },
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String text, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Plant Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              'Scientific Name',
              _getScientificName(),
              Icons.spa,
              Colors.green[700]!,
            ),
            const Divider(),
            _buildInfoRow('ID', scanResult.accessToken, Icons.category, Colors.blue[700]!),
            if (true) ...[
              const Divider(),
              _buildInfoRow(
                'Condition',
                scanResult.result.disease.suggestions.isNotEmpty
                    ? scanResult.result.disease.suggestions.first.name
                    : 'Unknown issue',
                Icons.healing,
                Colors.orange,
              ),
            ],
          ],
        ),
      ),
    ).animate().fade(duration: 400.ms, delay: 100.ms);
  }

  Widget _buildHealthCard() {
    final isHealthy = _isHealthy();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isHealthy ? Icons.check_circle : Icons.warning_amber_rounded,
                  color: isHealthy ? Colors.green : Colors.orange,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  isHealthy ? 'Plant is healthy' : 'Plant needs attention',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isHealthy ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildHealthMeter(_getHealthScore()),
            if (!isHealthy && scanResult.result.disease.suggestions.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Detected: ${scanResult.result.disease.suggestions.first.name}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Confidence: ${(scanResult.result.disease.suggestions.first.probability * 100).toStringAsFixed(0)}%',
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ],
        ),
      ),
    ).animate().fade(duration: 400.ms, delay: 200.ms);
  }

  Widget _buildHealthMeter(double healthScore) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Health Score',
              style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold),
            ),
            Text(
              '${(healthScore * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                color: _getHealthColor(healthScore),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: healthScore,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(_getHealthColor(healthScore)),
          minHeight: 10,
          borderRadius: BorderRadius.circular(5),
        ),
      ],
    );
  }

  Widget _buildSimilarPlantsSection() {
    final suggestions = scanResult.result.disease.suggestions;

    if (suggestions.isEmpty) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No similar plants found in our database.'),
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          final similarImages = suggestion.similarImages;

          return Container(
            width: 180,
            margin: const EdgeInsets.only(right: 12),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  Expanded(
                    child:
                        similarImages.isNotEmpty
                            ? Image.network(
                              similarImages.first.urlSmall,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.image_not_supported, size: 40),
                                );
                              },
                            )
                            : Container(
                              color: Colors.green[100],
                              child: const Center(child: Icon(Icons.spa)),
                            ),
                  ),
                  // Info
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          suggestion.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              'Match: ${(suggestion.probability * 100).toStringAsFixed(0)}%',
                              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.check_circle,
                              size: 16,
                              color: _getConfidenceColor(suggestion.probability),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fade(duration: 400.ms, delay: 200.ms + (index * 100).ms);
        },
      ),
    );
  }

  Widget _buildScanDetailsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              'Scan Date',
              _formatDate(
                DateTime.fromMillisecondsSinceEpoch((scanResult.created * 1000).toInt()),
              ),
              Icons.calendar_today,
              Colors.purple,
            ),
            const Divider(),
            _buildInfoRow(
              'Location',
              '${scanResult.input.latitude.toStringAsFixed(4)}, ${scanResult.input.longitude.toStringAsFixed(4)}',
              Icons.location_on,
              Colors.red,
            ),
            const Divider(),
            _buildInfoRow(
              'Model Version',
              scanResult.modelVersion,
              Icons.data_usage,
              Colors.blue,
            ),
          ],
        ),
      ),
    ).animate().fade(duration: 400.ms, delay: 400.ms);
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          label: const Text('Back to Home'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[700],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(width: 16),
        OutlinedButton.icon(
          onPressed: () {
            // Save functionality could be implemented here
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Scan saved to your collection')));
          },
          icon: const Icon(Icons.save_alt),
          label: const Text('Save'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.green[700],
            side: BorderSide(color: Colors.green[700]!),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    ).animate().fade(duration: 400.ms, delay: 500.ms);
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2E7D32),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500))),
          Text(value, style: TextStyle(color: Colors.grey[800])),
        ],
      ),
    );
  }

  // Helper methods
  String _getPlantName() {
    // First check crop suggestions as they're more reliable
    if (scanResult.result.crop.suggestions.isNotEmpty) {
      return scanResult.result.crop.suggestions.first.name;
    }
    // Fallback to disease suggestions
    if (scanResult.result.disease.suggestions.isNotEmpty) {
      return scanResult.result.disease.suggestions.first.name;
    }
    return "Unknown Plant";
  }

  String _getScientificName() {
    // First check crop suggestions
    if (scanResult.result.crop.suggestions.isNotEmpty) {
      return scanResult.result.crop.suggestions.first.scientificName;
    }
    // Fallback to disease suggestions
    if (scanResult.result.disease.suggestions.isNotEmpty) {
      return scanResult.result.disease.suggestions.first.scientificName;
    }
    return "Unknown";
  }

  bool _isHealthy() {
    // Check if plant has been identified as healthy using PlantStatus
    if (scanResult.result.disease.suggestions.isNotEmpty) {
      final suggestion = scanResult.result.disease.suggestions.first;
      return suggestion.name.toLowerCase() == "healthy" &&
          suggestion.probability > scanResult.result.isPlant.threshold;
    }
    return false;
  }

  double _getHealthScore() {
    if (!_isHealthy() && scanResult.result.disease.suggestions.isNotEmpty) {
      // If unhealthy, base health score on inverse of disease probability
      // and consider the plant status threshold
      final diseaseProb = scanResult.result.disease.suggestions.first.probability;
      final threshold = scanResult.result.isPlant.threshold;
      return 1.0 - (diseaseProb * (1 - threshold));
    }
    // If healthy, use plant status probability
    return scanResult.result.isPlant.probability;
  }

  double _getTopConfidence() {
    if (scanResult.result.crop.suggestions.isNotEmpty) {
      return scanResult.result.crop.suggestions.first.probability;
    }
    if (scanResult.result.disease.suggestions.isNotEmpty) {
      return scanResult.result.disease.suggestions.first.probability;
    }
    return scanResult.result.isPlant.probability;
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return Colors.green;
    if (confidence >= 0.5) return Colors.orange;
    return Colors.red;
  }

  Color _getHealthColor(double healthScore) {
    if (healthScore >= 0.8) return Colors.green;
    if (healthScore >= 0.5) return Colors.orange;
    return Colors.red;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
