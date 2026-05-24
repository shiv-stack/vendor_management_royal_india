// lib/core/error/exceptions.dart

class AppAuthException implements Exception {
  final String message;
  const AppAuthException({this.message = 'Authentication failed.'});
}

class ServerException implements Exception {
  final String message;
  const ServerException({this.message = 'Server error occurred.'});
}

class CacheException implements Exception {
  final String message;
  const CacheException({this.message = 'Local cache error.'});
}

class NetworkException implements Exception {
  final String message;
  const NetworkException({this.message = 'No internet connection.'});
}

class UnauthorisedException implements Exception {
  final String message;
  const UnauthorisedException({this.message = 'You are not authorised.'});
}

class AppStorageException implements Exception {
  final String message;
  const AppStorageException({this.message = 'File upload/download failed.'});
}