import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:plant_app/features/onboarding/domain/onboarding_content.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  void _showEmailBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0,
              bottom: MediaQuery.viewInsetsOf(context).bottom + 16.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Enter your email to continue 🌿',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                16.heightBox,
                TextFormField(
                  decoration: InputDecoration(hintText: 'Email', border: OutlineInputBorder()),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value?.isEmail != null && value!.isEmail) {
                      return null;
                    } else {
                      return 'Please enter a valid email';
                    }
                  },
                ),
                16.heightBox,
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      // // Handle email submission
                      // Navigator.pop(context);
                    },
                    child: Text('Continue'),
                  ),
                ),
                16.heightBox,
              ],
            ),
          ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == onboardingContent.length - 1;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,

          itemCount: onboardingContent.length,
          itemBuilder:
              (context, index) => Column(
                children: [
                  const Spacer(flex: 2),
                  Image.asset(
                    onboardingContent[index].image,
                    height: 300,
                    fit: BoxFit.contain,
                  ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
                  const Spacer(flex: 1),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Text(
                          onboardingContent[index].title,
                          style: context.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
                        24.heightBox,
                        Text(
                          onboardingContent[index].description,
                          style: context.bodyLarge?.copyWith(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
                      ],
                    ),
                  ),
                  const Spacer(flex: 2),
                  SizedBox(
                    child: FilledButton.icon(
                          onPressed: () {
                            if (!isLastPage) {
                              _pageController.nextPage(
                                duration: 300.ms,
                                curve: Curves.easeInOut,
                              );
                            } else {
                              _showEmailBottomSheet();
                            }
                          },
                          icon: const Icon(Icons.arrow_forward),
                          label: Text(isLastPage ? 'Get Started' : 'Sign In'),
                        )
                        .animate(autoPlay: true, onPlay: (controller) => controller.repeat())
                        .shimmer(duration: 2000.ms, delay: 1000.ms),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
