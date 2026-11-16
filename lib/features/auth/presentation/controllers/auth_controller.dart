import 'package:notes/core/error/app_exception.dart';
import 'package:notes/features/auth/application/login_usecase.dart';
import 'package:notes/features/auth/application/logout_usecase.dart';
import 'package:notes/features/auth/data/auth_repository.dart';
import 'package:notes/features/auth/domain/auth_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

/// ============================================================================
/// ARCHITECTURAL NOTE — From Bloc to Riverpod (Queries vs Commands)
/// ============================================================================
/// We separate:
///   1. **The Reactive Data Stream (`currentUserProvider`)**: Watches Drift SQLite
///      directly. Whenever the `AuthSessions` table changes (including when a
///      local account transitions from `pendingCreate` -> `synced`), every
///      listener in the app automatically rebuilds!
///   2. **The Action Controller (`AuthController`)**: Tracks the lifecycle of user
///      button clicks (`signIn`, `signUp`, `resetPassword`, `syncAndSignOut`,
///      `signOut`) using `AsyncValue<void>`.
@Riverpod(keepAlive: true)
Stream<AuthUser?> currentUser(Ref ref) {
  return ref.watch(authRepositoryProvider).watchCurrentUser();
}

/// UI Controller for authentication mutations.
@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {}

  /// **Online-Only** Sign In.
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

  /// **Offline-First** Create Account.
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

  /// Attempts to sync a local offline-created account to the backend.
  Future<bool> syncAccountNow() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).syncPendingAccountStrict();
    });
    return !state.hasError;
  }

  Future<UnsyncedSummary> checkUnsyncedData() {
    return ref.read(logoutUseCaseProvider).checkUnsyncedData();
  }

  /// Force-syncs account & dirty notes before signing out.
  /// Returns `false` and populates `state.error` if offline.
  Future<bool> syncAndSignOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(logoutUseCaseProvider).syncAndSignOut();
    });
    return !state.hasError;
  }

  /// Updates display name locally in Drift SQLite.
  Future<void> updateDisplayName(String rawName) async {
    final name = rawName.trim();
    if (name.isEmpty) return;
    await ref.read(authRepositoryProvider).updateDisplayName(name);
  }

  /// Signs out immediately without syncing.
  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(logoutUseCaseProvider).forceSignOut();
    });
  }
}
