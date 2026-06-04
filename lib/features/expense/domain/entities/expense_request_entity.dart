// lib/features/expense/domain/entities/expense_request_entity.dart
import 'package:equatable/equatable.dart';
import '../../../../core/constants/app_constants.dart';

class ExpenseRequestEntity extends Equatable {
  final String id;
  final String eventId;
  final String expenseTypeId;
  final String vendorId;
  final String employeeId;
  final String hodId;
  final double totalAmount;
  final double advancePaid;
  final ExpensePaymentStatus paymentStatus;
  final String billAttachmentUrl;
  final ExpenseStatus status;
  final String? rejectionReason;
  final String? accountsReturnReason;
  final String? description;
  final int resubmissionCount;
  final String? createdAt;
  final String? updatedAt;

  // Joined display fields
  final String? eventName;
  final String? expenseTypeName;
  final String? vendorName;
  final String? employeeName;
  final String? hodName;

  const ExpenseRequestEntity({
    required this.id,
    required this.eventId,
    required this.expenseTypeId,
    required this.vendorId,
    required this.employeeId,
    required this.hodId,
    required this.totalAmount,
    required this.advancePaid,
    required this.paymentStatus,
    required this.billAttachmentUrl,
    required this.status,
    this.rejectionReason,
    this.accountsReturnReason,
    this.description,
    this.resubmissionCount = 0,
    this.createdAt,
    this.updatedAt,
    this.eventName,
    this.expenseTypeName,
    this.vendorName,
    this.employeeName,
    this.hodName,
  });

  // ── Business logic helpers ───────────────────────────────
  bool get isPendingHod =>
      status == ExpenseStatus.pendingHod;

  bool get isPendingAccounts =>
      status == ExpenseStatus.pendingAccounts;

  bool get isRejected =>
      status == ExpenseStatus.rejected;

  bool get isReturnedToHod =>
      status == ExpenseStatus.returnedToHod;

  bool get isPaid =>
      status == ExpenseStatus.paid;

  bool get isPartiallyPaid =>
      status == ExpenseStatus.partiallyPaid;

  bool get canResubmit => isRejected;

  bool get canBeApproved => isPendingHod || isReturnedToHod;

  double get netPayable => totalAmount - advancePaid;

  @override
  List<Object?> get props => [
        id,
        eventId,
        expenseTypeId,
        vendorId,
        employeeId,
        hodId,
        totalAmount,
        advancePaid,
        paymentStatus,
        billAttachmentUrl,
        status,
        rejectionReason,
        accountsReturnReason,
        description,
        resubmissionCount,
        createdAt,
        updatedAt,
      ];
}