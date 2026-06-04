// lib/features/expense/data/datasources/expense_remote_datasource.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/supabase_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/expense_request_model.dart';
import '../models/payment_model.dart';


// ── Abstract contract ─────────────────────────────────────────
abstract class ExpenseRemoteDataSource {
  // ── File Upload ──────────────────────────────────────────
  Future<String> uploadBillAttachment({
    File? file,
    Uint8List? fileBytes,
    required String fileExtension,
    required String expenseRequestId,
  });

  Future<String> uploadPaymentScreenshot({
    required File file,
    required String paymentId,
  });

  // ── Employee ─────────────────────────────────────────────
  Future<ExpenseRequestModel> submitExpense({
    required String eventId,
    required String expenseTypeId,
    required String vendorId,
    required String hodId,
    required double totalAmount,
    required double advancePaid,
    required String paymentStatus,
    required String billAttachmentUrl,
    String? description,
  });

  Future<ExpenseRequestModel> resubmitExpense({
    required String expenseRequestId,
    required String eventId,
    required String expenseTypeId,
    required String vendorId,
    required String hodId,
    required double totalAmount,
    required double advancePaid,
    required String paymentStatus,
    required String billAttachmentUrl,
    String? description,
  });

  Future<List<ExpenseRequestModel>> getEmployeeExpenses();

  // ── HOD / MD ─────────────────────────────────────────────
  Future<List<ExpenseRequestModel>> getAssignedExpenses();

  Future<ExpenseRequestModel> approveExpense(String expenseRequestId);

  Future<ExpenseRequestModel> rejectExpense({
    required String expenseRequestId,
    required String rejectionReason,
  });

  // ── HOD re-approve from RETURNED_TO_HOD ──────────────────
  Future<ExpenseRequestModel> reApproveExpense(String expenseRequestId);

  // ── Accounts ─────────────────────────────────────────────
  Future<List<ExpenseRequestModel>> getAccountsQueue();

  Future<ExpenseRequestModel> returnToHod({
    required String expenseRequestId,
    required String returnReason,
  });

  Future<PaymentModel> processPayment({
    required String expenseRequestId,
    required double amount,
    required String paymentType,
    required String paymentMode,
    required String screenshotUrl,
    String? remarks,
  });

  Future<List<PaymentModel>> getPaymentsForExpense(String expenseRequestId);

  // ── Shared ────────────────────────────────────────────────
  Future<List<ExpenseRequestModel>> getExpensesByStatus(List<String> statuses);

  // ── HOD list (for employee picker) ───────────────────────
  Future<List<Map<String, dynamic>>> getHodList();

  // ── MD user (for HOD expenses) ───────────────────────────
  Future<Map<String, dynamic>?> getMdUser();
}

// ── Implementation ────────────────────────────────────────────
class ExpenseRemoteDataSourceImpl implements ExpenseRemoteDataSource {
  final SupabaseClient supabaseClient;

  const ExpenseRemoteDataSourceImpl({required this.supabaseClient});

  String get _uid => supabaseClient.auth.currentUser?.id ?? '';

  // ════════════════════════════════════════════════════════════
  // FILE UPLOADS
  // ════════════════════════════════════════════════════════════

  @override
  Future<String> uploadBillAttachment({
    File? file,
    Uint8List? fileBytes,
    required String fileExtension,
    required String expenseRequestId,
  }) async {
    try {
      final path = '$_uid/$expenseRequestId/bill.$fileExtension';

      if (kIsWeb && fileBytes != null) {
        // Web: upload from bytes
        await supabaseClient.storage
            .from(SupabaseConstants.bucketBillAttachments)
            .uploadBinary(
              path,
              fileBytes,
              fileOptions: const FileOptions(upsert: true),
            );
      } else if (file != null) {
        // Mobile: upload from file
        await supabaseClient.storage
            .from(SupabaseConstants.bucketBillAttachments)
            .upload(
              path,
              file,
              fileOptions: const FileOptions(upsert: true),
            );
      } else {
        throw const AppStorageException(
            message: 'No file provided for upload.');
      }

      final url = await supabaseClient.storage
          .from(SupabaseConstants.bucketBillAttachments)
          .createSignedUrl(path, 3600);

      return url;
    } catch (e) {
      throw AppStorageException(message: e.toString());
    }
  }

  @override
  Future<String> uploadPaymentScreenshot({
    required File file,
    required String paymentId,
  }) async {
    try {
      final ext = file.path.split('.').last;
      final path = '$_uid/$paymentId/screenshot.$ext';

      await supabaseClient.storage
          .from(SupabaseConstants.bucketPaymentScreenshots)
          .upload(path, file, fileOptions: const FileOptions(upsert: true));

      final url = supabaseClient.storage
          .from(SupabaseConstants.bucketPaymentScreenshots)
          .getPublicUrl(path);

      return url;
    } catch (e) {
      throw AppStorageException(message: e.toString());
    }
  }

  // ════════════════════════════════════════════════════════════
  // EMPLOYEE
  // ════════════════════════════════════════════════════════════

