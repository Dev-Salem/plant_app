import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:plant_app/core/constants/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_app/core/errors/error_messages.dart';
import 'package:plant_app/features/auth/presentation/controllers/auth_controller.dart';

class SignInScreen extends ConsumerWidget {
  SignInScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authControllerProvider, (_, state) {
      state.whenOrNull(
        error:
            (error, _) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(HandleError.getFriendlyErrorMessage(error as Exception))),
            ),
        data: (_) {
          Navigator.pushNamed(context, Routes.verifyOtp, arguments: _emailController.text);
        },
      );
    });

    final isLoading = ref.watch(authControllerProvider).isLoading;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, context.mediaQueryViewInsets.bottom + 16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Welcome Back! 🌿',
              style: context.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
            ).animate().fadeIn().slideX(),
            8.heightBox,
            Text(
              'Enter your email to continue',
              style: context.titleMedium?.copyWith(),
            ).animate().fadeIn(delay: 200.ms).slideX(),
            32.heightBox,
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,

              validator: (value) {
                if (value == null || !value.isEmail || value.isEmpty) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),
            32.heightBox,
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed:
                    isLoading
                        ? null
                        : () {
                          if (_formKey.currentState?.validate() == true) {
                            ref
                                .read(authControllerProvider.notifier)
                                .signInWithEmail(_emailController.text);
                          }
                        },
                child: isLoading ? const CircularProgressIndicator() : const Text('Continue'),
              ),
            ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.3),
          ],
        ),
      ),
    );
  }
}
