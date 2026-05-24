// lib/features/expense/domain/entities/payment_entity.dart
import 'package:equatable/equatable.dart';
import '../../../../core/constants/app_constants.dart';

class PaymentEntity extends Equatable {
  final String id;
  final String expenseRequestId;
  final String processedBy;
  final double amount;
  final PaymentType paymentType;
  final PaymentMode paymentMode;
  final String screenshotUrl;
  final String? remarks;
  final String? createdAt;
  final String? processedByName;

  const PaymentEntity({
    required this.id,
    required this.expenseRequestId,
    required this.processedBy,
    required this.amount,
    required this.paymentType,
    required this.paymentMode,
    required this.screenshotUrl,
    this.remarks,
    this.createdAt,
    this.processedByName,
  });

  @override
  List<Object?> get props => [
        id,
        expenseRequestId,
        processedBy,
        amount,
        paymentType,
        paymentMode,
        screenshotUrl,
        remarks,
        createdAt,
      ];
}