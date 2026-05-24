// lib/features/admin/data/repositories/admin_repository_impl.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/entities/expense_type_entity.dart';
import '../../domain/entities/vendor_entity.dart';
import '../../domain/repositories/admin_repository.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../datasources/admin_remote_datasource.dart';
import '../models/event_model.dart';
import '../models/expense_type_model.dart';
import '../models/vendor_model.dart';
import '../../../auth/data/models/user_model.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remoteDataSource;

  const AdminRepositoryImpl({required this.remoteDataSource});

  // ── Events ───────────────────────────────────────────────

  @override
  Future<Either<Failure, List<EventEntity>>> getEvents() async {
    try {
      final models = await remoteDataSource.getEvents();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, EventEntity>> createEvent({
    required String name,
    String? description,
  }) async {
    try {
      final model = await remoteDataSource.createEvent(
        name: name,
        description: description,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, EventEntity>> updateEvent({
    required String id,
    required String name,
    String? description,
    required bool isActive,
  }) async {
    try {
      final model = await remoteDataSource.updateEvent(
        id: id,
        name: name,
        description: description,
        isActive: isActive,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteEvent(String id) async {
    try {
      await remoteDataSource.deleteEvent(id);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ── Expense Types ────────────────────────────────────────

  @override
  Future<Either<Failure, List<ExpenseTypeEntity>>> getExpenseTypes() async {
    try {
      final models = await remoteDataSource.getExpenseTypes();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ExpenseTypeEntity>> createExpenseType({
    required String name,
    String? description,
  }) async {
    try {
      final model = await remoteDataSource.createExpenseType(
        name: name,
        description: description,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ExpenseTypeEntity>> updateExpenseType({
    required String id,
    required String name,
    String? description,
    required bool isActive,
  }) async {
    try {
      final model = await remoteDataSource.updateExpenseType(
        id: id,
        name: name,
        description: description,
        isActive: isActive,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteExpenseType(String id) async {
    try {
      await remoteDataSource.deleteExpenseType(id);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ── Vendors ──────────────────────────────────────────────

  @override
  Future<Either<Failure, List<VendorEntity>>> getVendors() async {
    try {
      final models = await remoteDataSource.getVendors();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, VendorEntity>> createVendor({
    required String name,
    required String pan,
    String? bankName,
    String? accountNumber,
    String? ifsc,
    String? contactName,
    String? contactPhone,
  }) async {
    try {
      final model = await remoteDataSource.createVendor(
        name: name,
        pan: pan,
        bankName: bankName,
        accountNumber: accountNumber,
        ifsc: ifsc,
        contactName: contactName,
        contactPhone: contactPhone,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, VendorEntity>> updateVendor({
    required String id,
    required String name,
    required String pan,
    String? bankName,
    String? accountNumber,
    String? ifsc,
    String? contactName,
    String? contactPhone,
    required bool isActive,
  }) async {
    try {
      final model = await remoteDataSource.updateVendor(
        id: id,
        name: name,
        pan: pan,
        bankName: bankName,
        accountNumber: accountNumber,
        ifsc: ifsc,
        contactName: contactName,
        contactPhone: contactPhone,
        isActive: isActive,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteVendor(String id) async {
    try {
      await remoteDataSource.deleteVendor(id);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ── User Management ──────────────────────────────────────

  @override
  Future<Either<Failure, List<UserEntity>>> getUsers() async {
    try {
      final models = await remoteDataSource.getUsers();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUserRole({
    required String userId,
    required UserRole role,
  }) async {
    try {
      final model = await remoteDataSource.updateUserRole(
        userId: userId,
        role: role,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> toggleUserActive({
    required String userId,
    required bool isActive,
  }) async {
    try {
      final model = await remoteDataSource.toggleUserActive(
        userId: userId,
        isActive: isActive,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}