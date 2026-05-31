// lib/features/expense/domain/repositories/expense_repository.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/expense_request_entity.dart';
import '../entities/payment_entity.dart';

abstract class ExpenseRepository {
  // ── File Upload ──────────────────────────────────────────
  Future<Either<Failure, String>> uploadBillAttachment({
  File? file,
  Uint8List? fileBytes,
  required String fileExtension,
  required String expenseRequestId,
});

  Future<Either<Failure, String>> uploadPaymentScreenshot({
    required File file,
    required String paymentId,
  });

  // ── Employee ─────────────────────────────────────────────
  Future<Either<Failure, ExpenseRequestEntity>> submitExpense({
    required String eventId,
    required String expenseTypeId,
    required String vendorId,
    required String hodId,
    required double totalAmount,
    required double advancePaid,
    required String paymentStatus,
    required String billAttachmentUrl,
  });

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
  });

  Future<Either<Failure, List<ExpenseRequestEntity>>>
      getEmployeeExpenses();

  // ── HOD / MD ─────────────────────────────────────────────
  Future<Either<Failure, List<ExpenseRequestEntity>>>
      getAssignedExpenses();

  Future<Either<Failure, ExpenseRequestEntity>> approveExpense(
      String expenseRequestId);

  Future<Either<Failure, ExpenseRequestEntity>> rejectExpense({
    required String expenseRequestId,
    required String rejectionReason,
  });

  Future<Either<Failure, ExpenseRequestEntity>> reApproveExpense(
      String expenseRequestId);

  // ── Accounts ─────────────────────────────────────────────
  Future<Either<Failure, List<ExpenseRequestEntity>>>
      getAccountsQueue();

  Future<Either<Failure, ExpenseRequestEntity>> returnToHod({
    required String expenseRequestId,
    required String returnReason,
  });

  Future<Either<Failure, PaymentEntity>> processPayment({
    required String expenseRequestId,
    required double amount,
    required String paymentType,
    required String paymentMode,
    required String screenshotUrl,
    String? remarks,
  });

  Future<Either<Failure, List<PaymentEntity>>> getPaymentsForExpense(
      String expenseRequestId);

  // ── Shared ────────────────────────────────────────────────
  Future<Either<Failure, List<Map<String, dynamic>>>> getHodList();

  Future<Either<Failure, Map<String, dynamic>?>> getMdUser();
}