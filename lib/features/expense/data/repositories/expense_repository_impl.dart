// lib/features/expense/data/repositories/expense_repository_impl.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:fpdart/fpdart.dart';
import 'package:vpms_royal_india/features/expense/data/models/expense_request_model.dart';
import 'package:vpms_royal_india/features/expense/data/models/payment_model.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/expense_request_entity.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_remote_datasource.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDataSource remoteDataSource;

  const ExpenseRepositoryImpl({required this.remoteDataSource});

  // ── File Upload ──────────────────────────────────────────

  @override
  Future<Either<Failure, String>> uploadBillAttachment({
    File? file,
    Uint8List? fileBytes,
    required String fileExtension,
    required String expenseRequestId,
  }) async {
    try {
      final url = await remoteDataSource.uploadBillAttachment(
        file: file,
        fileBytes: fileBytes,
        fileExtension: fileExtension,
        expenseRequestId: expenseRequestId,
      );
      return Right(url);
    } on AppStorageException catch (e) {
      return Left(StorageFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadPaymentScreenshot({
    File? file,
    Uint8List? fileBytes,
    required String fileExtension,
    required String paymentId,
  }) async {
    try {
      final url = await remoteDataSource.uploadPaymentScreenshot(
        file: file,
        fileBytes: fileBytes,
        fileExtension: fileExtension,
        paymentId: paymentId,
      );
      return Right(url);
    } on AppStorageException catch (e) {
      return Left(StorageFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ── Employee ─────────────────────────────────────────────

  @override
  Future<Either<Failure, ExpenseRequestEntity>> submitExpense({
    required String eventId,
    required String expenseTypeId,
    required String vendorId,
    required String hodId,
    required double totalAmount,
    required double advancePaid,
    required String paymentStatus,
    required String billAttachmentUrl,
    String? description,
  }) async {
    try {
      final model = await remoteDataSource.submitExpense(
        eventId: eventId,
        expenseTypeId: expenseTypeId,
        vendorId: vendorId,
        hodId: hodId,
        totalAmount: totalAmount,
        advancePaid: advancePaid,
        paymentStatus: paymentStatus,
        billAttachmentUrl: billAttachmentUrl,
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
  Future<Either<Failure, ExpenseRequestEntity>> resubmitExpense({
    required String expenseRequestId,
    required String eventId,
    required String expenseTypeId,
    required String vendorId,
    required String hodId,
    required double totalAmount,
    required double advancePaid,
    required String paymentStatus,
    required String billAttachmentUrl,
    String? description,
  }) async {
    try {
      final model = await remoteDataSource.resubmitExpense(
        expenseRequestId: expenseRequestId,
        eventId: eventId,
        expenseTypeId: expenseTypeId,
        vendorId: vendorId,
        hodId: hodId,
        totalAmount: totalAmount,
        advancePaid: advancePaid,
        paymentStatus: paymentStatus,
        billAttachmentUrl: billAttachmentUrl,
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
  Future<Either<Failure, List<ExpenseRequestEntity>>>
      getEmployeeExpenses() async {
    try {
      final models = await remoteDataSource.getEmployeeExpenses();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ── HOD / MD ─────────────────────────────────────────────

  @override
  Future<Either<Failure, List<ExpenseRequestEntity>>>
      getAssignedExpenses() async {
    try {
      final models = await remoteDataSource.getAssignedExpenses();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ExpenseRequestEntity>> approveExpense(
      String expenseRequestId) async {
    try {
      final model = await remoteDataSource.approveExpense(expenseRequestId);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ExpenseRequestEntity>> rejectExpense({
    required String expenseRequestId,
    required String rejectionReason,
  }) async {
    try {
      final model = await remoteDataSource.rejectExpense(
        expenseRequestId: expenseRequestId,
        rejectionReason: rejectionReason,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ExpenseRequestEntity>> reApproveExpense(
      String expenseRequestId) async {
    try {
      final model = await remoteDataSource.reApproveExpense(expenseRequestId);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ── Accounts ─────────────────────────────────────────────

  @override
  Future<Either<Failure, List<ExpenseRequestEntity>>> getAccountsQueue() async {
    try {
      final models = await remoteDataSource.getAccountsQueue();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ExpenseRequestEntity>> returnToHod({
    required String expenseRequestId,
    required String returnReason,
  }) async {
    try {
      final model = await remoteDataSource.returnToHod(
        expenseRequestId: expenseRequestId,
        returnReason: returnReason,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaymentEntity>> processPayment({
    required String expenseRequestId,
    required double amount,
    required String paymentType,
    required String paymentMode,
    required String screenshotUrl,
    String? remarks,
  }) async {
    try {
      final model = await remoteDataSource.processPayment(
        expenseRequestId: expenseRequestId,
        amount: amount,
        paymentType: paymentType,
        paymentMode: paymentMode,
        screenshotUrl: screenshotUrl,
        remarks: remarks,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PaymentEntity>>> getPaymentsForExpense(
      String expenseRequestId) async {
    try {
      final models =
          await remoteDataSource.getPaymentsForExpense(expenseRequestId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ── Shared ────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getHodList() async {
    try {
      final list = await remoteDataSource.getHodList();
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> getMdUser() async {
    try {
      final md = await remoteDataSource.getMdUser();
      return Right(md);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
