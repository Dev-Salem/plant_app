import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:plant_app/core/assets.dart';
import 'package:plant_app/core/routes.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [context.primaryColor.withOpacity(0.1), Colors.transparent],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Text(
                      'Welcome to Planty 🌿',
                      style: context.displayMedium?.copyWith(
                        color: context.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.2, end: 0),
                    16.heightBox,
                    Text(
                          'Diagnose plant diseases easily with AI and get instant solutions!',
                          style: context.titleLarge?.copyWith(
                            color: context.primaryColor.withOpacity(0.8),
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        )
                        .animate()
                        .fadeIn(duration: 800.ms, delay: 200.ms)
                        .slideY(begin: 0.2, end: 0),
                  ],
                ),
              ),
              const Spacer(),
              Image.asset(Assets.brainPlant, height: 265, fit: BoxFit.contain)
                  .animate()
                  .scaleXY(begin: 0.8, end: 1.0, duration: 1200.ms, curve: Curves.easeOutBack)
                  .fadeIn(duration: 800.ms),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(24),
                child: FilledButton.icon(
                      onPressed: () => Navigator.of(context).pushNamed(Routes.onboarding),
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Get Started'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.all(12),
                        minimumSize: const Size(double.infinity, 24),
                        textStyle: context.titleMedium,
                      ),
                    )
                    .animate(onPlay: (controller) => controller.repeat(reverse: true))
                    .scaleXY(begin: 1, end: 1.02, duration: 2000.ms),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
