import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_app/core/constants/test_account.dart';
import 'package:plant_app/core/env/env.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository({required this.client});
  final Client client;

  Future<String> signInWithEmail(String email) async {
    final account = Account(client);
    _testLogin(email, account);
    final result = await account.createEmailToken(userId: ID.unique(), email: email);
    return result.userId;
  }

  Future<String?> _testLogin(String email, Account account) async {
    if (email == TestAccount.email) {
      final sessionToken = await account.createPhoneToken(
        userId: TestAccount.userId,
        phone: TestAccount.phone,
      );
      return sessionToken.userId;
    }
    return null;
  }

  Future<void> verifyOTP(String userId, String otp) async {
    final account = Account(client);
    if (userId == TestAccount.userId) {
      await account.createSession(userId: userId, secret: '417103');
      return;
    }
    await account.createSession(userId: userId, secret: otp);
  }

  Future<void> signOut() async {
    final account = Account(client);
    await account.deleteSessions();
  }

  Future<void> resendOtp(String email) async {
    await signInWithEmail(email);
  }

  Future<bool> isLoggedIn() async {
    try {
      await Account(client).get();
      return true;
    } on Exception {
      return false;
    }
  }

  Future<User?> getAccount() async {
    try {
      final account = await Account(client).get();
      return account;
    } on Exception {
      return null;
    }
  }

  Future<bool> isAdmin() async {
    final user = await getAccount();
    return user?.labels.first == 'admin';
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final client = ref.watch(appwriteClientProvider);

  return AuthRepository(client: client);
}

@Riverpod(keepAlive: true)
Client appwriteClient(Ref ref) {
  final client =
      Client()
        ..setEndpoint(Env.endPoint)
        ..setProject(Env.projectId);
  return client;
}

final authStatusProvider = FutureProvider<bool>((ref) async {
  return ref.watch(authRepositoryProvider).isLoggedIn();
});

final userProvider = FutureProvider<User?>((ref) async {
  return ref.watch(authRepositoryProvider).getAccount();
});

final isAdminProvider = FutureProvider<bool>((ref) async {
  return ref.watch(authRepositoryProvider).isAdmin();
});
