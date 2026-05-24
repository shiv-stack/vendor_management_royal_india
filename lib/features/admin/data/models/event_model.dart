// lib/features/admin/data/models/event_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/event_entity.dart';

part 'event_model.freezed.dart';
part 'event_model.g.dart';

@freezed
class EventModel with _$EventModel {
  const factory EventModel({
    required String id,
    required String name,
    String? description,
    @Default(true) bool isActive,
    required String createdBy,
    String? createdAt,
    String? updatedAt,
  }) = _EventModel;

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);
}

extension EventModelX on EventModel {
  static EventModel fromSupabase(Map<String, dynamic> map) {
    return EventModel(
      id:          map['id']          as String,
      name:        map['name']        as String,
      description: map['description'] as String?,
      isActive:    map['is_active']   as bool? ?? true,
      createdBy:   map['created_by']  as String,
      createdAt:   map['created_at']  as String?,
      updatedAt:   map['updated_at']  as String?,
    );
  }

  EventEntity toEntity() => EventEntity(
        id:          id,
        name:        name,
        description: description,
        isActive:    isActive,
        createdBy:   createdBy,
        createdAt:   createdAt,
        updatedAt:   updatedAt,
      );
}