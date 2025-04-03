import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_app/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:plant_app/src/core/theme/theme_notifier.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final authController = ref.watch(authControllerProvider.notifier);
    final isLoading = ref.watch(authControllerProvider).isLoading;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.logout),
            title: isLoading ? Text("Signing out..") : const Text('Sign Out'),
            onTap:
                isLoading
                    ? null
                    : () async {
                      await authController.signOut();
                    },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Change Theme'),
            onTap: ref.read(themeProvider.notifier).toggleTheme,
          ),
          const Divider(),
        ],
      ),
    );
  }
}
