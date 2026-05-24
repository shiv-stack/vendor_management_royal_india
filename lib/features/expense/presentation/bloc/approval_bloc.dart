// lib/features/expense/presentation/bloc/approval_bloc.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/expense_request_entity.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/usecases/expense_usecases.dart';
import '../../domain/usecases/payment_usecases.dart';
import 'dart:io';

// ══════════════════════════════════════════════════════════════
// EVENTS
// ══════════════════════════════════════════════════════════════
abstract class ApprovalEvent extends Equatable {
  const ApprovalEvent();
  @override
  List<Object?> get props => [];
}

// HOD/MD loads their pending queue
class ApprovalLoadQueue extends ApprovalEvent {
  const ApprovalLoadQueue();
}

// HOD/MD approves
class ApprovalApprove extends ApprovalEvent {
  final String expenseRequestId;
  const ApprovalApprove({required this.expenseRequestId});
  @override
  List<Object> get props => [expenseRequestId];
}

// HOD/MD rejects with reason
class ApprovalReject extends ApprovalEvent {
  final String expenseRequestId;
  final String rejectionReason;
  const ApprovalReject({
    required this.expenseRequestId,
    required this.rejectionReason,
  });
  @override
  List<Object> get props => [expenseRequestId, rejectionReason];
}

// HOD re-approves from RETURNED_TO_HOD
class ApprovalReApprove extends ApprovalEvent {
  final String expenseRequestId;
  const ApprovalReApprove({required this.expenseRequestId});
  @override
  List<Object> get props => [expenseRequestId];
}

// Accounts loads queue
class ApprovalLoadAccountsQueue extends ApprovalEvent {
  const ApprovalLoadAccountsQueue();
}

// Accounts returns to HOD
class ApprovalReturnToHod extends ApprovalEvent {
  final String expenseRequestId;
  final String returnReason;
  const ApprovalReturnToHod({
    required this.expenseRequestId,
    required this.returnReason,
  });
  @override
  List<Object> get props => [expenseRequestId, returnReason];
}

// Accounts processes payment
class ApprovalProcessPayment extends ApprovalEvent {
  final String expenseRequestId;
  final double amount;
  final String paymentType;
  final String paymentMode;
  final File screenshotFile;
  final String? remarks;

  const ApprovalProcessPayment({
    required this.expenseRequestId,
    required this.amount,
    required this.paymentType,
    required this.paymentMode,
    required this.screenshotFile,
    this.remarks,
  });

  @override
  List<Object?> get props => [
        expenseRequestId, amount,
        paymentType, paymentMode,
        screenshotFile.path, remarks,
      ];
}

// Load payments for a specific expense
class ApprovalLoadPayments extends ApprovalEvent {
  final String expenseRequestId;
  const ApprovalLoadPayments({required this.expenseRequestId});
  @override
  List<Object> get props => [expenseRequestId];
}

// ══════════════════════════════════════════════════════════════
// STATES
// ══════════════════════════════════════════════════════════════
abstract class ApprovalState extends Equatable {
  const ApprovalState();
  @override
  List<Object?> get props => [];
}

class ApprovalInitial extends ApprovalState {
  const ApprovalInitial();
}

class ApprovalLoading extends ApprovalState {
  const ApprovalLoading();
}

// HOD queue loaded
class ApprovalQueueLoaded extends ApprovalState {
  final List<ExpenseRequestEntity> requests;
  const ApprovalQueueLoaded({required this.requests});
  @override
  List<Object> get props => [requests];
}

// Accounts queue loaded
class ApprovalAccountsQueueLoaded extends ApprovalState {
  final List<ExpenseRequestEntity> requests;
  const ApprovalAccountsQueueLoaded({required this.requests});
  @override
  List<Object> get props => [requests];
}

// Any action (approve/reject/return/payment) succeeded
class ApprovalActionSuccess extends ApprovalState {
  final String message;
  const ApprovalActionSuccess({required this.message});
  @override
  List<Object> get props => [message];
}

