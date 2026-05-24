// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentModelImpl _$$PaymentModelImplFromJson(Map<String, dynamic> json) =>
    _$PaymentModelImpl(
      id: json['id'] as String,
      expenseRequestId: json['expenseRequestId'] as String,
      processedBy: json['processedBy'] as String,
      amount: (json['amount'] as num).toDouble(),
      paymentType: json['paymentType'] as String,
      paymentMode: json['paymentMode'] as String,
      screenshotUrl: json['screenshotUrl'] as String,
      remarks: json['remarks'] as String?,
      createdAt: json['createdAt'] as String?,
      processedByName: json['processedByName'] as String?,
    );

Map<String, dynamic> _$$PaymentModelImplToJson(_$PaymentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'expenseRequestId': instance.expenseRequestId,
      'processedBy': instance.processedBy,
      'amount': instance.amount,
      'paymentType': instance.paymentType,
      'paymentMode': instance.paymentMode,
      'screenshotUrl': instance.screenshotUrl,
      'remarks': instance.remarks,
      'createdAt': instance.createdAt,
      'processedByName': instance.processedByName,
    };
