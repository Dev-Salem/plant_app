import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_app/core/app_theme.dart';
import 'package:plant_app/core/constants/routes.dart';
import 'package:plant_app/features/auth/data/auth_repository.dart';
import 'package:plant_app/features/auth/presentation/screens/verify_otp_screen.dart';
import 'package:plant_app/features/onboarding/screens/onboarding_screen.dart';
import 'package:plant_app/features/onboarding/screens/welcome_screen.dart';
import 'package:plant_app/features/scan/domain/entities.dart';
import 'package:plant_app/features/scan/presentation/screens/home_screen.dart';
import 'package:plant_app/features/scan/presentation/widgets/plant_details_view.dart';

void main() {
  runApp(ProviderScope(child: const MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final authStatus = ref.watch(authStatusProvider);
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case Routes.welcome:
            return MaterialPageRoute(builder: (context) => const WelcomeScreen());
          case Routes.onboarding:
            return MaterialPageRoute(builder: (context) => const OnboardingScreen());
          case Routes.verifyOtp:
            final email = settings.arguments as String;
            return MaterialPageRoute(builder: (context) => VerifyOtpScreen(email: email));
          case Routes.home:
            return MaterialPageRoute(builder: (context) => const HomeScreen());
          case Routes.plantDetails:
            return MaterialPageRoute(
              builder:
                  (context) =>
                      PlantDetailsView(scanResult: settings.arguments as PlantScanResponse),
            );
          default:
            return null;
        }
      },
      home: authStatus.when(
        data: (isLoggedIn) => isLoggedIn ? const HomeScreen() : const WelcomeScreen(),
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error:
            (error, stackTrace) => Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${error.toString()}'),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => ref.refresh(authStatusProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
