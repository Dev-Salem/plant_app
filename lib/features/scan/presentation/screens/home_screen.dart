import 'package:flutter/material.dart';
import 'package:plant_app/features/admin/presentation/screens/dashboard_screen.dart';
import 'package:plant_app/features/market/presentation/screens/market_screen.dart';
import 'settings_screen.dart';
import 'tabs/home_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  final List<Widget> _screens = [
    const HomeTab(),
    const MarketScreen(),
    DashboardScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: IndexedStack(index: _selectedIndex, children: _screens)),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Market'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),

          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
