import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:plant_app/features/scan/presentation/widgets/camera_widget.dart';
import 'package:plant_app/features/scan/data/scan_repository.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String? _currentAddress;
  bool _isLoadingLocation = true;
  String? _locationName;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _currentAddress = 'Location permissions are denied';
            _locationName = 'Unknown Location';
            _isLoadingLocation = false;
          });
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition();

      // Get location name using reverse geocoding
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        _locationName = place.locality ?? place.subAdministrativeArea ?? 'Unknown Location';
      }

      setState(() {
        _currentAddress = '${position.latitude}, ${position.longitude}';
        _isLoadingLocation = false;
      });
    } catch (e) {
      setState(() {
        _currentAddress = 'Error getting location';
        _locationName = 'Unknown Location';
        _isLoadingLocation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          Text(
                'Welcome Back',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              )
              .animate()
              .fade(duration: 500.ms)
              .slideY(begin: 0.2, end: 0, duration: 500.ms, curve: Curves.easeOutQuad),
          Text(
                _isLoadingLocation
                    ? "Finding your location..."
                    : "From ${_locationName ?? "Unknown Location"} ✨",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              )
              .animate()
              .fade(duration: 500.ms, delay: 200.ms)
              .slideY(
                begin: 0.2,
                end: 0,
                duration: 500.ms,
                delay: 200.ms,
                curve: Curves.easeOutQuad,
              ),
          const SizedBox(height: 24),
          Consumer(
            builder: (context, ref, child) {
              // final scanState = ref.watch(scanNotifierProvider);

              return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => const CameraScreen(
                                onImageCaptured: null, // We'll handle this in CameraScreen
                              ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF43A047), Color(0xFF2E7D32)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 60,
                            color: Colors.white.withOpacity(0.95),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Scan Plant',
                            style: TextStyle(
                              fontSize: 26,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Identify plant diseases instantly',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white.withOpacity(0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .animate()
                  .fade(duration: 700.ms, delay: 300.ms)
                  .scale(begin: const Offset(0.95, 0.95), duration: 700.ms, delay: 300.ms)
                  .shimmer(duration: 1200.ms, delay: 1000.ms);
            },
          ),
          const SizedBox(height: 32),

          Text(
                'Recent Diagnoses',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              )
              .animate()
              .fade(duration: 500.ms, delay: 400.ms)
              .slideX(begin: -0.1, end: 0, duration: 500.ms, delay: 400.ms),
          const SizedBox(height: 14),
          _buildRecentDiagnoses(),
          const SizedBox(height: 32),
          Text(
                'Disease Alerts',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              )
              .animate()
              .fade(duration: 500.ms, delay: 500.ms)
              .slideX(begin: -0.1, end: 0, duration: 500.ms, delay: 500.ms),
          const SizedBox(height: 14),
          _buildDiseaseAlerts(),
        ],
      ),
    );
  }

  Widget _buildRecentDiagnoses() {
    return Consumer(
      builder: (context, ref, child) {
        // We could implement a provider to keep track of recent scans if needed
        // For now, just showing a placeholder
        return Column(
          children: List.generate(
                2,
                (index) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.withOpacity(0.1),
                      child: Icon(Icons.eco, color: Colors.green[700]),
                    ),
                    title: Text(
                      'Plant Disease ${index + 1}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        'Diagnosed on ${DateTime.now().toString().split(' ')[0]}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
                  ),
                ),
              )
              .animate(interval: 200.ms)
              .fade(duration: 400.ms, delay: 600.ms)
              .slideY(
                begin: 0.3,
                end: 0,
                duration: 400.ms,
                delay: 600.ms,
                curve: Curves.easeOutQuad,
              ),
        );
      },
    );
  }

  Widget _buildDiseaseAlerts() {
    return Card(
          elevation: 0,
          color: const Color(0xFFFFF3E0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'High risk of fungal infections',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Due to recent weather conditions in your area',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fade(duration: 500.ms, delay: 800.ms)
        .slideY(begin: 0.3, end: 0, duration: 500.ms, delay: 800.ms);
  }
}