// Payments for an expense loaded
class ApprovalPaymentsLoaded extends ApprovalState {
  final List<PaymentEntity> payments;
  const ApprovalPaymentsLoaded({required this.payments});
  @override
  List<Object> get props => [payments];
}

class ApprovalFailure extends ApprovalState {
  final String message;
  const ApprovalFailure({required this.message});
  @override
  List<Object> get props => [message];
}

// ══════════════════════════════════════════════════════════════
// BLOC
// ══════════════════════════════════════════════════════════════
class ApprovalBloc extends Bloc<ApprovalEvent, ApprovalState> {
  final GetAssignedExpensesUseCase getAssignedExpenses;
  final ApproveExpenseUseCase approveExpense;
  final RejectExpenseUseCase rejectExpense;
  final ReApproveExpenseUseCase reApproveExpense;
  final GetAccountsQueueUseCase getAccountsQueue;
  final ReturnToHodUseCase returnToHod;
  final ProcessPaymentUseCase processPayment;
  final UploadPaymentScreenshotUseCase uploadScreenshot;
  final GetPaymentsForExpenseUseCase getPayments;

  ApprovalBloc({
    required this.getAssignedExpenses,
    required this.approveExpense,
    required this.rejectExpense,
    required this.reApproveExpense,
    required this.getAccountsQueue,
    required this.returnToHod,
    required this.processPayment,
    required this.uploadScreenshot,
    required this.getPayments,
  }) : super(const ApprovalInitial()) {
    on<ApprovalLoadQueue>(_onLoadQueue);
    on<ApprovalApprove>(_onApprove);
    on<ApprovalReject>(_onReject);
    on<ApprovalReApprove>(_onReApprove);
    on<ApprovalLoadAccountsQueue>(_onLoadAccountsQueue);
    on<ApprovalReturnToHod>(_onReturnToHod);
    on<ApprovalProcessPayment>(_onProcessPayment);
    on<ApprovalLoadPayments>(_onLoadPayments);
  }

  // ── HOD/MD queue ──────────────────────────────────────────
  Future<void> _onLoadQueue(
    ApprovalLoadQueue event,
    Emitter<ApprovalState> emit,
  ) async {
    emit(const ApprovalLoading());
    final result = await getAssignedExpenses();
    result.fold(
      (f) => emit(ApprovalFailure(message: f.message)),
      (requests) =>
          emit(ApprovalQueueLoaded(requests: requests)),
    );
  }

  // ── Approve ───────────────────────────────────────────────
  Future<void> _onApprove(
    ApprovalApprove event,
    Emitter<ApprovalState> emit,
  ) async {
    emit(const ApprovalLoading());
    final result =
        await approveExpense(event.expenseRequestId);
    await result.fold(
      (f) async => emit(ApprovalFailure(message: f.message)),
      (_) async {
        emit(const ApprovalActionSuccess(
            message: 'Expense approved successfully.'));
        // Reload queue
        final queue = await getAssignedExpenses();
        queue.fold(
          (f) => emit(ApprovalFailure(message: f.message)),
          (requests) =>
              emit(ApprovalQueueLoaded(requests: requests)),
        );
      },
    );
  }

  // ── Reject ────────────────────────────────────────────────
  Future<void> _onReject(
    ApprovalReject event,
    Emitter<ApprovalState> emit,
  ) async {
    emit(const ApprovalLoading());
    final result = await rejectExpense(
      RejectExpenseParams(
        expenseRequestId: event.expenseRequestId,
        rejectionReason:  event.rejectionReason,
      ),
    );
    await result.fold(
      (f) async => emit(ApprovalFailure(message: f.message)),
      (_) async {
        emit(const ApprovalActionSuccess(
            message: 'Expense rejected.'));
        final queue = await getAssignedExpenses();
        queue.fold(
          (f) => emit(ApprovalFailure(message: f.message)),
          (requests) =>
              emit(ApprovalQueueLoaded(requests: requests)),
        );
      },
    );
  }

