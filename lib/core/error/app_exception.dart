/// ============================================================================
/// ARCHITECTURAL NOTE — Error Handling (Dart 3 Sealed Classes vs Dartz Either)
/// ============================================================================
/// In classic Uncle Bob + Bloc tutorials, every repository method returns
/// `Future<Either<Failure, T>>` using the `dartz` or `fpdart` package.
///
/// WHY THAT BECOMES OVER-ENGINEERING IN RIVERPOD:
/// Riverpod's `AsyncValue<T>` (`AsyncData`, `AsyncLoading`, `AsyncError`) is
/// ALREADY a built-in functional union type! Wrapping `Either` inside
/// `AsyncValue<Either<Failure, T>>` creates a double-nested union that forces
/// you to `.fold()` inside `.when()`.
///
///Instead, we use Dart 3's native `sealed class AppException` and let
/// `AsyncValue.guard(() => ...)` catch and expose typed errors cleanly to UI.
library;

sealed class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

/// Thrown by UseCases when domain/business validation fails before hitting DB/API.
final class ValidationException extends AppException {
  const ValidationException(super.message);
}

/// Thrown when authentication credentials or sessions are invalid or expired.
final class UnauthorizedException extends AppException {
  const UnauthorizedException([
    super.message = 'Your session has expired. Please sign in again.',
  ]);
}

/// Thrown when a remote network call fails (offline, timeout, 5xx).
final class NetworkException extends AppException {
  final int? statusCode;
  const NetworkException(super.message, {this.statusCode});
}

/// Thrown when a local Drift SQLite operation fails.
final class DatabaseException extends AppException {
  const DatabaseException(super.message);
}

