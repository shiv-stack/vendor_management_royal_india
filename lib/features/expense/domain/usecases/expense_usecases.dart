// lib/features/expense/domain/usecases/expense_usecases.dart
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/expense_request_entity.dart';
import '../repositories/expense_repository.dart';

// ── Upload Bill Attachment ────────────────────────────────────
class UploadBillAttachmentUseCase
    implements UseCase<String, UploadBillParams> {
  final ExpenseRepository repository;
  const UploadBillAttachmentUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(UploadBillParams params) =>
      repository.uploadBillAttachment(
        file: params.file,
        expenseRequestId: params.expenseRequestId,
      );
}

class UploadBillParams extends Equatable {
  final File file;
  final String expenseRequestId;
  const UploadBillParams({
    required this.file,
    required this.expenseRequestId,
  });
  @override
  List<Object> get props => [file.path, expenseRequestId];
}

// ── Submit Expense ────────────────────────────────────────────
class SubmitExpenseUseCase
    implements UseCase<ExpenseRequestEntity, SubmitExpenseParams> {
  final ExpenseRepository repository;
  const SubmitExpenseUseCase(this.repository);

  @override
  Future<Either<Failure, ExpenseRequestEntity>> call(
      SubmitExpenseParams params) =>
      repository.submitExpense(
        eventId:           params.eventId,
        expenseTypeId:     params.expenseTypeId,
        vendorId:          params.vendorId,
        hodId:             params.hodId,
        totalAmount:       params.totalAmount,
        advancePaid:       params.advancePaid,
        paymentStatus:     params.paymentStatus,
        billAttachmentUrl: params.billAttachmentUrl,
      );
}

class SubmitExpenseParams extends Equatable {
  final String eventId;
  final String expenseTypeId;
  final String vendorId;
  final String hodId;
  final double totalAmount;
  final double advancePaid;
  final String paymentStatus;
  final String billAttachmentUrl;

  const SubmitExpenseParams({
    required this.eventId,
    required this.expenseTypeId,
    required this.vendorId,
    required this.hodId,
    required this.totalAmount,
    required this.advancePaid,
    required this.paymentStatus,
    required this.billAttachmentUrl,
  });

  @override
  List<Object> get props => [
        eventId,
        expenseTypeId,
        vendorId,
        hodId,
        totalAmount,
        advancePaid,
        paymentStatus,
        billAttachmentUrl,
      ];
}

// ── Resubmit Expense ──────────────────────────────────────────
class ResubmitExpenseUseCase
    implements UseCase<ExpenseRequestEntity, ResubmitExpenseParams> {
  final ExpenseRepository repository;
  const ResubmitExpenseUseCase(this.repository);

  @override
  Future<Either<Failure, ExpenseRequestEntity>> call(
      ResubmitExpenseParams params) =>
      repository.resubmitExpense(
        expenseRequestId:  params.expenseRequestId,
        eventId:           params.eventId,
        expenseTypeId:     params.expenseTypeId,
        vendorId:          params.vendorId,
        hodId:             params.hodId,
        totalAmount:       params.totalAmount,
        advancePaid:       params.advancePaid,
        paymentStatus:     params.paymentStatus,
        billAttachmentUrl: params.billAttachmentUrl,
      );
}

class ResubmitExpenseParams extends Equatable {
  final String expenseRequestId;
  final String eventId;
  final String expenseTypeId;
  final String vendorId;
  final String hodId;
  final double totalAmount;
  final double advancePaid;
  final String paymentStatus;
  final String billAttachmentUrl;

  const ResubmitExpenseParams({
    required this.expenseRequestId,
    required this.eventId,
    required this.expenseTypeId,
    required this.vendorId,
    required this.hodId,
    required this.totalAmount,
    required this.advancePaid,
    required this.paymentStatus,
    required this.billAttachmentUrl,
  });

  @override
  List<Object> get props => [
        expenseRequestId,
        eventId,
        expenseTypeId,
        vendorId,
        hodId,
        totalAmount,
        advancePaid,
        paymentStatus,
        billAttachmentUrl,
      ];
}

