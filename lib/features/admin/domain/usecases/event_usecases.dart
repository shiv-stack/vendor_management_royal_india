// lib/features/admin/domain/usecases/event_usecases.dart
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/event_entity.dart';
import '../repositories/admin_repository.dart';

// ── Get All Events ────────────────────────────────────────────
class GetEventsUseCase implements NoParamsUseCase<List<EventEntity>> {
  final AdminRepository repository;
  const GetEventsUseCase(this.repository);

  @override
  Future<Either<Failure, List<EventEntity>>> call() =>
      repository.getEvents();
}

// ── Create Event ──────────────────────────────────────────────
class CreateEventUseCase implements UseCase<EventEntity, CreateEventParams> {
  final AdminRepository repository;
  const CreateEventUseCase(this.repository);

  @override
  Future<Either<Failure, EventEntity>> call(CreateEventParams params) =>
      repository.createEvent(
        name: params.name,
        description: params.description,
      );
}

class CreateEventParams extends Equatable {
  final String name;
  final String? description;

  const CreateEventParams({
    required this.name,
    this.description,
  });

  @override
  List<Object?> get props => [name, description];
}

// ── Update Event ──────────────────────────────────────────────
class UpdateEventUseCase implements UseCase<EventEntity, UpdateEventParams> {
  final AdminRepository repository;
  const UpdateEventUseCase(this.repository);

  @override
  Future<Either<Failure, EventEntity>> call(UpdateEventParams params) =>
      repository.updateEvent(
        id: params.id,
        name: params.name,
        description: params.description,
        isActive: params.isActive,
      );
}

class UpdateEventParams extends Equatable {
  final String id;
  final String name;
  final String? description;
  final bool isActive;

  const UpdateEventParams({
    required this.id,
    required this.name,
    this.description,
    required this.isActive,
  });

  @override
  List<Object?> get props => [id, name, description, isActive];
}

// ── Delete Event ──────────────────────────────────────────────
class DeleteEventUseCase implements UseCase<Unit, String> {
  final AdminRepository repository;
  const DeleteEventUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) =>
      repository.deleteEvent(id);
}