// lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vpms_royal_india/features/expense/presentation/pages/employee/employee_home_page.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../constants/app_constants.dart';
import '../services/session_service.dart';
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

  // All protected top-level home routes — used by the guard to detect
  // when a user has landed on the wrong role's home via browser URL restore.
  static const List<String> _roleRoots = [
    adminHome,
    employeeHome,
    hodHome,
    mdHome,
    accountsHome,
  ];

  /// Returns the expected home route for a given role.
  static String homeForRole(UserRole role) {
    switch (role) {
      case UserRole.admin:    return adminHome;
      case UserRole.employee: return employeeHome;
      case UserRole.hod:      return hodHome;
      case UserRole.md:       return mdHome;
      case UserRole.accounts: return accountsHome;
    }
  }

  /// True if [location] starts with one of the top-level role-home paths.
  static bool isRoleRoot(String location) =>
      _roleRoots.any((r) => location == r || location.startsWith('$r/'));
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

      // ── Role home routes ──────────────────────────────────
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
        builder: (context, state) => const EmployeeHomePage(),
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

  // ── Route Guard ────────────────────────────────────────────────────────────
  //
  // Decision tree (runs before every navigation):
  //
  //  1. No Supabase session  → /login  (unauthenticated access blocked)
  //  2. Session exists + going to /login
  //       → null (let through; LoginPage fires AuthCheckSessionEvent which
  //         reads role from DB and routes to correct home via BlocListener)
  //  3. Session exists + going to a role-root (e.g. /employee)
  //       → validate against SessionService.cachedRole (DB-sourced, never JWT)
  //         • correct role      → null (let through)
  //         • wrong role        → redirect to their actual home
  //         • no cached role yet → /login (forces fresh DB-backed session check)
  //  4. Everything else (sub-routes, non-role-root protected routes) → null
  //
  // NOTE: We intentionally do NOT read role from session.user.userMetadata
  // because that field is populated from the JWT which can be stale or absent.
  // All role decisions come from the profiles table via SessionService.
  // ──────────────────────────────────────────────────────────────────────────
  static Future<String?> _guard(
    BuildContext context,
    GoRouterState state,
  ) async {
    final session = Supabase.instance.client.auth.currentSession;
    final isLoggedIn = session != null;
    final location = state.matchedLocation;
    final isGoingToLogin = location == AppRoutes.login;

    // ── 1. Unauthenticated → force to login ─────────────────
    if (!isLoggedIn) {
      return isGoingToLogin ? null : AppRoutes.login;
    }

    // ── 2. Authenticated + going to /login ──────────────────
    // Let LoginPage show — its AuthBloc reads role from DB and routes correctly.
    if (isGoingToLogin) {
      return null;
    }

    // ── 3. Authenticated + navigating to a role-root page ───
    // Validate the destination matches the user's actual role.
    if (AppRoutes.isRoleRoot(location)) {
      final cachedRole = SessionService.instance.cachedRole;

      // No cached role means the BLoC hasn't run its session check yet
      // (e.g. cold start with browser restoring a deep URL on web, or
      // first launch on mobile before LoginPage has loaded). Send to /login
      // so LoginPage can perform the DB-backed session check first.
      if (cachedRole == null) {
        return AppRoutes.login;
      }

      final expectedHome = AppRoutes.homeForRole(cachedRole);

      // If the user landed on the wrong role's home (e.g. an admin whose
      // browser restored /employee from history), redirect to correct home.
      if (!location.startsWith(expectedHome)) {
        return expectedHome;
      }
    }

    // ── 4. All good ─────────────────────────────────────────
    return null;
  }
}

// ── Temporary placeholder page until real pages are built ─────
// ignore: unused_element
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
                await SessionService.instance.clearSession();
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
