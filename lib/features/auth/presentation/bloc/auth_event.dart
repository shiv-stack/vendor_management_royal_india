// lib/features/auth/presentation/bloc/auth_event.dart
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// Fired on app startup — checks if session already exists
class AuthCheckSessionEvent extends AuthEvent {
  const AuthCheckSessionEvent();
}

// Fired when user taps Sign In button
class AuthSignInEvent extends AuthEvent {
  final String employeeId;
  final String password;

  const AuthSignInEvent({
    required this.employeeId,
    required this.password,
  });

  @override
  List<Object> get props => [employeeId, password];
}

// Fired when user taps Sign Out
class AuthSignOutEvent extends AuthEvent {
  const AuthSignOutEvent();
}