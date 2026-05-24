// lib/features/expense/domain/usecases/payment_usecases.dart
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/payment_entity.dart';
import '../repositories/expense_repository.dart';

// ── Upload Payment Screenshot ─────────────────────────────────
class UploadPaymentScreenshotUseCase
    implements UseCase<String, UploadScreenshotParams> {
  final ExpenseRepository repository;
  const UploadPaymentScreenshotUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(
          UploadScreenshotParams params) =>
      repository.uploadPaymentScreenshot(
        file:      params.file,
        paymentId: params.paymentId,
      );
}

class UploadScreenshotParams extends Equatable {
  final File file;
  final String paymentId;
  const UploadScreenshotParams({
    required this.file,
    required this.paymentId,
  });
  @override
  List<Object> get props => [file.path, paymentId];
}

// ── Process Payment ───────────────────────────────────────────
class ProcessPaymentUseCase
    implements UseCase<PaymentEntity, ProcessPaymentParams> {
  final ExpenseRepository repository;
  const ProcessPaymentUseCase(this.repository);

  @override
  Future<Either<Failure, PaymentEntity>> call(
          ProcessPaymentParams params) =>
      repository.processPayment(
        expenseRequestId: params.expenseRequestId,
        amount:           params.amount,
        paymentType:      params.paymentType,
        paymentMode:      params.paymentMode,
        screenshotUrl:    params.screenshotUrl,
        remarks:          params.remarks,
      );
}

class ProcessPaymentParams extends Equatable {
  final String expenseRequestId;
  final double amount;
  final String paymentType;
  final String paymentMode;
  final String screenshotUrl;
  final String? remarks;

  const ProcessPaymentParams({
    required this.expenseRequestId,
    required this.amount,
    required this.paymentType,
    required this.paymentMode,
    required this.screenshotUrl,
    this.remarks,
  });

  @override
  List<Object?> get props => [
        expenseRequestId,
        amount,
        paymentType,
        paymentMode,
        screenshotUrl,
        remarks,
      ];
}

// ── Get Payments For Expense ──────────────────────────────────
class GetPaymentsForExpenseUseCase
    implements UseCase<List<PaymentEntity>, String> {
  final ExpenseRepository repository;
  const GetPaymentsForExpenseUseCase(this.repository);

  @override
  Future<Either<Failure, List<PaymentEntity>>> call(
          String expenseRequestId) =>
      repository.getPaymentsForExpense(expenseRequestId);
}