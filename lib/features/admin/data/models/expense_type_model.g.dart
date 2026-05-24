// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExpenseTypeModelImpl _$$ExpenseTypeModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ExpenseTypeModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdBy: json['createdBy'] as String,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$$ExpenseTypeModelImplToJson(
        _$ExpenseTypeModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'isActive': instance.isActive,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
