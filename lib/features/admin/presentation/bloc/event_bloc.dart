// lib/features/admin/presentation/bloc/event_bloc.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/usecases/event_usecases.dart';

// ── Events ────────────────────────────────────────────────────
abstract class EventEvent extends Equatable {
  const EventEvent();
  @override
  List<Object?> get props => [];
}

class EventLoadAll extends EventEvent {
  const EventLoadAll();
}

class EventCreate extends EventEvent {
  final String name;
  final String? description;
  const EventCreate({required this.name, this.description});
  @override
  List<Object?> get props => [name, description];
}

class EventUpdate extends EventEvent {
  final String id;
  final String name;
  final String? description;
  final bool isActive;
  const EventUpdate({
    required this.id,
    required this.name,
    this.description,
    required this.isActive,
  });
  @override
  List<Object?> get props => [id, name, description, isActive];
}

class EventDelete extends EventEvent {
  final String id;
  const EventDelete({required this.id});
  @override
  List<Object?> get props => [id];
}

// ── States ────────────────────────────────────────────────────
abstract class EventState extends Equatable {
  const EventState();
  @override
  List<Object?> get props => [];
}

class EventInitial extends EventState {
  const EventInitial();
}

class EventLoading extends EventState {
  const EventLoading();
}

class EventLoaded extends EventState {
  final List<EventEntity> events;
  const EventLoaded({required this.events});
  @override
  List<Object?> get props => [events];
}

class EventActionSuccess extends EventState {
  final String message;
  final List<EventEntity> events;
  const EventActionSuccess({
    required this.message,
    required this.events,
  });
  @override
  List<Object?> get props => [message, events];
}

class EventFailure extends EventState {
  final String message;
  const EventFailure({required this.message});
  @override
  List<Object?> get props => [message];
}

// ── BLoC ──────────────────────────────────────────────────────
class EventBloc extends Bloc<EventEvent, EventState> {
  final GetEventsUseCase getEvents;
  final CreateEventUseCase createEvent;
  final UpdateEventUseCase updateEvent;
  final DeleteEventUseCase deleteEvent;

  EventBloc({
    required this.getEvents,
    required this.createEvent,
    required this.updateEvent,
    required this.deleteEvent,
  }) : super(const EventInitial()) {
    on<EventLoadAll>(_onLoadAll);
    on<EventCreate>(_onCreate);
    on<EventUpdate>(_onUpdate);
    on<EventDelete>(_onDelete);
  }

  Future<void> _onLoadAll(
    EventLoadAll event,
    Emitter<EventState> emit,
  ) async {
    emit(const EventLoading());
    final result = await getEvents();
    result.fold(
      (f) => emit(EventFailure(message: f.message)),
      (events) => emit(EventLoaded(events: events)),
    );
  }

  Future<void> _onCreate(
    EventCreate event,
    Emitter<EventState> emit,
  ) async {
    emit(const EventLoading());
    final result = await createEvent(
      CreateEventParams(
        name: event.name,
        description: event.description,
      ),
    );
    await result.fold(
      (f) async => emit(EventFailure(message: f.message)),
      (_) async {
        // Reload full list after create
        final listResult = await getEvents();
        listResult.fold(
          (f) => emit(EventFailure(message: f.message)),
          (events) => emit(EventActionSuccess(
              message: 'Event created successfully.',
              events: events)),
        );
      },
    );
  }

  Future<void> _onUpdate(
    EventUpdate event,
    Emitter<EventState> emit,
  ) async {
    emit(const EventLoading());
    final result = await updateEvent(
      UpdateEventParams(
        id: event.id,
        name: event.name,
        description: event.description,
        isActive: event.isActive,
      ),
    );
    await result.fold(
      (f) async => emit(EventFailure(message: f.message)),
      (_) async {
        final listResult = await getEvents();
        listResult.fold(
          (f) => emit(EventFailure(message: f.message)),
          (events) => emit(EventActionSuccess(
              message: 'Event updated successfully.',
              events: events)),
        );
      },
    );
  }

  Future<void> _onDelete(
    EventDelete event,
    Emitter<EventState> emit,
  ) async {
    emit(const EventLoading());
    final result = await deleteEvent(event.id);
    await result.fold(
      (f) async => emit(EventFailure(message: f.message)),
      (_) async {
        final listResult = await getEvents();
        listResult.fold(
          (f) => emit(EventFailure(message: f.message)),
          (events) => emit(EventActionSuccess(
              message: 'Event deleted successfully.',
              events: events)),
        );
      },
    );
  }
}