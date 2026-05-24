// lib/features/admin/domain/usecases/expense_type_usecases.dart
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/expense_type_entity.dart';
import '../repositories/admin_repository.dart';

// ── Get All Expense Types ─────────────────────────────────────
class GetExpenseTypesUseCase
    implements NoParamsUseCase<List<ExpenseTypeEntity>> {
  final AdminRepository repository;
  const GetExpenseTypesUseCase(this.repository);

  @override
  Future<Either<Failure, List<ExpenseTypeEntity>>> call() =>
      repository.getExpenseTypes();
}

// ── Create Expense Type ───────────────────────────────────────
class CreateExpenseTypeUseCase
    implements UseCase<ExpenseTypeEntity, CreateExpenseTypeParams> {
  final AdminRepository repository;
  const CreateExpenseTypeUseCase(this.repository);

  @override
  Future<Either<Failure, ExpenseTypeEntity>> call(
          CreateExpenseTypeParams params) =>
      repository.createExpenseType(
        name: params.name,
        description: params.description,
      );
}

class CreateExpenseTypeParams extends Equatable {
  final String name;
  final String? description;

  const CreateExpenseTypeParams({
    required this.name,
    this.description,
  });

  @override
  List<Object?> get props => [name, description];
}

// ── Update Expense Type ───────────────────────────────────────
class UpdateExpenseTypeUseCase
    implements UseCase<ExpenseTypeEntity, UpdateExpenseTypeParams> {
  final AdminRepository repository;
  const UpdateExpenseTypeUseCase(this.repository);

  @override
  Future<Either<Failure, ExpenseTypeEntity>> call(
          UpdateExpenseTypeParams params) =>
      repository.updateExpenseType(
        id: params.id,
        name: params.name,
        description: params.description,
        isActive: params.isActive,
      );
}

class UpdateExpenseTypeParams extends Equatable {
  final String id;
  final String name;
  final String? description;
  final bool isActive;

  const UpdateExpenseTypeParams({
    required this.id,
    required this.name,
    this.description,
    required this.isActive,
  });

  @override
  List<Object?> get props => [id, name, description, isActive];
}

// ── Delete Expense Type ───────────────────────────────────────
class DeleteExpenseTypeUseCase implements UseCase<Unit, String> {
  final AdminRepository repository;
  const DeleteExpenseTypeUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) =>
      repository.deleteExpenseType(id);
}