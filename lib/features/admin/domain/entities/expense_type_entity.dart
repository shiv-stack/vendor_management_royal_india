// lib/features/admin/domain/entities/expense_type_entity.dart
import 'package:equatable/equatable.dart';

class ExpenseTypeEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final bool isActive;
  final String createdBy;
  final String? createdAt;
  final String? updatedAt;

  const ExpenseTypeEntity({
    required this.id,
    required this.name,
    this.description,
    this.isActive = true,
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        isActive,
        createdBy,
        createdAt,
        updatedAt,
      ];
}