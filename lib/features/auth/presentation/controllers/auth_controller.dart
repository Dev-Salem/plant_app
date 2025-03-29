import 'package:plant_app/features/auth/data/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  String _userId = 'initial value';
  @override
  FutureOr<void> build() async {}

  Future<void> signInWithEmail(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final result = await ref.read(authRepositoryProvider).signInWithEmail(email);
      _userId = result;
    });
  }

  Future<void> verifyOtp(String otp) async {
    state = const AsyncLoading();
    print(otp);
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).verifyOTP(_userId, otp);
    });
  }

  Future<void> resendOtp(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final result = await ref.read(authRepositoryProvider).signInWithEmail(email);
      _userId = result;
    });
  }
}
