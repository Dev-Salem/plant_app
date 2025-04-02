import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_app/features/admin/presentation/screens/dashboard_screen.dart';
import 'package:plant_app/features/market/presentation/screens/market_screen.dart';
import 'package:plant_app/features/auth/data/auth_repository.dart';
import 'settings_screen.dart';
import 'tabs/home_tab.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isAdminAsync = ref.watch(isAdminProvider);

    return isAdminAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) => _buildScaffold(false),
      data: (isAdmin) => _buildScaffold(isAdmin),
    );
  }

  Widget _buildScaffold(bool isAdmin) {
    final screens = [
      const HomeTab(),
      const MarketScreen(),
      if (isAdmin) DashboardScreen(),
      SettingsScreen(),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex >= screens.length ? 0 : _selectedIndex,
          children: screens,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex >= screens.length ? 0 : _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Market'),
          if (isAdmin)
            const BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          const BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
