// lib/features/expense/data/models/expense_request_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/expense_request_entity.dart';

part 'expense_request_model.freezed.dart';
part 'expense_request_model.g.dart';

@freezed
class ExpenseRequestModel with _$ExpenseRequestModel {
  const factory ExpenseRequestModel({
    required String id,
    required String eventId,
    required String expenseTypeId,
    required String vendorId,
    required String employeeId,
    required String hodId,
    required double totalAmount,
    @Default(0.0) double advancePaid,
    required String paymentStatus,
    required String billAttachmentUrl,
    required String status,
    String? rejectionReason,
    String? accountsReturnReason,
    String? description,
    @Default(0) int resubmissionCount,
    String? createdAt,
    String? updatedAt,
    // Joined fields from views (nullable)
    String? eventName,
    String? expenseTypeName,
    String? vendorName,
    String? employeeName,
    String? hodName,
  }) = _ExpenseRequestModel;

  factory ExpenseRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseRequestModelFromJson(json);
}

extension ExpenseRequestModelX on ExpenseRequestModel {
  static ExpenseRequestModel fromSupabase(Map<String, dynamic> map) {
    return ExpenseRequestModel(
      id: map['id'] as String,
      eventId: map['event_id'] as String,
      expenseTypeId: map['expense_type_id'] as String,
      vendorId: map['vendor_id'] as String,
      employeeId: map['employee_id'] as String,
      hodId: map['hod_id'] as String,
      totalAmount: (map['total_amount'] as num).toDouble(),
      advancePaid: (map['advance_paid'] as num?)?.toDouble() ?? 0.0,
      paymentStatus: map['payment_status'] as String,
      billAttachmentUrl: map['bill_attachment_url'] as String,
      status: map['status'] as String,
      rejectionReason: map['rejection_reason'] as String?,
      accountsReturnReason: map['accounts_return_reason'] as String?,
      description: map['description'] as String?,
      resubmissionCount: map['resubmission_count'] as int? ?? 0,
      createdAt: map['created_at'] as String?,
      updatedAt: map['updated_at'] as String?,
      // Joined fields
      eventName: map['event_name'] as String?,
      expenseTypeName: map['expense_type_name'] as String?,
      vendorName: map['vendor_name'] as String?,
      employeeName: map['employee_name'] as String?,
      hodName: map['hod_name'] as String?,
    );
  }

  ExpenseRequestEntity toEntity() => ExpenseRequestEntity(
        id: id,
        eventId: eventId,
        expenseTypeId: expenseTypeId,
        vendorId: vendorId,
        employeeId: employeeId,
        hodId: hodId,
        totalAmount: totalAmount,
        advancePaid: advancePaid,
        paymentStatus: ExpensePaymentStatus.fromString(paymentStatus),
        billAttachmentUrl: billAttachmentUrl,
        status: ExpenseStatus.fromString(status),
        rejectionReason: rejectionReason,
        accountsReturnReason: accountsReturnReason,
        description: description,
        resubmissionCount: resubmissionCount,
        createdAt: createdAt,
        updatedAt: updatedAt,
        eventName: eventName,
        expenseTypeName: expenseTypeName,
        vendorName: vendorName,
        employeeName: employeeName,
        hodName: hodName,
      );
}
