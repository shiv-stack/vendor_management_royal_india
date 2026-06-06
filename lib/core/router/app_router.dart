// lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vpms_royal_india/features/expense/presentation/pages/accounts/accounts_payment_page.dart';
import 'package:vpms_royal_india/features/expense/presentation/pages/employee/my_requests_page.dart';
import 'package:vpms_royal_india/features/expense/presentation/pages/hod/hod_review_page.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../constants/app_constants.dart';
import '../../features/admin/presentation/pages/admin_home_page.dart';
import '../../features/admin/presentation/pages/events_page.dart';
import '../../features/admin/presentation/pages/expense_types_page.dart';
import '../../features/admin/presentation/pages/vendors_page.dart';
import '../../features/admin/presentation/pages/users_page.dart';
import '../../features/expense/presentation/pages/hod/hod_home_page.dart';
import '../../features/expense/presentation/pages/accounts/accounts_home_page.dart';

// Route name constants — use these everywhere, never raw strings
class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String adminHome = '/admin';
  static const String employeeHome = '/employee';
  static const String hodHome = '/hod';
  static const String mdHome = '/md';
  static const String accountsHome = '/accounts';

  // Sub-routes (Phase 2+)
  static const String adminEvents = '/admin/events';
  static const String adminVendors = '/admin/vendors';
  static const String adminExpenseTypes = '/admin/expense-types';
  static const String adminUsers = '/admin/users';

  static const String employeeSubmit = '/employee/submit';
  static const String employeeRequests = '/employee/requests';

  static const String hodReview = '/hod/review';
  static const String hodDashboard = '/hod/dashboard';

  static const String mdReview = '/md/review';

  static const String accountsQueue = '/accounts/queue';
  static const String accountsDashboard = '/accounts/dashboard';
}

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: true, // remove in production
    redirect: _guard,
    routes: [
      // ── Auth ──────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),

      // ── Placeholder home routes (Phase 2+ will replace) ───
      GoRoute(
        path: AppRoutes.adminHome,
        name: 'admin-home',
        builder: (context, state) => const AdminHomePage(),
        routes: [
          GoRoute(
            path: 'events',
            name: 'admin-events',
            builder: (context, state) => const EventsPage(),
          ),
          GoRoute(
            path: 'expense-types',
            name: 'admin-expense-types',
            builder: (context, state) => const ExpenseTypesPage(),
          ),
          GoRoute(
            path: 'vendors',
            name: 'admin-vendors',
            builder: (context, state) => const VendorsPage(),
          ),
          GoRoute(
            path: 'users',
            name: 'admin-users',
            builder: (context, state) => const UsersPage(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.employeeHome,
        name: 'employee-home',
        builder: (context, state) => const MyRequestsPage(),
      ),
      GoRoute(
        path: AppRoutes.hodHome,
        name: 'hod-home',
        builder: (context, state) => const HodHomePage(),
      ),
      GoRoute(
        path: AppRoutes.mdHome,
        name: 'md-home',
        builder: (context, state) => const HodHomePage(),
      ),
      GoRoute(
        path: AppRoutes.accountsHome,
        name: 'accounts-home',
        builder: (context, state) => const AccountsHomePage(),
      ),
    ],
  );

  // ── Route Guard ────────────────────────────────────────────
  // Runs before every navigation. Checks auth state and redirects.
  static Future<String?> _guard(
    BuildContext context,
    GoRouterState state,
  ) async {
    final session = Supabase.instance.client.auth.currentSession;
    final isLoggedIn = session != null;
    final isGoingToLogin = state.matchedLocation == AppRoutes.login;

    // Not logged in → force to login
    if (!isLoggedIn && !isGoingToLogin) {
      return AppRoutes.login;
    }

    // Logged in and trying to hit /login → redirect to role home
    if (isLoggedIn && isGoingToLogin) {
      return _homeForRole(session);
    }

    // All good
    return null;
  }

  // Returns the correct home route based on user's role stored in JWT metadata
  static String _homeForRole(Session session) {
    final roleStr = session.user.userMetadata?['role'] as String? ?? 'employee';
    final role = UserRole.fromString(roleStr);

    switch (role) {
      case UserRole.admin:
        return AppRoutes.adminHome;
      case UserRole.employee:
        return AppRoutes.employeeHome;
      case UserRole.hod:
        return AppRoutes.hodHome;
      case UserRole.md:
        return AppRoutes.mdHome;
      case UserRole.accounts:
        return AppRoutes.accountsHome;
    }
  }
}

// ── Temporary placeholder page until real pages are built ─────
class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Text('Phase 2+ will build this screen',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                await Supabase.instance.client.auth.signOut();
                if (context.mounted) context.go(AppRoutes.login);
              },
              child: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}
