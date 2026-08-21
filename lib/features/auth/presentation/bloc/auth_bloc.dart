// lib/features/auth/presentation/bloc/auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
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

    result.fold(
      (failure) => emit(const AuthUnauthenticated()),
      (user)    => emit(AuthAuthenticated(user: user)),
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

    result.fold(
      (failure) => emit(AuthFailureState(message: failure.message)),
      (user)    => emit(AuthAuthenticated(user: user)),
    );
  }

  // ── Sign Out ──────────────────────────────────────────────
  Future<void> _onSignOut(
    AuthSignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await signOut();

    result.fold(
      (failure) => emit(AuthFailureState(message: failure.message)),
      (_)       => emit(const AuthUnauthenticated()),
    );
  }
}