import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_app/src/core/constants/routes.dart';
import 'package:plant_app/src/core/errors/error_messages.dart';
import 'package:plant_app/src/features/auth/data/auth_repository.dart';
import 'package:plant_app/src/features/auth/presentation/controllers/auth_controller.dart';
import 'dart:async';

class VerifyOtpScreen extends ConsumerStatefulWidget {
  const VerifyOtpScreen({super.key, required this.email});

  final String email;

  @override
  ConsumerState<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends ConsumerState<VerifyOtpScreen> {
  final _pinController = TextEditingController();
  final _pinFocusNode = FocusNode();
  Timer? _resendTimer;
  int _remainingSeconds = 30;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  void _startResendTimer() {
    _remainingSeconds = 30;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _handleResend() {
    _pinController.clear();
    _pinFocusNode.requestFocus();

    // Resend OTP with callback for success
    ref.read(authControllerProvider.notifier).resendOtp(widget.email, () {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('OTP resent successfully')));
    });
    _startResendTimer();
  }

  void _verifyOtp(String pin) {
    if (pin.length == 6) {
      // Verify OTP with callback to navigate to home screen on success
      ref.read(authControllerProvider.notifier).verifyOtp(pin, () {
        // First refresh the user provider to ensure it reflects updated auth state
        ref.invalidate(userProvider);
        // Then navigate to home screen
        Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authControllerProvider, (_, state) {
      state.whenOrNull(
        error:
            (error, _) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(ErrorHandler.getFriendlyErrorMessage(error as Exception))),
            ),
      );
    });

    final isLoading = ref.watch(authControllerProvider).isLoading;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: context.scaffoldBackgroundColor,
        border: Border.all(color: context.primaryColor),
      ),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Verification Code',
              style: context.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ).animate().fadeIn().slideX(),

            Text(
              'We sent a verification code to ${widget.email}',
              style: context.bodyMedium?.copyWith(),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 200.ms).slideX(),
            48.heightBox,
            Pinput(
              length: 6,
              controller: _pinController,
              focusNode: _pinFocusNode,
              defaultPinTheme: defaultPinTheme,
              separatorBuilder: (index) => const SizedBox(width: 8),
              onCompleted: _verifyOtp,
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),
            24.heightBox,
            Center(
              child: TextButton(
                onPressed: (isLoading || _remainingSeconds > 0) ? null : _handleResend,
                child:
                    isLoading
                        ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : Text(
                          _remainingSeconds > 0
                              ? 'Resend in ${_remainingSeconds}s'
                              : 'Resend Code',
                        ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: isLoading ? null : () => _verifyOtp(_pinController.text),
                child:
                    isLoading
                        ? SizedBox(
                          height: 24,
                          width: 24,
                          child: const CircularProgressIndicator(),
                        )
                        : const Text('Verify'),
              ),
            ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.3),
            12.heightBox,
          ],
        ),
      ),
    );
  }
}
