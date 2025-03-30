import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:plant_app/features/scan/presentation/controllers/scan_controller.dart';

class ScanResultDetails extends StatelessWidget {
  final ScanResult scanResult;

  const ScanResultDetails({super.key, required this.scanResult});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Plant Information'),
          _buildInfoCard(context),

          if (scanResult.diseaseAnalysis != null) ...[
            const SizedBox(height: 20),
            _buildSectionTitle('Health Analysis'),
            _buildHealthCard(),
          ],

          const SizedBox(height: 20),
          _buildSectionTitle('Similar Matches'),
          _buildSuggestionsList(),

          if (scanResult.diseaseAnalysis != null) ...[
            const SizedBox(height: 20),
            _buildSectionTitle('Potential Issues'),
            _buildDiseasesList(),
          ],

          if (scanResult.diseaseAnalysis?.question != null) ...[
            const SizedBox(height: 20),
            _buildSectionTitle('Diagnosis Question'),
            _buildQuestionCard(),
          ],

          const SizedBox(height: 20),
          _buildSectionTitle('Location Data'),
          _buildLocationCard(),

          const SizedBox(height: 30),
          Center(
            child: ElevatedButton.icon(
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
          ),
        ],
      ),
    );
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
      ).animate().fade(duration: 400.ms).slideX(begin: -0.1, end: 0),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              'Plant Detected',
              scanResult.isPlant ? 'Yes' : 'No, this might not be a plant',
              scanResult.isPlant ? Icons.check_circle : Icons.cancel,
              scanResult.isPlant ? Colors.green : Colors.red,
            ),
            const Divider(),
            _buildInfoRow(
              'Scientific Name',
              scanResult.plantName,
              Icons.spa,
              Colors.green[700]!,
            ),
            const Divider(),
            _buildInfoRow(
              'Scan Date',
              _formatDate(scanResult.scanDate),
              Icons.calendar_today,
              Colors.blue[700]!,
            ),
          ],
        ),
      ),
    ).animate().fade(duration: 500.ms, delay: 100.ms);
  }

  Widget _buildHealthCard() {
    final isHealthy = scanResult.isHealthy;
    final healthProbability = scanResult.healthProbability;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              'Plant Health Status',
              isHealthy ? 'Healthy' : 'Unhealthy',
              isHealthy ? Icons.check_circle : Icons.warning,
              isHealthy ? Colors.green : Colors.orange,
            ),
            const Divider(),
            _buildInfoRow(
              'Health Confidence',
              scanResult.healthProbabilityFormatted,
              Icons.analytics,
              _getConfidenceColor(healthProbability),
            ),
            if (scanResult.topDisease != null) ...[
              const Divider(),
              _buildInfoRow(
                'Primary Issue',
                scanResult.topDisease!.name,
                Icons.healing,
                Colors.red[700]!,
              ),
            ],
          ],
        ),
      ),
    ).animate().fade(duration: 500.ms, delay: 100.ms);
  }

  Widget _buildQuestionCard() {
    final question = scanResult.diseaseAnalysis?.question;
    if (question == null) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      color: Colors.blue[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.help_outline, color: Colors.blue[700], size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    question.text,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildOptionButton(
                    "Yes",
                    question.yesOption?.name ?? "Unknown",
                    Colors.green[100]!,
                    Colors.green[800]!,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildOptionButton(
                    "No",
                    question.noOption?.name ?? "Unknown",
                    Colors.red[100]!,
                    Colors.red[800]!,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fade(duration: 500.ms, delay: 300.ms);
  }

  Widget _buildOptionButton(String action, String result, Color bgColor, Color textColor) {
    return Card(
      color: bgColor,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Column(
          children: [
            Text(
              action,
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              result,
              textAlign: TextAlign.center,
              style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 14)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsList() {
    if (scanResult.suggestions.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No plant suggestions available'),
        ),
      );
    }

    return Column(
      children:
          scanResult.suggestions
              .take(3) // Show only top 3 suggestions
              .map((suggestion) => _buildSuggestionCard(suggestion))
              .toList(),
    );
  }

  Widget _buildDiseasesList() {
    final suggestions = scanResult.diseaseAnalysis?.suggestions;

    if (suggestions == null || suggestions.isEmpty) {
      return const Card(
        child: Padding(padding: EdgeInsets.all(16.0), child: Text('No issues detected')),
      );
    }

    return Column(
      children:
          suggestions
              .take(3) // Show only top 3 disease suggestions
              .map((suggestion) => _buildDiseaseCard(suggestion))
              .toList(),
    );
  }

  Widget _buildDiseaseCard(DiseaseSuggestion suggestion) {
    final probabilityPercentage = (suggestion.probability * 100).toStringAsFixed(1);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading:
            suggestion.similarImages.isNotEmpty &&
                    suggestion.similarImages.first.urlSmall != null
                ? CircleAvatar(
                  backgroundImage: NetworkImage(suggestion.similarImages.first.urlSmall!),
                  backgroundColor: Colors.grey[200],
                )
                : CircleAvatar(
                  backgroundColor: Colors.red[100],
                  child: Icon(Icons.healing, color: Colors.red[800]),
                ),
        title: Text(suggestion.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Likelihood: $probabilityPercentage%'),
        trailing: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getConfidenceColor(suggestion.probability),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$probabilityPercentage%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    ).animate().fade(duration: 400.ms, delay: 200.ms);
  }

  Widget _buildSuggestionCard(PlantSuggestion suggestion) {
    final similarityPercentage = (suggestion.probability * 100).toStringAsFixed(1);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading:
            suggestion.similarImages.isNotEmpty &&
                    suggestion.similarImages.first.urlSmall != null
                ? CircleAvatar(
                  backgroundImage: NetworkImage(suggestion.similarImages.first.urlSmall!),
                  backgroundColor: Colors.grey[200],
                )
                : CircleAvatar(
                  backgroundColor: Colors.green[100],
                  child: Icon(Icons.spa, color: Colors.green[800]),
                ),
        title: Text(suggestion.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Match confidence: $similarityPercentage%'),
        trailing: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getConfidenceColor(suggestion.probability),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$similarityPercentage%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    ).animate().fade(duration: 400.ms, delay: 200.ms);
  }

  Widget _buildLocationCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow(
              'Coordinates',
              '${scanResult.latitude.toStringAsFixed(6)}, ${scanResult.longitude.toStringAsFixed(6)}',
              Icons.location_on,
              Colors.red,
            ),
            const Divider(),
            _buildInfoRow('Scan Status', scanResult.status, Icons.info_outline, Colors.blue),
          ],
        ),
      ),
    ).animate().fade(duration: 500.ms, delay: 300.ms);
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return Colors.green;
    if (confidence >= 0.5) return Colors.orange;
    return Colors.red;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