  @override
  Future<ExpenseRequestModel> submitExpense({
    required String eventId,
    required String expenseTypeId,
    required String vendorId,
    required String hodId,
    required double totalAmount,
    required double advancePaid,
    required String paymentStatus,
    required String billAttachmentUrl,
    String? description,
  }) async {
    try {
      final data = await supabaseClient
          .from(SupabaseConstants.tableExpenseRequests)
          .insert({
            'event_id': eventId,
            'expense_type_id': expenseTypeId,
            'vendor_id': vendorId,
            'employee_id': _uid,
            'hod_id': hodId,
            'total_amount': totalAmount,
            'advance_paid': advancePaid,
            'payment_status': paymentStatus,
            'bill_attachment_url': billAttachmentUrl,
            'description': description,
            'status': 'PENDING_HOD',
          })
          .select()
          .single();

      return ExpenseRequestModelX.fromSupabase(data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ExpenseRequestModel> resubmitExpense({
    required String expenseRequestId,
    required String eventId,
    required String expenseTypeId,
    required String vendorId,
    required String hodId,
    required double totalAmount,
    required double advancePaid,
    required String paymentStatus,
    required String billAttachmentUrl,
    String? description,
  }) async {
    try {
      // Get current resubmission count first
      final current = await supabaseClient
          .from(SupabaseConstants.tableExpenseRequests)
          .select('resubmission_count')
          .eq('id', expenseRequestId)
          .single();

      final count = (current['resubmission_count'] as int? ?? 0) + 1;

      final data = await supabaseClient
          .from(SupabaseConstants.tableExpenseRequests)
          .update({
            'event_id': eventId,
            'expense_type_id': expenseTypeId,
            'vendor_id': vendorId,
            'hod_id': hodId,
            'total_amount': totalAmount,
            'advance_paid': advancePaid,
            'payment_status': paymentStatus,
            'bill_attachment_url': billAttachmentUrl,
            'description': description,
            'status': 'PENDING_HOD',
            'rejection_reason': null,
            'resubmission_count': count,
          })
          .eq('id', expenseRequestId)
          .eq('employee_id', _uid)
          .select()
          .single();

      return ExpenseRequestModelX.fromSupabase(data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ExpenseRequestModel>> getEmployeeExpenses() async {
    try {
      final data = await supabaseClient
          .from(SupabaseConstants.tableExpenseRequests)
          .select('''
            *,
            events!event_id(name),
            expense_types!expense_type_id(name),
            vendors!vendor_id(name),
            hod:profiles!hod_id(full_name)
          ''')
          .eq('employee_id', _uid)
          .order('created_at', ascending: false);

      return (data as List).map((e) {
        // Flatten joined fields
        final map = Map<String, dynamic>.from(e);
        map['event_name'] = (e['events'] as Map?)?['name'];
        map['expense_type_name'] = (e['expense_types'] as Map?)?['name'];
        map['vendor_name'] = (e['vendors'] as Map?)?['name'];
        map['hod_name'] = (e['hod'] as Map?)?['full_name'];
        return ExpenseRequestModelX.fromSupabase(map);
      }).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  // ════════════════════════════════════════════════════════════
  // HOD / MD
  // ════════════════════════════════════════════════════════════

  @override
  Future<List<ExpenseRequestModel>> getAssignedExpenses() async {
    try {
      final data = await supabaseClient
          .from(SupabaseConstants.tableExpenseRequests)
          .select('''
            *,
            events!event_id(name),
            expense_types!expense_type_id(name),
            vendors!vendor_id(name),
            employee:profiles!employee_id(full_name)
          ''')
          .eq('hod_id', _uid)
          .inFilter('status', ['PENDING_HOD', 'RETURNED_TO_HOD'])
          .order('created_at', ascending: false);

      return (data as List).map((e) {
        final map = Map<String, dynamic>.from(e);
        map['event_name'] = (e['events'] as Map?)?['name'];
        map['expense_type_name'] = (e['expense_types'] as Map?)?['name'];
        map['vendor_name'] = (e['vendors'] as Map?)?['name'];
        map['employee_name'] = (e['employee'] as Map?)?['full_name'];
        return ExpenseRequestModelX.fromSupabase(map);
      }).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ExpenseRequestModel> approveExpense(String expenseRequestId) async {
    try {
      final data = await supabaseClient
          .from(SupabaseConstants.tableExpenseRequests)
          .update({'status': 'PENDING_ACCOUNTS'})
          .eq('id', expenseRequestId)
          .eq('hod_id', _uid)
          .select()
          .single();

      return ExpenseRequestModelX.fromSupabase(data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ExpenseRequestModel> rejectExpense({
    required String expenseRequestId,
    required String rejectionReason,
  }) async {
    try {
      final data = await supabaseClient
          .from(SupabaseConstants.tableExpenseRequests)
          .update({
            'status': 'REJECTED',
            'rejection_reason': rejectionReason,
          })
          .eq('id', expenseRequestId)
          .eq('hod_id', _uid)
          .select()
          .single();

      return ExpenseRequestModelX.fromSupabase(data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ExpenseRequestModel> reApproveExpense(String expenseRequestId) async {
    try {
      final data = await supabaseClient
          .from(SupabaseConstants.tableExpenseRequests)
          .update({
            'status': 'PENDING_ACCOUNTS',
            'accounts_return_reason': null,
          })
          .eq('id', expenseRequestId)
          .eq('hod_id', _uid)
          .select()
          .single();

      return ExpenseRequestModelX.fromSupabase(data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  // ════════════════════════════════════════════════════════════
  // ACCOUNTS
  // ════════════════════════════════════════════════════════════

  @override
  Future<List<ExpenseRequestModel>> getAccountsQueue() async {
    try {
      final data = await supabaseClient
          .from(SupabaseConstants.tableExpenseRequests)
          .select('''
            *,
            events!event_id(name),
            expense_types!expense_type_id(name),
            vendors!vendor_id(name),
            employee:profiles!employee_id(full_name),
            hod:profiles!hod_id(full_name)
          ''').inFilter('status', [
        'PENDING_ACCOUNTS',
        'RETURNED_TO_HOD',
        'PARTIALLY_PAID',
      ]).order('created_at', ascending: false);

      return (data as List).map((e) {
        final map = Map<String, dynamic>.from(e);
        map['event_name'] = (e['events'] as Map?)?['name'];
        map['expense_type_name'] = (e['expense_types'] as Map?)?['name'];
        map['vendor_name'] = (e['vendors'] as Map?)?['name'];
        map['employee_name'] = (e['employee'] as Map?)?['full_name'];
        map['hod_name'] = (e['hod'] as Map?)?['full_name'];
        return ExpenseRequestModelX.fromSupabase(map);
      }).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ExpenseRequestModel> returnToHod({
    required String expenseRequestId,
    required String returnReason,
  }) async {
    try {
      final data = await supabaseClient
          .from(SupabaseConstants.tableExpenseRequests)
          .update({
            'status': 'RETURNED_TO_HOD',
            'accounts_return_reason': returnReason,
          })
          .eq('id', expenseRequestId)
          .select()
          .single();

      return ExpenseRequestModelX.fromSupabase(data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<PaymentModel> processPayment({
    required String expenseRequestId,
    required double amount,
    required String paymentType,
    required String paymentMode,
    required String screenshotUrl,
    String? remarks,
  }) async {
    try {
      final data = await supabaseClient
          .from(SupabaseConstants.tablePayments)
          .insert({
            'expense_request_id': expenseRequestId,
            'processed_by': _uid,
            'amount': amount,
            'payment_type': paymentType,
            'payment_mode': paymentMode,
            'screenshot_url': screenshotUrl,
            'remarks': remarks,
          })
          .select()
          .single();

      return PaymentModelX.fromSupabase(data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<PaymentModel>> getPaymentsForExpense(
      String expenseRequestId) async {
    try {
      final data = await supabaseClient
          .from(SupabaseConstants.tablePayments)
          .select('''
            *,
            processor:profiles!processed_by(full_name)
          ''')
          .eq('expense_request_id', expenseRequestId)
          .order('created_at', ascending: false);

      return (data as List).map((e) {
        final map = Map<String, dynamic>.from(e);
        map['processed_by_name'] = (e['processor'] as Map?)?['full_name'];
        return PaymentModelX.fromSupabase(map);
      }).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ExpenseRequestModel>> getExpensesByStatus(
      List<String> statuses) async {
    try {
      final data = await supabaseClient
          .from(SupabaseConstants.tableExpenseRequests)
          .select('''
            *,
            events!event_id(name),
            expense_types!expense_type_id(name),
            vendors!vendor_id(name),
            employee:profiles!employee_id(full_name),
            hod:profiles!hod_id(full_name)
          ''')
          .inFilter('status', statuses)
          .order('created_at', ascending: false);

      return (data as List).map((e) {
        final map = Map<String, dynamic>.from(e);
        map['event_name'] = (e['events'] as Map?)?['name'];
        map['expense_type_name'] = (e['expense_types'] as Map?)?['name'];
        map['vendor_name'] = (e['vendors'] as Map?)?['name'];
        map['employee_name'] = (e['employee'] as Map?)?['full_name'];
        map['hod_name'] = (e['hod'] as Map?)?['full_name'];
        return ExpenseRequestModelX.fromSupabase(map);
      }).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  // ════════════════════════════════════════════════════════════
  // SHARED HELPERS
  // ════════════════════════════════════════════════════════════

  @override
  Future<List<Map<String, dynamic>>> getHodList() async {
    try {
      final data = await supabaseClient
          .from(SupabaseConstants.tableProfiles)
          .select('id, full_name, role')
          .eq('role', 'hod')
          .eq('is_active', true)
          .order('full_name');

      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>?> getMdUser() async {
    try {
      final data = await supabaseClient
          .from(SupabaseConstants.tableProfiles)
          .select('id, full_name, role')
          .eq('role', 'md')
          .eq('is_active', true)
          .maybeSingle();

      return data;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
