// lib/features/dashboard/data/datasources/dashboard_remote_datasource.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/supabase_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/event_summary_model.dart';
import '../models/expense_detail_model.dart';

// ── Abstract ──────────────────────────────────────────────────
abstract class DashboardRemoteDataSource {
  /// Level 1 — summary per event
  Future<List<EventSummaryModel>> getEventSummaries();

  /// Level 2 — drill down per event
  Future<List<ExpenseDetailModel>> getExpenseDetails(String eventId);
}

// ── Implementation ────────────────────────────────────────────
class DashboardRemoteDataSourceImpl
    implements DashboardRemoteDataSource {
  final SupabaseClient supabaseClient;

  const DashboardRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<EventSummaryModel>> getEventSummaries() async {
    try {
      final data = await supabaseClient
          .from(SupabaseConstants.viewEventDashboard)
          .select()
          .order('event_name');

      return (data as List)
          .map((e) => EventSummaryModel.fromSupabase(e))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ExpenseDetailModel>> getExpenseDetails(
      String eventId) async {
    try {
      final data = await supabaseClient
          .from(SupabaseConstants.viewEventExpenseDetail)
          .select()
          .eq('event_id', eventId)
          .order('created_at', ascending: false);

      return (data as List)
          .map((e) => ExpenseDetailModel.fromSupabase(e))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
