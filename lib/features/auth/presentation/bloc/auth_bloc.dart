// lib/features/auth/presentation/bloc/auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/services/session_service.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase signIn;
  final SignOutUseCase signOut;
  final GetCurrentUserUseCase getCurrentUser;

  AuthBloc({
    required this.signIn,
    required this.signOut,
    required this.getCurrentUser,
  }) : super(const AuthInitial()) {
    on<AuthCheckSessionEvent>(_onCheckSession);
    on<AuthSignInEvent>(_onSignIn);
    on<AuthSignOutEvent>(_onSignOut);
  }

  // ── Check existing session on app launch ──────────────────
  Future<void> _onCheckSession(
    AuthCheckSessionEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await getCurrentUser();

    await result.fold(
      (failure) async {
        // No valid session — clear any stale cached role
        await SessionService.instance.clearSession();
        emit(const AuthUnauthenticated());
      },
      (user) async {
        // Valid session found — persist the DB-sourced role for the guard
        await SessionService.instance.saveRole(user.role);
        emit(AuthAuthenticated(user: user));
      },
    );
  }

  // ── Sign In ───────────────────────────────────────────────
  Future<void> _onSignIn(
    AuthSignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await signIn(
      SignInParams(
        employeeId: event.employeeId,
        password: event.password,
      ),
    );

    await result.fold(
      (failure) async => emit(AuthFailureState(message: failure.message)),
      (user) async {
        // Persist the DB-sourced role so the guard can validate routes
        await SessionService.instance.saveRole(user.role);
        emit(AuthAuthenticated(user: user));
      },
    );
  }

  // ── Sign Out ──────────────────────────────────────────────
  Future<void> _onSignOut(
    AuthSignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    // Wipe cached role BEFORE calling signOut so the guard can't
    // accidentally route an unauthenticated user to a protected page.
    await SessionService.instance.clearSession();

    final result = await signOut();

    result.fold(
      (failure) => emit(AuthFailureState(message: failure.message)),
      (_)       => emit(const AuthUnauthenticated()),
    );
  }
}