// lib/features/admin/data/models/expense_type_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/expense_type_entity.dart';

part 'expense_type_model.freezed.dart';
part 'expense_type_model.g.dart';

@freezed
class ExpenseTypeModel with _$ExpenseTypeModel {
  const factory ExpenseTypeModel({
    required String id,
    required String name,
    String? description,
    @Default(true) bool isActive,
    required String createdBy,
    String? createdAt,
    String? updatedAt,
  }) = _ExpenseTypeModel;

  factory ExpenseTypeModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseTypeModelFromJson(json);
}

extension ExpenseTypeModelX on ExpenseTypeModel {
  static ExpenseTypeModel fromSupabase(Map<String, dynamic> map) {
    return ExpenseTypeModel(
      id:          map['id']          as String,
      name:        map['name']        as String,
      description: map['description'] as String?,
      isActive:    map['is_active']   as bool? ?? true,
      createdBy:   map['created_by']  as String,
      createdAt:   map['created_at']  as String?,
      updatedAt:   map['updated_at']  as String?,
    );
  }

  ExpenseTypeEntity toEntity() => ExpenseTypeEntity(
        id:          id,
        name:        name,
        description: description,
        isActive:    isActive,
        createdBy:   createdBy,
        createdAt:   createdAt,
        updatedAt:   updatedAt,
      );
}