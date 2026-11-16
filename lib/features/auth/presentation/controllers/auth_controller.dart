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
///      button clicks (`login`, `logout`) using `AsyncValue<void>` (`AsyncLoading`,
///      `AsyncData`, `AsyncError`).
@Riverpod(keepAlive: true)
Stream<AuthUser?> currentUser(Ref ref) {
  // Direct Reactive Read: No pass-through UseCase needed!
  return ref.watch(authRepositoryProvider).watchCurrentUser();
}

/// UI Controller for authentication mutations (Sign In / Sign Out).
@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {
    // Initial state is idle (`AsyncData(null)`).
  }

  /// Invoked when the user taps "Sign In" on the LoginScreen.
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    // Equivalent to `emit(AuthLoading())` in Bloc:
    state = const AsyncLoading();

    // `AsyncValue.guard` automatically catches any thrown `AppException`
    // and transitions `state` to `AsyncError(e, stackTrace)`—or `AsyncData` on success!
    state = await AsyncValue.guard(() async {
      await ref.read(loginUseCaseProvider).execute(
            rawEmail: email,
            password: password,
          );
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

