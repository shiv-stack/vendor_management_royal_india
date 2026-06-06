// lib/features/dashboard/domain/repositories/dashboard_repository.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/event_summary_entity.dart';
import '../entities/expense_detail_entity.dart';

abstract class DashboardRepository {
  /// Level 1 — all events summary
  Future<Either<Failure, List<EventSummaryEntity>>>
      getEventSummaries();

  /// Level 2 — drill down for one event
  Future<Either<Failure, List<ExpenseDetailEntity>>>
      getExpenseDetails(String eventId);
}