  // ── Re-Approve (HOD from RETURNED_TO_HOD) ─────────────────
  Future<void> _onReApprove(
    ApprovalReApprove event,
    Emitter<ApprovalState> emit,
  ) async {
    emit(const ApprovalLoading());
    final result =
        await reApproveExpense(event.expenseRequestId);
    await result.fold(
      (f) async => emit(ApprovalFailure(message: f.message)),
      (_) async {
        emit(const ApprovalActionSuccess(
            message: 'Expense re-approved to Accounts.'));
        final queue = await getAssignedExpenses();
        queue.fold(
          (f) => emit(ApprovalFailure(message: f.message)),
          (requests) =>
              emit(ApprovalQueueLoaded(requests: requests)),
        );
      },
    );
  }

  // ── Accounts queue ────────────────────────────────────────
  Future<void> _onLoadAccountsQueue(
    ApprovalLoadAccountsQueue event,
    Emitter<ApprovalState> emit,
  ) async {
    emit(const ApprovalLoading());
    final result = await getAccountsQueue();
    result.fold(
      (f) => emit(ApprovalFailure(message: f.message)),
      (requests) =>
          emit(ApprovalAccountsQueueLoaded(requests: requests)),
    );
  }

  // ── Return to HOD ─────────────────────────────────────────
  Future<void> _onReturnToHod(
    ApprovalReturnToHod event,
    Emitter<ApprovalState> emit,
  ) async {
    emit(const ApprovalLoading());
    final result = await returnToHod(
      ReturnToHodParams(
        expenseRequestId: event.expenseRequestId,
        returnReason:     event.returnReason,
      ),
    );
    await result.fold(
      (f) async => emit(ApprovalFailure(message: f.message)),
      (_) async {
        emit(const ApprovalActionSuccess(
            message: 'Request returned to HOD.'));
        final queue = await getAccountsQueue();
        queue.fold(
          (f) => emit(ApprovalFailure(message: f.message)),
          (requests) =>
              emit(ApprovalAccountsQueueLoaded(requests: requests)),
        );
      },
    );
  }

  // ── Process Payment ───────────────────────────────────────
  Future<void> _onProcessPayment(
    ApprovalProcessPayment event,
    Emitter<ApprovalState> emit,
  ) async {
    emit(const ApprovalLoading());

    // Step 1: Upload screenshot
    final tempId = DateTime.now().millisecondsSinceEpoch.toString();
    final uploadResult = await uploadScreenshot(
      UploadScreenshotParams(
        file:      event.screenshotFile,
        paymentId: tempId,
      ),
    );

    if (uploadResult.isLeft()) {
      emit(ApprovalFailure(
          message:
              uploadResult.fold((f) => f.message, (_) => '')));
      return;
    }

    final screenshotUrl =
        uploadResult.fold((_) => '', (url) => url);

    // Step 2: Record payment
    final result = await processPayment(
      ProcessPaymentParams(
        expenseRequestId: event.expenseRequestId,
        amount:           event.amount,
        paymentType:      event.paymentType,
        paymentMode:      event.paymentMode,
        screenshotUrl:    screenshotUrl,
        remarks:          event.remarks,
      ),
    );

    await result.fold(
      (f) async => emit(ApprovalFailure(message: f.message)),
      (_) async {
        emit(const ApprovalActionSuccess(
            message: 'Payment recorded successfully.'));
        // Reload accounts queue
        final queue = await getAccountsQueue();
        queue.fold(
          (f) => emit(ApprovalFailure(message: f.message)),
          (requests) =>
              emit(ApprovalAccountsQueueLoaded(requests: requests)),
        );
      },
    );
  }

  // ── Load payments for expense ─────────────────────────────
  Future<void> _onLoadPayments(
    ApprovalLoadPayments event,
    Emitter<ApprovalState> emit,
  ) async {
    emit(const ApprovalLoading());
    final result =
        await getPayments(event.expenseRequestId);
    result.fold(
      (f) => emit(ApprovalFailure(message: f.message)),
      (payments) =>
          emit(ApprovalPaymentsLoaded(payments: payments)),
    );
  }
}