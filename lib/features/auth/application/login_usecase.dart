import 'package:notes/core/error/app_exception.dart';
import 'package:notes/core/l10n/app_texts.dart';
import 'package:notes/features/auth/data/auth_repository.dart';
import 'package:notes/features/auth/domain/auth_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_usecase.g.dart';

/// ============================================================================
/// ARCHITECTURAL NOTE — When a UseCase Earns Its Keep
/// ============================================================================
/// Notice what is inside `application/`:
/// - We DO have `LoginUseCase` and `RegisterUseCase` (because authentication
///   requires input validation, normalization, password confirmation checks,
///   and post-login orchestration).
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

    if (email.isEmpty || !email.contains('@')) {
      throw ValidationException(AppTexts.invalidEmailError);
    }

    if (password.length < 6) {
      throw ValidationException(AppTexts.shortPasswordError);
    }

    return _authRepository.signInWithEmail(
      email: email,
      password: password,
    );
  }
}

class RegisterUseCase {
  final AuthRepository _authRepository;

  const RegisterUseCase(this._authRepository);

  Future<AuthUser> execute({
    required String rawDisplayName,
    required String rawEmail,
    required String password,
    required String confirmPassword,
  }) async {
    final displayName = rawDisplayName.trim();
    final email = rawEmail.trim().toLowerCase();

    if (displayName.isEmpty) {
      throw const ValidationException('Please enter your display name.');
    }

    if (email.isEmpty || !email.contains('@')) {
      throw ValidationException(AppTexts.invalidEmailError);
    }

    if (password.length < 6) {
      throw ValidationException(AppTexts.shortPasswordError);
    }

    if (password != confirmPassword) {
      throw const ValidationException('Passwords do not match.');
    }

    return _authRepository.signUpWithEmail(
      displayName: displayName,
      email: email,
      password: password,
    );
  }
}

@riverpod
LoginUseCase loginUseCase(Ref ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
RegisterUseCase registerUseCase(Ref ref) {
  return RegisterUseCase(ref.watch(authRepositoryProvider));
}
