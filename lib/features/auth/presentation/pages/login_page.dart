// lib/features/auth/presentation/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vpms_royal_india/features/auth/domain/entities/user_entity.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../../injection_container.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>()
        ..add(const AuthCheckSessionEvent()),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  // Navigate to correct home based on role
  void _handleAuthenticated(BuildContext context, UserEntity user) {
    switch (user.role) {
      case UserRole.admin:
        context.go(AppRoutes.adminHome);
        break;
      case UserRole.employee:
        context.go(AppRoutes.employeeHome);
        break;
      case UserRole.hod:
        context.go(AppRoutes.hodHome);
        break;
      case UserRole.md:
        context.go(AppRoutes.mdHome);
        break;
      case UserRole.accounts:
        context.go(AppRoutes.accountsHome);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          _handleAuthenticated(context, state.user);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              // Show full screen loader during session check on startup
              if (state is AuthLoading || state is AuthInitial) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width > 600
                      ? size.width * 0.25  // tablet/web: narrower form
                      : 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: size.height * 0.10),

                    // ── Logo / Branding ──────────────────
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.receipt_long_rounded,
                          color: Colors.white,
                          size: 44,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Title ────────────────────────────
                    Text(
                      'Royal India Vacation',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Vendor Payment Management',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.6)
                          ),
                    ),

                    SizedBox(height: size.height * 0.06),

                    // ── Form ─────────────────────────────
                    const LoginForm(),

                    const SizedBox(height: 40),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}