// ── Get Employee Expenses ─────────────────────────────────────
class GetEmployeeExpensesUseCase
    implements NoParamsUseCase<List<ExpenseRequestEntity>> {
  final ExpenseRepository repository;
  const GetEmployeeExpensesUseCase(this.repository);

  @override
  Future<Either<Failure, List<ExpenseRequestEntity>>> call() =>
      repository.getEmployeeExpenses();
}

// ── Get Assigned Expenses (HOD/MD) ────────────────────────────
class GetAssignedExpensesUseCase
    implements NoParamsUseCase<List<ExpenseRequestEntity>> {
  final ExpenseRepository repository;
  const GetAssignedExpensesUseCase(this.repository);

  @override
  Future<Either<Failure, List<ExpenseRequestEntity>>> call() =>
      repository.getAssignedExpenses();
}

// ── Approve Expense ───────────────────────────────────────────
class ApproveExpenseUseCase
    implements UseCase<ExpenseRequestEntity, String> {
  final ExpenseRepository repository;
  const ApproveExpenseUseCase(this.repository);

  @override
  Future<Either<Failure, ExpenseRequestEntity>> call(
          String expenseRequestId) =>
      repository.approveExpense(expenseRequestId);
}

// ── Reject Expense ────────────────────────────────────────────
class RejectExpenseUseCase
    implements UseCase<ExpenseRequestEntity, RejectExpenseParams> {
  final ExpenseRepository repository;
  const RejectExpenseUseCase(this.repository);

  @override
  Future<Either<Failure, ExpenseRequestEntity>> call(
          RejectExpenseParams params) =>
      repository.rejectExpense(
        expenseRequestId: params.expenseRequestId,
        rejectionReason:  params.rejectionReason,
      );
}

class RejectExpenseParams extends Equatable {
  final String expenseRequestId;
  final String rejectionReason;

  const RejectExpenseParams({
    required this.expenseRequestId,
    required this.rejectionReason,
  });

  @override
  List<Object> get props => [expenseRequestId, rejectionReason];
}

// ── Re-Approve Expense (HOD from RETURNED_TO_HOD) ────────────
class ReApproveExpenseUseCase
    implements UseCase<ExpenseRequestEntity, String> {
  final ExpenseRepository repository;
  const ReApproveExpenseUseCase(this.repository);

  @override
  Future<Either<Failure, ExpenseRequestEntity>> call(
          String expenseRequestId) =>
      repository.reApproveExpense(expenseRequestId);
}

// ── Get Accounts Queue ────────────────────────────────────────
class GetAccountsQueueUseCase
    implements NoParamsUseCase<List<ExpenseRequestEntity>> {
  final ExpenseRepository repository;
  const GetAccountsQueueUseCase(this.repository);

  @override
  Future<Either<Failure, List<ExpenseRequestEntity>>> call() =>
      repository.getAccountsQueue();
}

// ── Return To HOD ─────────────────────────────────────────────
class ReturnToHodUseCase
    implements UseCase<ExpenseRequestEntity, ReturnToHodParams> {
  final ExpenseRepository repository;
  const ReturnToHodUseCase(this.repository);

  @override
  Future<Either<Failure, ExpenseRequestEntity>> call(
          ReturnToHodParams params) =>
      repository.returnToHod(
        expenseRequestId: params.expenseRequestId,
        returnReason:     params.returnReason,
      );
}

class ReturnToHodParams extends Equatable {
  final String expenseRequestId;
  final String returnReason;

  const ReturnToHodParams({
    required this.expenseRequestId,
    required this.returnReason,
  });

  @override
  List<Object> get props => [expenseRequestId, returnReason];
}

// ── Get HOD List ──────────────────────────────────────────────
class GetHodListUseCase
    implements NoParamsUseCase<List<Map<String, dynamic>>> {
  final ExpenseRepository repository;
  const GetHodListUseCase(this.repository);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> call() =>
      repository.getHodList();
}

// ── Get MD User ───────────────────────────────────────────────
class GetMdUserUseCase
    implements NoParamsUseCase<Map<String, dynamic>?> {
  final ExpenseRepository repository;
  const GetMdUserUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>?>> call() =>
      repository.getMdUser();
}