import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class UsePhoneWidget extends StatelessWidget {
  const UsePhoneWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.smartphone, size: 100, color: Colors.white)
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .scale(delay: 300.ms)
                      .then()
                      .shake(delay: 700.ms, duration: 700.ms),

                  const SizedBox(height: 30),

                  const Text(
                        "Please Use a Mobile Device",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 600.ms)
                      .slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      "This application is designed for mobile use. For the best experience, please access it from a smartphone or adjust your browser window to mobile dimensions.",
                      style: TextStyle(fontSize: 16, color: Colors.white, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                  ).animate().fadeIn(delay: 800.ms, duration: 600.ms).slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 40),

                  _buildDeviceFrame()
                      .animate()
                      .fadeIn(delay: 1200.ms, duration: 800.ms)
                      .scale(begin: const Offset(0.8, 0.8)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceFrame() {
    return Container(
      width: 260,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
                width: 120,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white, width: 2),
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .shimmer(delay: 2000.ms, duration: 1800.ms),

          Positioned(
            bottom: 10,
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),

          const Positioned(
                top: 10,
                child: Icon(Icons.arrow_downward, color: Colors.green, size: 24),
              )
              .animate(onPlay: (controller) => controller.repeat())
              .moveY(begin: 0, end: 12, duration: 800.ms)
              .then(delay: 100.ms)
              .moveY(begin: 12, end: 0, duration: 800.ms),
        ],
      ),
    );
  }
}
