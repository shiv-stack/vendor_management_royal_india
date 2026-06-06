// lib/features/dashboard/domain/entities/expense_detail_entity.dart
import 'package:equatable/equatable.dart';

class ExpenseDetailEntity extends Equatable {
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

  const ExpenseDetailEntity({
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

  bool get isFullyPaid => outstanding <= 0;
  bool get isPartiallyPaid => totalPaid > 0 && outstanding > 0;
  bool get isUnpaid => totalPaid <= 0;

  // Net payable after advance
  double get netPayable => totalAmount - advancePaid;

  @override
  List<Object?> get props => [
        expenseRequestId,
        eventId,
        expenseType,
        vendorName,
        raisedBy,
        totalAmount,
        totalPaid,
        outstanding,
      ];
}