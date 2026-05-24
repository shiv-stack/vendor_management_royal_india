// lib/features/expense/presentation/bloc/expense_bloc.dart
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/expense_request_entity.dart';
import '../../domain/usecases/expense_usecases.dart';

// ══════════════════════════════════════════════════════════════
// EVENTS
// ══════════════════════════════════════════════════════════════
abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();
  @override
  List<Object?> get props => [];
}

// Load master data needed for submit form
class ExpenseLoadFormData extends ExpenseEvent {
  const ExpenseLoadFormData();
}

// Employee submits new expense
class ExpenseSubmit extends ExpenseEvent {
  final String eventId;
  final String expenseTypeId;
  final String vendorId;
  final String hodId;
  final double totalAmount;
  final double advancePaid;
  final ExpensePaymentStatus paymentStatus;
  final File billFile;

  const ExpenseSubmit({
    required this.eventId,
    required this.expenseTypeId,
    required this.vendorId,
    required this.hodId,
    required this.totalAmount,
    required this.advancePaid,
    required this.paymentStatus,
    required this.billFile,
  });

  @override
  List<Object?> get props => [
        eventId, expenseTypeId, vendorId,
        hodId, totalAmount, advancePaid,
        paymentStatus, billFile.path,
      ];
}

// Employee resubmits a rejected expense
class ExpenseResubmit extends ExpenseEvent {
  final String expenseRequestId;
  final String eventId;
  final String expenseTypeId;
  final String vendorId;
  final String hodId;
  final double totalAmount;
  final double advancePaid;
  final ExpensePaymentStatus paymentStatus;
  final File? newBillFile;            // null = keep existing bill
  final String? existingBillUrl;     // used if no new file

  const ExpenseResubmit({
    required this.expenseRequestId,
    required this.eventId,
    required this.expenseTypeId,
    required this.vendorId,
    required this.hodId,
    required this.totalAmount,
    required this.advancePaid,
    required this.paymentStatus,
    this.newBillFile,
    this.existingBillUrl,
  });

  @override
  List<Object?> get props => [
        expenseRequestId, eventId,
        expenseTypeId, vendorId, hodId,
        totalAmount, advancePaid, paymentStatus,
      ];
}

// Load employee's own expense list
class ExpenseLoadMyRequests extends ExpenseEvent {
  const ExpenseLoadMyRequests();
}

// ══════════════════════════════════════════════════════════════
// STATES
// ══════════════════════════════════════════════════════════════
abstract class ExpenseState extends Equatable {
  const ExpenseState();
  @override
  List<Object?> get props => [];
}

class ExpenseInitial extends ExpenseState {
  const ExpenseInitial();
}

class ExpenseLoading extends ExpenseState {
  const ExpenseLoading();
}

// Form data loaded — dropdowns ready
class ExpenseFormReady extends ExpenseState {
  final List<Map<String, dynamic>> events;
  final List<Map<String, dynamic>> expenseTypes;
  final List<Map<String, dynamic>> vendors;
  final List<Map<String, dynamic>> hodList;

  const ExpenseFormReady({
    required this.events,
    required this.expenseTypes,
    required this.vendors,
    required this.hodList,
  });

  @override
  List<Object?> get props =>
      [events, expenseTypes, vendors, hodList];
}

// Employee's request list loaded
class ExpenseMyRequestsLoaded extends ExpenseState {
  final List<ExpenseRequestEntity> requests;
  const ExpenseMyRequestsLoaded({required this.requests});
  @override
  List<Object?> get props => [requests];
}

// Submit / resubmit succeeded
class ExpenseSubmitSuccess extends ExpenseState {
  final ExpenseRequestEntity expense;
  const ExpenseSubmitSuccess({required this.expense});
  @override
  List<Object?> get props => [expense];
}

class ExpenseFailure extends ExpenseState {
  final String message;
  const ExpenseFailure({required this.message});
  @override
  List<Object?> get props => [message];
}

