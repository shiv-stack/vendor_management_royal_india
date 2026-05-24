// lib/features/admin/domain/entities/event_entity.dart
import 'package:equatable/equatable.dart';

class EventEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final bool isActive;
  final String createdBy;
  final String? createdAt;
  final String? updatedAt;

  const EventEntity({
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