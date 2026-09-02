// lib/features/expense/presentation/pages/employee/employee_profile_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/router/app_router.dart';
import '../../../../../core/services/session_service.dart';
import '../../../../../features/auth/domain/entities/user_entity.dart';
import '../../../../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../../../../injection_container.dart';

class EmployeeProfilePage extends StatefulWidget {
  const EmployeeProfilePage({super.key});

  @override
  State<EmployeeProfilePage> createState() => _EmployeeProfilePageState();
}

class _EmployeeProfilePageState extends State<EmployeeProfilePage> {
  late final Future<UserEntity?> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _fetchUser();
  }

  Future<UserEntity?> _fetchUser() async {
    final result = await sl<GetCurrentUserUseCase>()();
    return result.fold((_) => null, (user) => user);
  }

  Future<void> _signOut() async {
    await Supabase.instance.client.auth.signOut();
    await SessionService.instance.clearSession();
    if (mounted) context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: FutureBuilder<UserEntity?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = snapshot.data;

          return CustomScrollView(
            slivers: [
              // ── Collapsible header ──────────────────────────────
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                automaticallyImplyLeading: false,
                backgroundColor: colorScheme.primary,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorScheme.primary,
                          colorScheme.primary.withValues(alpha: 0.75),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 12),
                          // Avatar circle with initials
                          CircleAvatar(
                            radius: 44,
                            backgroundColor:
                                colorScheme.onPrimary.withValues(alpha: 0.25),
                            child: Text(
                              _initials(user?.fullName),
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            user?.fullName ?? '—',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 3),
                            decoration: BoxDecoration(
                              color:
                                  colorScheme.onPrimary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              user?.role.label ?? '',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── Profile info cards ──────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const _SectionLabel('Account Details'),
                    const SizedBox(height: 8),
                    _InfoCard(
                      children: [
                        _InfoTile(
                          icon: Icons.badge_outlined,
                          label: 'Employee Code',
                          value: user?.employeeId ?? '—',
                        ),
                        const Divider(height: 1),
                        _InfoTile(
                          icon: Icons.person_outline_rounded,
                          label: 'Full Name',
                          value: user?.fullName ?? '—',
                        ),
                        const Divider(height: 1),
                        _InfoTile(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: user?.email ?? '—',
                        ),
                        const Divider(height: 1),
                        _InfoTile(
                          icon: Icons.work_outline_rounded,
                          label: 'Role',
                          value: user?.role.label ?? '—',
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // ── Sign-out button ───────────────────────────
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _signOut,
                        icon: const Icon(Icons.logout_rounded),
                        label: const Text('Sign Out'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colorScheme.error,
                          side: BorderSide(color: colorScheme.error),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _initials(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }
}

// ── Small helper widgets ────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            letterSpacing: 0.5,
          ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(children: children),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoTile(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon,
              size: 20,
              color: theme.colorScheme.primary.withValues(alpha: 0.8)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
