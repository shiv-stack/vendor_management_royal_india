// lib/features/expense/presentation/pages/employee/employee_home_page.dart
//
// Shell widget for the employee role — mirrors AccountsHomePage exactly.
// Provides a NavigationBar with two tabs:
//   0 → Home (My Expense Requests list)
//   1 → Profile (logged-in user details + sign-out)

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart';
import '../../bloc/expense_bloc.dart';
import 'employee_profile_page.dart';
import 'my_requests_page.dart';
import 'submit_expense_page.dart';

class EmployeeHomePage extends StatefulWidget {
  const EmployeeHomePage({super.key});

  @override
  State<EmployeeHomePage> createState() => _EmployeeHomePageState();
}

class _EmployeeHomePageState extends State<EmployeeHomePage> {
  int _currentIndex = 0;

  static const _titles = ['My Expense Requests', 'Profile'];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Provide ExpenseBloc at shell level so the body widget below can use it.
      create: (_) => sl<ExpenseBloc>()..add(const ExpenseLoadMyRequests()),
      child: _EmployeeShell(
        currentIndex: _currentIndex,
        onIndexChanged: (i) => setState(() => _currentIndex = i),
        titles: _titles,
      ),
    );
  }
}

class _EmployeeShell extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final List<String> titles;

  const _EmployeeShell({
    required this.currentIndex,
    required this.onIndexChanged,
    required this.titles,
  });

  Future<void> _openNewExpense(BuildContext context) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const SubmitExpensePage()),
    );
    if (result == true && context.mounted) {
      context.read<ExpenseBloc>().add(const ExpenseLoadMyRequests());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[currentIndex]),
      ),
      body: IndexedStack(
        index: currentIndex,
        children: const [
          // Tab 0 — expense list body (BlocProvider is at shell level)
          MyRequestsBody(),
          // Tab 1 — profile
          EmployeeProfilePage(),
        ],
      ),
      floatingActionButton: currentIndex == 0
          ? FloatingActionButton.extended(
              heroTag: 'employee_new_expense_fab',
              onPressed: () => _openNewExpense(context),
              icon: const Icon(Icons.add),
              label: const Text('New Expense'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onIndexChanged,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
