// lib/features/dashboard/data/models/expense_detail_model.dart
import '../../domain/entities/expense_detail_entity.dart';

class ExpenseDetailModel {
  final String expenseRequestId;
  final String eventId;
  final String eventName;
  final String expenseType;
  final String vendorName;
  final String raisedBy;
  final double totalAmount;
  final double advancePaid;
  final String employeePaymentStatus;
  final String workflowStatus;
  final double totalPaid;
  final double outstanding;
  final String? lastPaymentMode;
  final String? createdAt;
  final String? description;

  const ExpenseDetailModel({
    required this.expenseRequestId,
    required this.eventId,
    required this.eventName,
    required this.expenseType,
    required this.vendorName,
    required this.raisedBy,
    required this.totalAmount,
    required this.advancePaid,
    required this.employeePaymentStatus,
    required this.workflowStatus,
    required this.totalPaid,
    required this.outstanding,
    this.lastPaymentMode,
    this.createdAt,
    this.description,
  });

  static ExpenseDetailModel fromSupabase(Map<String, dynamic> map) {
    return ExpenseDetailModel(
      expenseRequestId:     map['expense_request_id']      as String,
      eventId:              map['event_id']                as String,
      eventName:            map['event_name']              as String,
      expenseType:          map['expense_type']            as String,
      vendorName:           map['vendor_name']             as String,
      raisedBy:             map['raised_by']               as String,
      totalAmount:          (map['total_amount']  as num?)?.toDouble() ?? 0.0,
      advancePaid:          (map['advance_paid']  as num?)?.toDouble() ?? 0.0,
      employeePaymentStatus: map['employee_payment_status'] as String,
      workflowStatus:       map['workflow_status']          as String,
      totalPaid:            (map['total_paid']    as num?)?.toDouble() ?? 0.0,
      outstanding:          (map['outstanding']   as num?)?.toDouble() ?? 0.0,
      lastPaymentMode:      map['last_payment_mode']        as String?,
      createdAt:            map['created_at']               as String?,
      description:          map['description']              as String?,
    );
  }

  ExpenseDetailEntity toEntity() => ExpenseDetailEntity(
        expenseRequestId:     expenseRequestId,
        eventId:              eventId,
        eventName:            eventName,
        expenseType:          expenseType,
        vendorName:           vendorName,
        raisedBy:             raisedBy,
        totalAmount:          totalAmount,
        advancePaid:          advancePaid,
        employeePaymentStatus: employeePaymentStatus,
        workflowStatus:       workflowStatus,
        totalPaid:            totalPaid,
        outstanding:          outstanding,
        lastPaymentMode:      lastPaymentMode,
        createdAt:            createdAt,
        description:          description,
      );
}