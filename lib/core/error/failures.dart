// lib/core/error/failures.dart

// Sealed class — every possible failure in the app.
// fpdart Either<Failure, T> will return one of these on error.

abstract class Failure {
  final String message;
  const Failure({required this.message});
}

class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server error occurred.'});
}

class AuthFailure extends Failure {
  const AuthFailure({super.message = 'Authentication failed.'});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection.'});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Local cache error.'});
}

class UnauthorisedFailure extends Failure {
  const UnauthorisedFailure({super.message = 'You are not authorised.'});
}

class StorageFailure extends Failure {
  const StorageFailure({super.message = 'File upload/download failed.'});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message = 'Record not found.'});
}