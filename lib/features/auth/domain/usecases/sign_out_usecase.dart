// lib/features/auth/domain/usecases/sign_out_usecase.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class SignOutUseCase implements NoParamsUseCase<Unit> {
  final AuthRepository repository;

  const SignOutUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call() {
    return repository.signOut();
  }
}