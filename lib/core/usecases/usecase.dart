// lib/core/usecases/usecase.dart
import 'package:fpdart/fpdart.dart';
import '../error/failures.dart';

// Every UseCase in the app implements one of these two.
// T = return type, P = params type

// UseCase WITH params (most common)
abstract class UseCase<T, P> {
  Future<Either<Failure, T>> call(P params);
}

// UseCase WITH NO params (e.g. GetCurrentUser, SignOut)
abstract class NoParamsUseCase<T> {
  Future<Either<Failure, T>> call();
}

// Convenience: use this when a UseCase has no params
class NoParams {
  const NoParams();
}