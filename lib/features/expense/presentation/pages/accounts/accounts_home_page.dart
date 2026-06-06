// lib/features/expense/presentation/pages/accounts/accounts_home_page.dart
import 'package:flutter/material.dart';
import '../../../../../features/dashboard/presentation/pages/dashboard_page.dart';
import 'accounts_payment_page.dart';

class AccountsHomePage extends StatefulWidget {
  const AccountsHomePage({super.key});

  @override
  State<AccountsHomePage> createState() =>
      _AccountsHomePageState();
}

class _AccountsHomePageState extends State<AccountsHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    AccountsPaymentPage(),
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
            icon: Icon(Icons.payments_rounded),
            label: 'Payments',
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