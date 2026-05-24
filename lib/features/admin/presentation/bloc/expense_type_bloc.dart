// lib/features/admin/presentation/bloc/expense_type_bloc.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/expense_type_entity.dart';
import '../../domain/usecases/expense_type_usecases.dart';

// ── Events ────────────────────────────────────────────────────
abstract class ExpenseTypeEvent extends Equatable {
  const ExpenseTypeEvent();
  @override
  List<Object?> get props => [];
}

class ExpenseTypeLoadAll extends ExpenseTypeEvent {
  const ExpenseTypeLoadAll();
}

class ExpenseTypeCreate extends ExpenseTypeEvent {
  final String name;
  final String? description;
  const ExpenseTypeCreate({required this.name, this.description});
  @override
  List<Object?> get props => [name, description];
}

class ExpenseTypeUpdate extends ExpenseTypeEvent {
  final String id;
  final String name;
  final String? description;
  final bool isActive;
  const ExpenseTypeUpdate({
    required this.id,
    required this.name,
    this.description,
    required this.isActive,
  });
  @override
  List<Object?> get props => [id, name, description, isActive];
}

class ExpenseTypeDelete extends ExpenseTypeEvent {
  final String id;
  const ExpenseTypeDelete({required this.id});
  @override
  List<Object?> get props => [id];
}

// ── States ────────────────────────────────────────────────────
abstract class ExpenseTypeState extends Equatable {
  const ExpenseTypeState();
  @override
  List<Object?> get props => [];
}

class ExpenseTypeInitial extends ExpenseTypeState {
  const ExpenseTypeInitial();
}

class ExpenseTypeLoading extends ExpenseTypeState {
  const ExpenseTypeLoading();
}

class ExpenseTypeLoaded extends ExpenseTypeState {
  final List<ExpenseTypeEntity> expenseTypes;
  const ExpenseTypeLoaded({required this.expenseTypes});
  @override
  List<Object?> get props => [expenseTypes];
}

class ExpenseTypeActionSuccess extends ExpenseTypeState {
  final String message;
  final List<ExpenseTypeEntity> expenseTypes;
  const ExpenseTypeActionSuccess({
    required this.message,
    required this.expenseTypes,
  });
  @override
  List<Object?> get props => [message, expenseTypes];
}

class ExpenseTypeFailure extends ExpenseTypeState {
  final String message;
  const ExpenseTypeFailure({required this.message});
  @override
  List<Object?> get props => [message];
}

// ── BLoC ──────────────────────────────────────────────────────
class ExpenseTypeBloc extends Bloc<ExpenseTypeEvent, ExpenseTypeState> {
  final GetExpenseTypesUseCase getExpenseTypes;
  final CreateExpenseTypeUseCase createExpenseType;
  final UpdateExpenseTypeUseCase updateExpenseType;
  final DeleteExpenseTypeUseCase deleteExpenseType;

  ExpenseTypeBloc({
    required this.getExpenseTypes,
    required this.createExpenseType,
    required this.updateExpenseType,
    required this.deleteExpenseType,
  }) : super(const ExpenseTypeInitial()) {
    on<ExpenseTypeLoadAll>(_onLoadAll);
    on<ExpenseTypeCreate>(_onCreate);
    on<ExpenseTypeUpdate>(_onUpdate);
    on<ExpenseTypeDelete>(_onDelete);
  }

  Future<void> _onLoadAll(
    ExpenseTypeLoadAll event,
    Emitter<ExpenseTypeState> emit,
  ) async {
    emit(const ExpenseTypeLoading());
    final result = await getExpenseTypes();
    result.fold(
      (f) => emit(ExpenseTypeFailure(message: f.message)),
      (types) => emit(ExpenseTypeLoaded(expenseTypes: types)),
    );
  }

  Future<void> _onCreate(
    ExpenseTypeCreate event,
    Emitter<ExpenseTypeState> emit,
  ) async {
    emit(const ExpenseTypeLoading());
    final result = await createExpenseType(
      CreateExpenseTypeParams(
        name: event.name,
        description: event.description,
      ),
    );
    await result.fold(
      (f) async => emit(ExpenseTypeFailure(message: f.message)),
      (_) async {
        final listResult = await getExpenseTypes();
        listResult.fold(
          (f) => emit(ExpenseTypeFailure(message: f.message)),
          (types) => emit(ExpenseTypeActionSuccess(
              message: 'Expense type created successfully.',
              expenseTypes: types)),
        );
      },
    );
  }

  Future<void> _onUpdate(
    ExpenseTypeUpdate event,
    Emitter<ExpenseTypeState> emit,
  ) async {
    emit(const ExpenseTypeLoading());
    final result = await updateExpenseType(
      UpdateExpenseTypeParams(
        id: event.id,
        name: event.name,
        description: event.description,
        isActive: event.isActive,
      ),
    );
    await result.fold(
      (f) async => emit(ExpenseTypeFailure(message: f.message)),
      (_) async {
        final listResult = await getExpenseTypes();
        listResult.fold(
          (f) => emit(ExpenseTypeFailure(message: f.message)),
          (types) => emit(ExpenseTypeActionSuccess(
              message: 'Expense type updated successfully.',
              expenseTypes: types)),
        );
      },
    );
  }

  Future<void> _onDelete(
    ExpenseTypeDelete event,
    Emitter<ExpenseTypeState> emit,
  ) async {
    emit(const ExpenseTypeLoading());
    final result = await deleteExpenseType(event.id);
    await result.fold(
      (f) async => emit(ExpenseTypeFailure(message: f.message)),
      (_) async {
        final listResult = await getExpenseTypes();
        listResult.fold(
          (f) => emit(ExpenseTypeFailure(message: f.message)),
          (types) => emit(ExpenseTypeActionSuccess(
              message: 'Expense type deleted successfully.',
              expenseTypes: types)),
        );
      },
    );
  }
}