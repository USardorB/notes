import 'package:notes/core/error/app_exception.dart';
import 'package:notes/features/auth/data/auth_repository.dart';
import 'package:notes/features/auth/domain/auth_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_usecase.g.dart';

/// ============================================================================
/// ARCHITECTURAL NOTE — When a UseCase Earns Its Keep
/// ============================================================================
/// Notice what is inside `application/`:
/// - We DO have `LoginUseCase` (because login requires input validation,
///   normalization, and post-login orchestration).
/// - We DO NOT have `WatchCurrentUserUseCase` (because watching the user stream
///   has zero business rules—it would be a 1-line pass-through!).
///
/// Notice also that this file imports ZERO Flutter UI packages (`material.dart`).
/// It is 100% pure Dart business rules.
class LoginUseCase {
  final AuthRepository _authRepository;

  const LoginUseCase(this._authRepository);

  Future<AuthUser> execute({
    required String rawEmail,
    required String password,
  }) async {
    final email = rawEmail.trim().toLowerCase();

    // 1. Domain Validation Rules
    if (email.isEmpty || !email.contains('@')) {
      throw const ValidationException('Please enter a valid email address.');
    }

    if (password.length < 6) {
      throw const ValidationException(
        'Password must be at least 6 characters long.',
      );
    }

    // 2. Execute authentication & local Drift session persistence
    final user = await _authRepository.signInWithEmail(
      email: email,
      password: password,
    );

    return user;
  }
}

@riverpod
LoginUseCase loginUseCase(Ref ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
}