// ══════════════════════════════════════════════════════════════
// BLOC
// ══════════════════════════════════════════════════════════════
class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final SubmitExpenseUseCase submitExpense;
  final ResubmitExpenseUseCase resubmitExpense;
  final GetEmployeeExpensesUseCase getEmployeeExpenses;
  final UploadBillAttachmentUseCase uploadBill;
  final GetHodListUseCase getHodList;
  final GetMdUserUseCase getMdUser;

  // Injected master data — loaded once from admin feature
  final Future<List<Map<String, dynamic>>> Function() fetchEvents;
  final Future<List<Map<String, dynamic>>> Function() fetchExpenseTypes;
  final Future<List<Map<String, dynamic>>> Function() fetchVendors;

  ExpenseBloc({
    required this.submitExpense,
    required this.resubmitExpense,
    required this.getEmployeeExpenses,
    required this.uploadBill,
    required this.getHodList,
    required this.getMdUser,
    required this.fetchEvents,
    required this.fetchExpenseTypes,
    required this.fetchVendors,
  }) : super(const ExpenseInitial()) {
    on<ExpenseLoadFormData>(_onLoadFormData);
    on<ExpenseSubmit>(_onSubmit);
    on<ExpenseResubmit>(_onResubmit);
    on<ExpenseLoadMyRequests>(_onLoadMyRequests);
  }

  // ── Load form dropdowns ───────────────────────────────────
  Future<void> _onLoadFormData(
    ExpenseLoadFormData event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());
    try {
      // Fetch all in parallel
      final results = await Future.wait([
        fetchEvents(),
        fetchExpenseTypes(),
        fetchVendors(),
      ]);

      final hodResult = await getHodList();

      // Check if current user is HOD → get MD instead
      final hodList = hodResult.fold(
        (_) => <Map<String, dynamic>>[],
        (list) => list,
      );

      emit(ExpenseFormReady(
        events:       results[0],
        expenseTypes: results[1],
        vendors:      results[2],
        hodList:      hodList,
      ));
    } catch (e) {
      emit(ExpenseFailure(message: e.toString()));
    }
  }

  // ── Submit new expense ────────────────────────────────────
  Future<void> _onSubmit(
    ExpenseSubmit event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());

    // Step 1: Upload bill — use temp ID, will be replaced by real ID
    // We use a timestamp as temp folder name
    final tempId = DateTime.now().millisecondsSinceEpoch.toString();
    final uploadResult = await uploadBill(
      UploadBillParams(
        file: event.billFile,
        expenseRequestId: tempId,
      ),
    );

    if (uploadResult.isLeft()) {
      emit(ExpenseFailure(
          message: uploadResult.fold((f) => f.message, (_) => '')));
      return;
    }

    final billUrl = uploadResult.fold((_) => '', (url) => url);

    // Step 2: Submit expense record
    final result = await submitExpense(
      SubmitExpenseParams(
        eventId:           event.eventId,
        expenseTypeId:     event.expenseTypeId,
        vendorId:          event.vendorId,
        hodId:             event.hodId,
        totalAmount:       event.totalAmount,
        advancePaid:       event.advancePaid,
        paymentStatus:     event.paymentStatus.dbValue,
        billAttachmentUrl: billUrl,
      ),
    );

    result.fold(
      (f) => emit(ExpenseFailure(message: f.message)),
      (expense) => emit(ExpenseSubmitSuccess(expense: expense)),
    );
  }

  // ── Resubmit rejected expense ─────────────────────────────
  Future<void> _onResubmit(
    ExpenseResubmit event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());

    String billUrl = event.existingBillUrl ?? '';

    // Upload new bill only if provided
    if (event.newBillFile != null) {
      final uploadResult = await uploadBill(
        UploadBillParams(
          file: event.newBillFile!,
          expenseRequestId: event.expenseRequestId,
        ),
      );

      if (uploadResult.isLeft()) {
        emit(ExpenseFailure(
            message:
                uploadResult.fold((f) => f.message, (_) => '')));
        return;
      }

      billUrl = uploadResult.fold((_) => '', (url) => url);
    }

    final result = await resubmitExpense(
      ResubmitExpenseParams(
        expenseRequestId:  event.expenseRequestId,
        eventId:           event.eventId,
        expenseTypeId:     event.expenseTypeId,
        vendorId:          event.vendorId,
        hodId:             event.hodId,
        totalAmount:       event.totalAmount,
        advancePaid:       event.advancePaid,
        paymentStatus:     event.paymentStatus.dbValue,
        billAttachmentUrl: billUrl,
      ),
    );

    result.fold(
      (f) => emit(ExpenseFailure(message: f.message)),
      (expense) => emit(ExpenseSubmitSuccess(expense: expense)),
    );
  }

  // ── Load my requests ──────────────────────────────────────
  Future<void> _onLoadMyRequests(
    ExpenseLoadMyRequests event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());
    final result = await getEmployeeExpenses();
    result.fold(
      (f) => emit(ExpenseFailure(message: f.message)),
      (requests) =>
          emit(ExpenseMyRequestsLoaded(requests: requests)),
    );
  }
}