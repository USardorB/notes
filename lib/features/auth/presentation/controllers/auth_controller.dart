import 'package:notes/core/error/app_exception.dart';
import 'package:notes/features/auth/application/login_usecase.dart';
import 'package:notes/features/auth/data/auth_repository.dart';
import 'package:notes/features/auth/domain/auth_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

/// ============================================================================
/// ARCHITECTURAL NOTE — From Bloc to Riverpod (Queries vs Commands)
/// ============================================================================
/// Coming from Bloc, you are used to packing everything into a single `AuthBloc`
/// with `AuthInitial`, `AuthLoading`, `AuthAuthenticated`, `AuthError`.
///
/// THE PROBLEM WITH SINGLE-STATE BLOCS:
/// When the user is already logged in (or logging in) and an action fails,
/// emitting `AuthError` often wipes out the current data state unless you
/// manually copy fields across states.
///
/// HOW RIVERPOD SOLVES THIS CLEANLY:
/// We separate:
///   1. **The Reactive Data Stream (`currentUserProvider`)**: Watches Drift SQLite
///      directly. Whenever the `AuthSessions` table changes, every listener in
///      the app automatically rebuilds!
///   2. **The Action Controller (`AuthController`)**: Tracks the lifecycle of user
///      button clicks (`signIn`, `signUp`, `resetPassword`, `signOut`) using
///      `AsyncValue<void>` (`AsyncLoading`, `AsyncData`, `AsyncError`).
@Riverpod(keepAlive: true)
Stream<AuthUser?> currentUser(Ref ref) {
  // Direct Reactive Read: No pass-through UseCase needed!
  return ref.watch(authRepositoryProvider).watchCurrentUser();
}

/// UI Controller for authentication mutations (Sign In / Sign Up / Reset / Sign Out).
@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {
    // Initial state is idle (`AsyncData(null)`).
  }

  /// Invoked when the user taps "LOG IN" on the LoginScreen.
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(loginUseCaseProvider).execute(
            rawEmail: email,
            password: password,
          );
    });
    return !state.hasError;
  }

  /// Invoked when the user taps "CREATE ACCOUNT" on the CreateAccountScreen.
  Future<bool> signUp({
    required String displayName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(registerUseCaseProvider).execute(
            rawDisplayName: displayName,
            rawEmail: email,
            password: password,
            confirmPassword: confirmPassword,
          );
    });
    return !state.hasError;
  }

  /// Invoked when the user taps "SUBMIT" on the ForgotPasswordScreen.
  Future<bool> requestPasswordReset({required String rawEmail}) async {
    final email = rawEmail.trim().toLowerCase();
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      if (email.isEmpty || !email.contains('@')) {
        throw const ValidationException('Please enter a valid email address.');
      }
      await ref
          .read(authRepositoryProvider)
          .requestPasswordReset(email: email);
    });
    return !state.hasError;
  }

  /// Invoked when the user taps "Sign Out".
  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signOut();
    });
  }
}
