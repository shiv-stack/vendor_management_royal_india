// lib/features/dashboard/domain/usecases/dashboard_usecases.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/event_summary_entity.dart';
import '../entities/expense_detail_entity.dart';
import '../repositories/dashboard_repository.dart';

// ── Get Event Summaries (Level 1) ─────────────────────────────
class GetEventSummariesUseCase
    implements NoParamsUseCase<List<EventSummaryEntity>> {
  final DashboardRepository repository;
  const GetEventSummariesUseCase(this.repository);

  @override
  Future<Either<Failure, List<EventSummaryEntity>>> call() =>
      repository.getEventSummaries();
}

// ── Get Expense Details (Level 2) ─────────────────────────────
class GetExpenseDetailsUseCase
    implements UseCase<List<ExpenseDetailEntity>, String> {
  final DashboardRepository repository;
  const GetExpenseDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ExpenseDetailEntity>>> call(
          String eventId) =>
      repository.getExpenseDetails(eventId);
}