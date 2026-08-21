// lib/features/auth/domain/repositories/auth_repository.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

// Abstract contract — domain layer only knows this interface.
// Actual implementation lives in data layer (auth_repository_impl.dart).
// This is what gets registered in get_it and injected into UseCases.

abstract class AuthRepository {
  /// Sign in using Employee ID (e.g. RIV001) + password.
  /// Internally resolves the linked email and authenticates with Supabase.
  Future<Either<Failure, UserEntity>> signIn({
    required String employeeId,
    required String password,
  });

  Future<Either<Failure, Unit>> signOut();

  Future<Either<Failure, UserEntity>> getCurrentUser();

  Future<Either<Failure, Unit>> updateFcmToken(String token);
}