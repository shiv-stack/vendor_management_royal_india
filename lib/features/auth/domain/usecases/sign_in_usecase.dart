// lib/features/auth/domain/usecases/sign_in_usecase.dart
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase implements UseCase<UserEntity, SignInParams> {
  final AuthRepository repository;

  const SignInUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignInParams params) {
    // Delegate straight to repository.
    // Business validation (empty fields) is handled in BLoC/UI layer.
    return repository.signIn(
      email: params.email,
      password: params.password,
    );
  }
}

// Params class — carries inputs into the UseCase
class SignInParams extends Equatable {
  final String email;
  final String password;

  const SignInParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}