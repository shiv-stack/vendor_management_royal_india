// lib/features/admin/data/datasources/admin_remote_datasource.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/supabase_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/event_model.dart';
import '../models/expense_type_model.dart';
import '../models/vendor_model.dart';
import '../../../auth/data/models/user_model.dart';

// ── Abstract contract ─────────────────────────────────────────
abstract class AdminRemoteDataSource {
  // Events
  Future<List<EventModel>> getEvents();
  Future<EventModel> createEvent({
    required String name,
    String? description,
  });
  Future<EventModel> updateEvent({
    required String id,
    required String name,
    String? description,
    required bool isActive,
  });
  Future<void> deleteEvent(String id);

  // Expense Types
  Future<List<ExpenseTypeModel>> getExpenseTypes();
  Future<ExpenseTypeModel> createExpenseType({
    required String name,
    String? description,
  });
  Future<ExpenseTypeModel> updateExpenseType({
    required String id,
    required String name,
    String? description,
    required bool isActive,
  });
  Future<void> deleteExpenseType(String id);

  // Vendors
  Future<List<VendorModel>> getVendors();
  Future<VendorModel> createVendor({
    required String name,
    required String pan,
    String? bankName,
    String? accountNumber,
    String? ifsc,
    String? contactName,
    String? contactPhone,
  });
  Future<VendorModel> updateVendor({
    required String id,
    required String name,
    required String pan,
    String? bankName,
    String? accountNumber,
    String? ifsc,
    String? contactName,
    String? contactPhone,
    required bool isActive,
  });
  Future<void> deleteVendor(String id);

  // User Management
  Future<List<UserModel>> getUsers();
  Future<UserModel> updateUserRole({
    required String userId,
    required UserRole role,
  });
  Future<UserModel> toggleUserActive({
    required String userId,
    required bool isActive,
  });
}

// ── Implementation ────────────────────────────────────────────
class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final SupabaseClient supabaseClient;

  const AdminRemoteDataSourceImpl({required this.supabaseClient});

  // ── Helper: get current user id ───────────────────────────
  String get _currentUserId =>
      supabaseClient.auth.currentUser?.id ?? '';

  // ════════════════════════════════════════════════════════════
  // EVENTS
  // ════════════════════════════════════════════════════════════

  @override
  Future<List<EventModel>> getEvents() async {
    try {
      final data = await supabaseClient
          .from(SupabaseConstants.tableEvents)
          .select()
          .order('created_at', ascending: false);

      return (data as List)
          .map((e) => EventModelX.fromSupabase(e))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<EventModel> createEvent({
    required String name,
    String? description,
  }) async {
    try {
      final data = await supabaseClient
          .from(SupabaseConstants.tableEvents)
          .insert({
            'name':        name,
            'description': description,
            'created_by':  _currentUserId,
          })
          .select()
          .single();

      return EventModelX.fromSupabase(data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<EventModel> updateEvent({
    required String id,
    required String name,
    String? description,
    required bool isActive,
  }) async {
    try {
      final data = await supabaseClient
          .from(SupabaseConstants.tableEvents)
          .update({
            'name':        name,
            'description': description,
            'is_active':   isActive,
          })
          .eq('id', id)
          .select()
          .single();

      return EventModelX.fromSupabase(data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteEvent(String id) async {
    try {
      await supabaseClient
          .from(SupabaseConstants.tableEvents)
          .delete()
          .eq('id', id);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  // ════════════════════════════════════════════════════════════
  // EXPENSE TYPES
  // ════════════════════════════════════════════════════════════

  @override
  Future<List<ExpenseTypeModel>> getExpenseTypes() async {
    try {
      final data = await supabaseClient
          .from(SupabaseConstants.tableExpenseTypes)
          .select()
          .order('created_at', ascending: false);

      return (data as List)
          .map((e) => ExpenseTypeModelX.fromSupabase(e))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ExpenseTypeModel> createExpenseType({
    required String name,
    String? description,
  }) async {
    try {
      final data = await supabaseClient
          .from(SupabaseConstants.tableExpenseTypes)
          .insert({
            'name':        name,
            'description': description,
            'created_by':  _currentUserId,
          })
          .select()
          .single();

      return ExpenseTypeModelX.fromSupabase(data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ExpenseTypeModel> updateExpenseType({
    required String id,
    required String name,
    String? description,
    required bool isActive,
  }) async {
    try {
      final data = await supabaseClient
          .from(SupabaseConstants.tableExpenseTypes)
          .update({
            'name':        name,
            'description': description,
            'is_active':   isActive,
          })
          .eq('id', id)
          .select()
          .single();

      return ExpenseTypeModelX.fromSupabase(data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteExpenseType(String id) async {
    try {
      await supabaseClient
          .from(SupabaseConstants.tableExpenseTypes)
          .delete()
          .eq('id', id);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  // ════════════════════════════════════════════════════════════
  // VENDORS
  // ════════════════════════════════════════════════════════════

  @override
  Future<List<VendorModel>> getVendors() async {
    try {
      final data = await supabaseClient
          .from(SupabaseConstants.tableVendors)
          .select()
          .order('created_at', ascending: false);

      return (data as List)
          .map((e) => VendorModelX.fromSupabase(e))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<VendorModel> createVendor({
    required String name,
    required String pan,
    String? bankName,
    String? accountNumber,
    String? ifsc,
    String? contactName,
    String? contactPhone,
  }) async {
    try {
      final data = await supabaseClient
          .from(SupabaseConstants.tableVendors)
          .insert({
            'name':           name,
            'pan':            pan.toUpperCase(),
            'bank_name':      bankName,
            'account_number': accountNumber,
            'ifsc':           ifsc,
            'contact_name':   contactName,
            'contact_phone':  contactPhone,
            'created_by':     _currentUserId,
          })
          .select()
          .single();

      return VendorModelX.fromSupabase(data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<VendorModel> updateVendor({
    required String id,
    required String name,
    required String pan,
    String? bankName,
    String? accountNumber,
    String? ifsc,
    String? contactName,
    String? contactPhone,
    required bool isActive,
  }) async {
    try {
      final data = await supabaseClient
          .from(SupabaseConstants.tableVendors)
          .update({
            'name':           name,
            'pan':            pan.toUpperCase(),
            'bank_name':      bankName,
            'account_number': accountNumber,
            'ifsc':           ifsc,
            'contact_name':   contactName,
            'contact_phone':  contactPhone,
            'is_active':      isActive,
          })
          .eq('id', id)
          .select()
          .single();

      return VendorModelX.fromSupabase(data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteVendor(String id) async {
    try {
      await supabaseClient
          .from(SupabaseConstants.tableVendors)
          .delete()
          .eq('id', id);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  // ════════════════════════════════════════════════════════════
  // USER MANAGEMENT
  // ════════════════════════════════════════════════════════════

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final data = await supabaseClient
          .from(SupabaseConstants.tableProfiles)
          .select()
          .order('created_at', ascending: false);

      return (data as List)
          .map((e) => UserModelX.fromSupabase(e))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> updateUserRole({
    required String userId,
    required UserRole role,
  }) async {
    try {
      final data = await supabaseClient
          .from(SupabaseConstants.tableProfiles)
          .update({'role': role.name})
          .eq('id', userId)
          .select()
          .single();

      return UserModelX.fromSupabase(data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> toggleUserActive({
    required String userId,
    required bool isActive,
  }) async {
    try {
      final data = await supabaseClient
          .from(SupabaseConstants.tableProfiles)
          .update({'is_active': isActive})
          .eq('id', userId)
          .select()
          .single();

      return UserModelX.fromSupabase(data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}