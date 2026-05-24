// lib/features/auth/domain/usecases/get_current_user_usecase.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

// Called on app startup to restore session.
// If Supabase session exists → returns UserEntity with role.
// Router guard uses this to redirect to correct home screen.

class GetCurrentUserUseCase implements NoParamsUseCase<UserEntity> {
  final AuthRepository repository;

  const GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call() {
    return repository.getCurrentUser();
  }
}