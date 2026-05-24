// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExpenseRequestModelImpl _$$ExpenseRequestModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ExpenseRequestModelImpl(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      expenseTypeId: json['expenseTypeId'] as String,
      vendorId: json['vendorId'] as String,
      employeeId: json['employeeId'] as String,
      hodId: json['hodId'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      advancePaid: (json['advancePaid'] as num?)?.toDouble() ?? 0.0,
      paymentStatus: json['paymentStatus'] as String,
      billAttachmentUrl: json['billAttachmentUrl'] as String,
      status: json['status'] as String,
      rejectionReason: json['rejectionReason'] as String?,
      accountsReturnReason: json['accountsReturnReason'] as String?,
      resubmissionCount: (json['resubmissionCount'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      eventName: json['eventName'] as String?,
      expenseTypeName: json['expenseTypeName'] as String?,
      vendorName: json['vendorName'] as String?,
      employeeName: json['employeeName'] as String?,
      hodName: json['hodName'] as String?,
    );

Map<String, dynamic> _$$ExpenseRequestModelImplToJson(
        _$ExpenseRequestModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'expenseTypeId': instance.expenseTypeId,
      'vendorId': instance.vendorId,
      'employeeId': instance.employeeId,
      'hodId': instance.hodId,
      'totalAmount': instance.totalAmount,
      'advancePaid': instance.advancePaid,
      'paymentStatus': instance.paymentStatus,
      'billAttachmentUrl': instance.billAttachmentUrl,
      'status': instance.status,
      'rejectionReason': instance.rejectionReason,
      'accountsReturnReason': instance.accountsReturnReason,
      'resubmissionCount': instance.resubmissionCount,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'eventName': instance.eventName,
      'expenseTypeName': instance.expenseTypeName,
      'vendorName': instance.vendorName,
      'employeeName': instance.employeeName,
      'hodName': instance.hodName,
    };
