// lib/features/dashboard/data/models/event_summary_model.dart


import 'package:vpms_royal_india/features/dashboard/domain/entities/event_summary_entity.dart';

class EventSummaryModel {
  final String eventId;
  final String eventName;
  final double totalIncurred;
  final double totalPaid;
  final double outstanding;

  const EventSummaryModel({
    required this.eventId,
    required this.eventName,
    required this.totalIncurred,
    required this.totalPaid,
    required this.outstanding,
  });

  static EventSummaryModel fromSupabase(Map<String, dynamic> map) {
    return EventSummaryModel(
      eventId:       map['event_id']      as String,
      eventName:     map['event_name']    as String,
      totalIncurred: (map['total_incurred'] as num?)?.toDouble() ?? 0.0,
      totalPaid:     (map['total_paid']     as num?)?.toDouble() ?? 0.0,
      outstanding:   (map['outstanding']    as num?)?.toDouble() ?? 0.0,
    );
  }

  EventSummaryEntity toEntity() => EventSummaryEntity(
        eventId:       eventId,
        eventName:     eventName,
        totalIncurred: totalIncurred,
        totalPaid:     totalPaid,
        outstanding:   outstanding,
      );
}