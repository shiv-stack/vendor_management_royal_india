// lib/features/expense/presentation/pages/hod/hod_home_page.dart
import 'package:flutter/material.dart';
import '../../../../../features/dashboard/presentation/pages/dashboard_page.dart';
import 'hod_review_page.dart';

class HodHomePage extends StatefulWidget {
  const HodHomePage({super.key});

  @override
  State<HodHomePage> createState() => _HodHomePageState();
}

class _HodHomePageState extends State<HodHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HodReviewPage(),
    DashboardPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) =>
            setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.pending_actions_rounded),
            label: 'Approvals',
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
        ],
      ),
    );
  }
}