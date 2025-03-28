import 'package:flutter/material.dart';
import 'package:plant_app/core/app_theme.dart';
import 'package:plant_app/core/routes.dart';
import 'package:plant_app/features/onboarding/screens/onboarding_screen.dart';
import 'package:plant_app/features/onboarding/screens/welcome_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case Routes.welcome:
            return MaterialPageRoute(builder: (context) => const WelcomeScreen());
                      case Routes.onboarding:
            return MaterialPageRoute(builder: (context) => const OnboardingScreen());
          default:
            return null;
        }
      },
      initialRoute: Routes.welcome,
    );
  }
}
