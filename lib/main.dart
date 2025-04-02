import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_app/core/errors/error_messages.dart';
import 'package:plant_app/core/theme/app_theme.dart';
import 'package:plant_app/core/constants/routes.dart';
import 'package:plant_app/core/widgets/use_phone_widget.dart';
import 'package:plant_app/features/auth/data/auth_repository.dart';
import 'package:plant_app/features/auth/presentation/screens/verify_otp_screen.dart';
import 'package:plant_app/features/market/presentation/screens/market_screen.dart';
import 'package:plant_app/features/market/presentation/screens/product_details_screen.dart';
import 'package:plant_app/features/onboarding/screens/onboarding_screen.dart';
import 'package:plant_app/features/onboarding/screens/welcome_screen.dart';
import 'package:plant_app/features/scan/domain/entities.dart';
import 'package:plant_app/features/scan/presentation/screens/home_screen.dart';
import 'package:plant_app/features/scan/presentation/widgets/plant_details_view.dart';
import 'package:plant_app/features/market/presentation/screens/cart_screen.dart';
import 'package:plant_app/features/market/presentation/screens/orders_screen.dart';
import 'package:plant_app/features/market/presentation/screens/order_details_screen.dart';
import 'package:plant_app/core/theme/theme_notifier.dart';

void main() {
  runApp(ProviderScope(child: const MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final authStatus = ref.watch(userProvider);
    return MaterialApp(
      theme: AppTheme.light.copyWith(
        appBarTheme: context.appBarTheme.copyWith(centerTitle: true),
      ),
      darkTheme: AppTheme.dark.copyWith(
        appBarTheme: context.appBarTheme.copyWith(centerTitle: true),
      ),
      debugShowCheckedModeBanner: false,
      themeMode: ref.watch(themeProvider),
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
          case Routes.market:
            return MaterialPageRoute(builder: (context) => const MarketScreen());
          case Routes.marketProduct:
            final productId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(productId: productId),
            );
          case Routes.marketCart:
            return MaterialPageRoute(builder: (context) => const CartScreen());
          case Routes.marketOrders:
            return MaterialPageRoute(builder: (context) => const OrdersScreen());
          case Routes.orderDetails:
            final orderId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => OrderDetailsScreen(orderId: orderId),
            );

          default:
            return null;
        }
      },
      home:
          context.isPhone
              ? authStatus.when(
                data: (user) => user != null ? const HomeScreen() : const WelcomeScreen(),
                loading:
                    () => const Scaffold(body: Center(child: CircularProgressIndicator())),
                error:
                    (error, stackTrace) => Scaffold(
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(ErrorHandler.getFriendlyErrorMessage(error as Exception)),
                            const SizedBox(height: 16),
                            FilledButton(
                              onPressed: () => ref.refresh(authStatusProvider),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
              )
              : UsePhoneWidget(),
    );
  }
}
