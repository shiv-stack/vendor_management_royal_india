// lib/features/admin/domain/repositories/admin_repository.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/failures.dart';
import '../entities/event_entity.dart';
import '../entities/expense_type_entity.dart';
import '../entities/vendor_entity.dart';
import '../../../auth/domain/entities/user_entity.dart';

abstract class AdminRepository {
  // ── Events ───────────────────────────────────────────────
  Future<Either<Failure, List<EventEntity>>> getEvents();
  Future<Either<Failure, EventEntity>> createEvent({
    required String name,
    String? description,
  });
  Future<Either<Failure, EventEntity>> updateEvent({
    required String id,
    required String name,
    String? description,
    required bool isActive,
  });
  Future<Either<Failure, Unit>> deleteEvent(String id);

  // ── Expense Types ────────────────────────────────────────
  Future<Either<Failure, List<ExpenseTypeEntity>>> getExpenseTypes();
  Future<Either<Failure, ExpenseTypeEntity>> createExpenseType({
    required String name,
    String? description,
  });
  Future<Either<Failure, ExpenseTypeEntity>> updateExpenseType({
    required String id,
    required String name,
    String? description,
    required bool isActive,
  });
  Future<Either<Failure, Unit>> deleteExpenseType(String id);

  // ── Vendors ──────────────────────────────────────────────
  Future<Either<Failure, List<VendorEntity>>> getVendors();
  Future<Either<Failure, VendorEntity>> createVendor(
      {required String name,
      required String pan,
      String? bankName,
      String? accountNumber,
      String? ifsc,
      String? contactName,
      String? contactPhone,
      String? gstNumber});
  Future<Either<Failure, VendorEntity>> updateVendor({
    required String id,
    required String name,
    required String pan,
    String? bankName,
    String? accountNumber,
    String? ifsc,
    String? contactName,
    String? contactPhone,
    String? gstNumber,
    required bool isActive,
  });
  Future<Either<Failure, Unit>> deleteVendor(String id);

  // ── User Management ──────────────────────────────────────────
  Future<Either<Failure, List<UserEntity>>> getUsers();
  Future<Either<Failure, UserEntity>> createUser({
    required String email,
    required String password,
    required UserRole role,
  });
  Future<Either<Failure, UserEntity>> updateUserRole({
    required String userId,
    required UserRole role,
  });
  Future<Either<Failure, UserEntity>> toggleUserActive({
    required String userId,
    required bool isActive,
  });
}
