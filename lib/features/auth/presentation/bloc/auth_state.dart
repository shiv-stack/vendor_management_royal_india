// lib/features/auth/presentation/bloc/auth_state.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// App just launched — session check not done yet
class AuthInitial extends AuthState {
  const AuthInitial();
}

// Any async operation in progress
class AuthLoading extends AuthState {
  const AuthLoading();
}

// Session exists / sign in successful
class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object> get props => [user];
}

// No session / signed out
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

// Sign in or session check failed
class AuthFailureState extends AuthState {
  final String message;

  const AuthFailureState({required this.message});

  @override
  List<Object> get props => [message];
}