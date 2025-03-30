import 'package:flutter/widgets.dart';
import 'package:plant_app/features/auth/data/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  String _userId = 'initial value';
  @override
  FutureOr<void> build() async {}

  Future<void> signInWithEmail(String email, VoidCallback? onSuccess) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final result = await ref.read(authRepositoryProvider).signInWithEmail(email);
      _userId = result;
    });
    if (!state.hasError && onSuccess != null) {
      onSuccess();
    }
  }

  Future<void> verifyOtp(String otp, VoidCallback? onSuccess) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).verifyOTP(_userId, otp);
    });
    if (!state.hasError && onSuccess != null) {
      onSuccess();
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signOut();
    });
  }

  Future<void> resendOtp(String email, VoidCallback? onSuccess) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final result = await ref.read(authRepositoryProvider).signInWithEmail(email);
      _userId = result;
    });
    if (!state.hasError && onSuccess != null) {
      onSuccess();
    }
  }
}
