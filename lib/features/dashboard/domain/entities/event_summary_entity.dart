// lib/features/dashboard/domain/entities/event_summary_entity.dart
import 'package:equatable/equatable.dart';

class EventSummaryEntity extends Equatable {
  final String eventId;
  final String eventName;
  final double totalIncurred;
  final double totalPaid;
  final double outstanding;

  const EventSummaryEntity({
    required this.eventId,
    required this.eventName,
    required this.totalIncurred,
    required this.totalPaid,
    required this.outstanding,
  });

  // Is this event fully paid?
  bool get isFullyPaid => outstanding <= 0;

  // Is this event partially paid?
  bool get isPartiallyPaid => totalPaid > 0 && outstanding > 0;

  // Is this event unpaid?
  bool get isUnpaid => totalPaid <= 0;

  @override
  List<Object?> get props => [
        eventId,
        eventName,
        totalIncurred,
        totalPaid,
        outstanding,
      ];
}