// lib/features/expense/data/models/payment_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/payment_entity.dart';

part 'payment_model.freezed.dart';
part 'payment_model.g.dart';

@freezed
class PaymentModel with _$PaymentModel {
  const factory PaymentModel({
    required String id,
    required String expenseRequestId,
    required String processedBy,
    required double amount,
    required String paymentType,
    required String paymentMode,
    required String screenshotUrl,
    String? remarks,
    String? createdAt,
    // Joined
    String? processedByName,
  }) = _PaymentModel;

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);
}

extension PaymentModelX on PaymentModel {
  static PaymentModel fromSupabase(Map<String, dynamic> map) {
    return PaymentModel(
      id:                map['id']                  as String,
      expenseRequestId:  map['expense_request_id']  as String,
      processedBy:       map['processed_by']        as String,
      amount:            (map['amount'] as num).toDouble(),
      paymentType:       map['payment_type']        as String,
      paymentMode:       map['payment_mode']        as String,
      screenshotUrl:     map['screenshot_url']      as String,
      remarks:           map['remarks']             as String?,
      createdAt:         map['created_at']          as String?,
      processedByName:   map['processed_by_name']   as String?,
    );
  }

  PaymentEntity toEntity() => PaymentEntity(
        id:               id,
        expenseRequestId: expenseRequestId,
        processedBy:      processedBy,
        amount:           amount,
        paymentType:      PaymentType.fromString(paymentType),
        paymentMode:      PaymentMode.fromString(paymentMode),
        screenshotUrl:    screenshotUrl,
        remarks:          remarks,
        createdAt:        createdAt,
        processedByName:  processedByName,
      );
}