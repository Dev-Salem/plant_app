import 'package:plant_app/core/constants/assets.dart';

class OnboardingContent {
  final String image;
  final String title;
  final String description;
  OnboardingContent({required this.image, required this.title, required this.description});
}

final onboardingContent = [
  OnboardingContent(
    image: Assets.camera,
    title: 'Take a photo. Get an instant diagnosis!',
    description:
        'Simply capture an image of your plant’s leaf, and we’ll detect the disease and suggest a solution in seconds.',
  ),
  OnboardingContent(
    image: Assets.computer,
    title: 'Order the right products with one tap',
    description:
        'Buying pesticides and fertilizers is now easier! Order directly from verified suppliers',
  ),
];
