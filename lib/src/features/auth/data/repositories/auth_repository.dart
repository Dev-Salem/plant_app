import 'package:flutter/foundation.dart';

class AuthRepository {
  Future<void> signOut() async {
    // Implement your sign out logic here
    // For example: clear tokens, user data, etc.
    if (kDebugMode) {
      print('User signed out');
    }
  }
}
