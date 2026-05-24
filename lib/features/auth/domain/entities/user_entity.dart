// lib/features/auth/domain/entities/user_entity.dart
import 'package:equatable/equatable.dart';
import '../../../../core/constants/app_constants.dart';

// Pure domain object — no JSON, no Supabase, no Flutter imports.
// Only business logic lives here.

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final UserRole role;
  final String? fcmToken;
  final bool isActive;

  const UserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.fcmToken,
    this.isActive = true,
  });

  // ── Business logic helpers ───────────────────────────────
  bool get isAdmin    => role == UserRole.admin;
  bool get isEmployee => role == UserRole.employee;
  bool get isHod      => role == UserRole.hod;
  bool get isMd       => role == UserRole.md;
  bool get isAccounts => role == UserRole.accounts;

  // HOD and MD both have approval authority
  bool get canApprove => isHod || isMd;

  // HOD and MD can also file expenses
  bool get canFileExpense => isEmployee || isHod || isMd;

  @override
  List<Object?> get props => [
        id,
        email,
        fullName,
        role,
        fcmToken,
        isActive,
      ];

  @override
  String toString() =>
      'UserEntity(id: $id, email: $email, role: ${role.label})';
}