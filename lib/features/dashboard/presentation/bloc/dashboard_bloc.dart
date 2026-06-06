// lib/features/dashboard/presentation/bloc/dashboard_bloc.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/event_summary_entity.dart';
import '../../domain/entities/expense_detail_entity.dart';
import '../../domain/usecases/dashboard_usecases.dart';

// ══════════════════════════════════════════════════════════════
// EVENTS
// ══════════════════════════════════════════════════════════════
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
  @override
  List<Object?> get props => [];
}

// Load Level 1 — all event summaries
class DashboardLoadSummaries extends DashboardEvent {
  const DashboardLoadSummaries();
}

// Load Level 2 — drill down for one event
class DashboardLoadDetails extends DashboardEvent {
  final String eventId;
  final String eventName;
  const DashboardLoadDetails({
    required this.eventId,
    required this.eventName,
  });
  @override
  List<Object> get props => [eventId, eventName];
}

// ══════════════════════════════════════════════════════════════
// STATES
// ══════════════════════════════════════════════════════════════
abstract class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

// Level 1 loaded
class DashboardSummariesLoaded extends DashboardState {
  final List<EventSummaryEntity> summaries;

  // Grand totals across all events
  final double grandTotalIncurred;
  final double grandTotalPaid;
  final double grandTotalOutstanding;

  DashboardSummariesLoaded({required this.summaries})
      : grandTotalIncurred = summaries.fold(
            0, (sum, e) => sum + e.totalIncurred),
        grandTotalPaid =
            summaries.fold(0, (sum, e) => sum + e.totalPaid),
        grandTotalOutstanding =
            summaries.fold(0, (sum, e) => sum + e.outstanding);

  @override
  List<Object> get props => [
        summaries,
        grandTotalIncurred,
        grandTotalPaid,
        grandTotalOutstanding,
      ];
}

// Level 2 loaded
class DashboardDetailsLoaded extends DashboardState {
  final String eventId;
  final String eventName;
  final List<ExpenseDetailEntity> details;

  // Event totals
  final double eventTotalIncurred;
  final double eventTotalPaid;
  final double eventTotalOutstanding;

  DashboardDetailsLoaded({
    required this.eventId,
    required this.eventName,
    required this.details,
  })  : eventTotalIncurred =
            details.fold(0, (sum, e) => sum + e.totalAmount),
        eventTotalPaid =
            details.fold(0, (sum, e) => sum + e.totalPaid),
        eventTotalOutstanding =
            details.fold(0, (sum, e) => sum + e.outstanding);

  @override
  List<Object> get props => [
        eventId,
        eventName,
        details,
        eventTotalIncurred,
        eventTotalPaid,
        eventTotalOutstanding,
      ];
}

class DashboardFailure extends DashboardState {
  final String message;
  const DashboardFailure({required this.message});
  @override
  List<Object> get props => [message];
}

// ══════════════════════════════════════════════════════════════
// BLOC
// ══════════════════════════════════════════════════════════════
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetEventSummariesUseCase getEventSummaries;
  final GetExpenseDetailsUseCase getExpenseDetails;

  DashboardBloc({
    required this.getEventSummaries,
    required this.getExpenseDetails,
  }) : super(const DashboardInitial()) {
    on<DashboardLoadSummaries>(_onLoadSummaries);
    on<DashboardLoadDetails>(_onLoadDetails);
  }

  // ── Load Level 1 ──────────────────────────────────────────
  Future<void> _onLoadSummaries(
    DashboardLoadSummaries event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());
    final result = await getEventSummaries();
    result.fold(
      (f) => emit(DashboardFailure(message: f.message)),
      (summaries) =>
          emit(DashboardSummariesLoaded(summaries: summaries)),
    );
  }

  // ── Load Level 2 ──────────────────────────────────────────
  Future<void> _onLoadDetails(
    DashboardLoadDetails event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());
    final result = await getExpenseDetails(event.eventId);
    result.fold(
      (f) => emit(DashboardFailure(message: f.message)),
      (details) => emit(DashboardDetailsLoaded(
        eventId:   event.eventId,
        eventName: event.eventName,
        details:   details,
      )),
    );
  }
}