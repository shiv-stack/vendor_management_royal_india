// lib/features/admin/presentation/bloc/user_management_bloc.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../auth/domain/entities/user_entity.dart';

import '../../domain/repositories/admin_repository.dart';

// ── Events ────────────────────────────────────────────────────
abstract class UserManagementEvent extends Equatable {
  const UserManagementEvent();
  @override
  List<Object?> get props => [];
}

class UserManagementLoadAll extends UserManagementEvent {
  const UserManagementLoadAll();
}

class UserManagementUpdateRole extends UserManagementEvent {
  final String userId;
  final UserRole role;
  const UserManagementUpdateRole({
    required this.userId,
    required this.role,
  });
  @override
  List<Object?> get props => [userId, role];
}

class UserManagementToggleActive extends UserManagementEvent {
  final String userId;
  final bool isActive;
  const UserManagementToggleActive({
    required this.userId,
    required this.isActive,
  });
  @override
  List<Object?> get props => [userId, isActive];
}

class UserManagementCreateUser extends UserManagementEvent {
  final String email;
  final String password;
  final UserRole role;
  final String employeeId;
  const UserManagementCreateUser({
    required this.email,
    required this.password,
    required this.role,
    required this.employeeId,
  });
  @override
  List<Object?> get props => [email, password, role, employeeId];
}

/// Assign or update the employee_id for an existing user
/// (used by admin to on-board legacy users who have NULL employee_id).
class UserManagementUpdateEmployeeId extends UserManagementEvent {
  final String userId;
  final String employeeId;
  const UserManagementUpdateEmployeeId({
    required this.userId,
    required this.employeeId,
  });
  @override
  List<Object?> get props => [userId, employeeId];
}

// ── States ────────────────────────────────────────────────────
abstract class UserManagementState extends Equatable {
  const UserManagementState();
  @override
  List<Object?> get props => [];
}

class UserManagementInitial extends UserManagementState {
  const UserManagementInitial();
}

class UserManagementLoading extends UserManagementState {
  const UserManagementLoading();
}

class UserManagementLoaded extends UserManagementState {
  final List<UserEntity> users;
  const UserManagementLoaded({required this.users});
  @override
  List<Object?> get props => [users];
}

class UserManagementActionSuccess extends UserManagementState {
  final String message;
  final List<UserEntity> users;
  const UserManagementActionSuccess({
    required this.message,
    required this.users,
  });
  @override
  List<Object?> get props => [message, users];
}

class UserManagementFailure extends UserManagementState {
  final String message;
  const UserManagementFailure({required this.message});
  @override
  List<Object?> get props => [message];
}

// ── BLoC ──────────────────────────────────────────────────────
class UserManagementBloc
    extends Bloc<UserManagementEvent, UserManagementState> {
  final AdminRepository repository;

  UserManagementBloc({required this.repository})
      : super(const UserManagementInitial()) {
    on<UserManagementLoadAll>(_onLoadAll);
    on<UserManagementUpdateRole>(_onUpdateRole);
    on<UserManagementToggleActive>(_onToggleActive);
    on<UserManagementCreateUser>(_onCreateUser);
    on<UserManagementUpdateEmployeeId>(_onUpdateEmployeeId);
  }

  Future<void> _onLoadAll(
    UserManagementLoadAll event,
    Emitter<UserManagementState> emit,
  ) async {
    emit(const UserManagementLoading());
    final result = await repository.getUsers();
    result.fold(
      (f) => emit(UserManagementFailure(message: f.message)),
      (users) => emit(UserManagementLoaded(users: users)),
    );
  }

  Future<void> _onUpdateRole(
    UserManagementUpdateRole event,
    Emitter<UserManagementState> emit,
  ) async {
    emit(const UserManagementLoading());
    final result = await repository.updateUserRole(
      userId: event.userId,
      role: event.role,
    );
    await result.fold(
      (f) async => emit(UserManagementFailure(message: f.message)),
      (_) async {
        final listResult = await repository.getUsers();
        listResult.fold(
          (f) => emit(UserManagementFailure(message: f.message)),
          (users) => emit(UserManagementActionSuccess(
              message: 'User role updated successfully.', users: users)),
        );
      },
    );
  }

  Future<void> _onToggleActive(
    UserManagementToggleActive event,
    Emitter<UserManagementState> emit,
  ) async {
    emit(const UserManagementLoading());
    final result = await repository.toggleUserActive(
      userId: event.userId,
      isActive: event.isActive,
    );
    await result.fold(
      (f) async => emit(UserManagementFailure(message: f.message)),
      (_) async {
        final listResult = await repository.getUsers();
        listResult.fold(
          (f) => emit(UserManagementFailure(message: f.message)),
          (users) => emit(UserManagementActionSuccess(
              message: event.isActive
                  ? 'User activated successfully.'
                  : 'User deactivated successfully.',
              users: users)),
        );
      },
    );
  }

  Future<void> _onCreateUser(
    UserManagementCreateUser event,
    Emitter<UserManagementState> emit,
  ) async {
    emit(const UserManagementLoading());
    final result = await repository.createUser(
      email: event.email,
      password: event.password,
      role: event.role,
      employeeId: event.employeeId,
    );
    await result.fold(
      (f) async => emit(UserManagementFailure(message: f.message)),
      (_) async {
        final listResult = await repository.getUsers();
        listResult.fold(
          (f) => emit(UserManagementFailure(message: f.message)),
          (users) => emit(UserManagementActionSuccess(
              message: 'User created successfully.', users: users)),
        );
      },
    );
  }

  Future<void> _onUpdateEmployeeId(
    UserManagementUpdateEmployeeId event,
    Emitter<UserManagementState> emit,
  ) async {
    emit(const UserManagementLoading());
    final result = await repository.updateEmployeeId(
      userId: event.userId,
      employeeId: event.employeeId,
    );
    await result.fold(
      (f) async => emit(UserManagementFailure(message: f.message)),
      (_) async {
        final listResult = await repository.getUsers();
        listResult.fold(
          (f) => emit(UserManagementFailure(message: f.message)),
          (users) => emit(UserManagementActionSuccess(
              message: 'Employee ID assigned successfully.', users: users)),
        );
      },
    );
  }
}
