import 'dart:async';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:notes/core/database/app_database.dart';
import 'package:notes/core/error/app_exception.dart';
import 'package:notes/core/l10n/app_texts.dart';
import 'package:notes/core/sync/sync_status.dart';
import 'package:notes/core/utils/uuid_v7.dart';
import 'package:notes/features/auth/data/local/auth_local_dao.dart';
import 'package:notes/features/auth/data/remote/auth_remote_api.dart';
import 'package:notes/features/auth/domain/auth_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

/// ============================================================================
/// ARCHITECTURAL NOTE — Offline-First Account Creation vs. Online-Only Login
/// ============================================================================
/// 1. **Create Account (`signUpWithEmail`) — Offline-First**:
///    - Generates a client-side UUIDv7 `userId` immediately.
///    - Writes the session to Drift SQLite with `SyncStatus.pendingCreate` so the
///      user can start taking notes immediately without internet.
///    - Attempts non-blocking background sync with the backend; until synced,
///      the UI displays a "Local Account • Not Synced" badge.
///
/// 2. **Log In (`signInWithEmail`) — Online-Only**:
///    - Requires an active internet connection and valid server authentication.
///    - Throws [NetworkException] / [UnauthorizedException] if offline or invalid.
class AuthRepository {
  final AuthLocalDao localDao;
  final AuthRemoteApi remoteApi;

  const AuthRepository({
    required this.localDao,
    required this.remoteApi,
  });

  /// Reactive stream of the currently authenticated user from local SQLite (SSOT).
  Stream<AuthUser?> watchCurrentUser() {
    return localDao.watchActiveSession().map((session) {
      if (session == null) return null;
      return _toDomain(session);
    });
  }

  /// One-time read of the current user (used by route guards & use cases).
  Future<AuthUser?> getCurrentUser() async {
    final session = await localDao.getActiveSession();
    return session != null ? _toDomain(session) : null;
  }

  /// **Online-Only** login: requires internet connection and backend verification.
  Future<AuthUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteApi.login(
        LoginRequest(email: email, password: password),
      );
      final syncedUser = user.copyWith(syncStatus: SyncStatus.synced);
      await _persistSession(syncedUser);
      return syncedUser;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if (statusCode == 401 || statusCode == 403) {
        throw UnauthorizedException(AppTexts.invalidCredentials);
      }
      throw NetworkException(
        AppTexts.loginRequiresInternet,
        statusCode: statusCode,
      );
    } catch (_) {
      throw NetworkException(AppTexts.loginRequiresInternet);
    }
  }

  /// **Offline-First** account creation:
  /// Creates a local UUIDv7 account immediately in Drift with
  /// `SyncStatus.pendingCreate` and attempts background sync if online.
  Future<AuthUser> signUpWithEmail({
    required String displayName,
    required String email,
    required String password,
  }) async {
    final localUser = AuthUser(
      id: UuidV7.generate(),
      email: email,
      displayName: displayName,
      accessToken: '',
      syncStatus: SyncStatus.pendingCreate,
    );

    // 1. Persist immediately to Drift so user enters the app offline (< 2ms).
    await _persistSession(localUser);

    // 2. Attempt non-blocking background registration with backend.
    unawaited(_trySyncAccountInBackground(localUser, password: password));

    return localUser;
  }

  Future<void> _trySyncAccountInBackground(
    AuthUser localUser, {
    required String password,
  }) async {
    try {
      final syncedUser = await remoteApi.register(
        RegisterRequest(
          id: localUser.id,
          displayName: localUser.displayName,
          email: localUser.email,
          password: password,
        ),
      );
      await _persistSession(syncedUser.copyWith(syncStatus: SyncStatus.synced));
    } catch (_) {
      // Device is offline or backend is not yet connected:
      // Keep `SyncStatus.pendingCreate` so the UI shows the "Not Synced" label.
    }
  }

  /// Strict account sync (called before logout when unsynced).
  /// Throws [NetworkException] if the backend cannot be reached.
  Future<void> syncPendingAccountStrict({String? password}) async {
    final current = await getCurrentUser();
    if (current == null || !current.syncStatus.needsSync) return;

    try {
      final syncedUser = await remoteApi.register(
        RegisterRequest(
          id: current.id,
          displayName: current.displayName,
          email: current.email,
          password: password ?? '',
        ),
      );
      await _persistSession(syncedUser.copyWith(syncStatus: SyncStatus.synced));
    } on DioException catch (e) {
      throw NetworkException(
        'Internet connection is required to sync your local account.',
        statusCode: e.response?.statusCode,
      );
    } catch (_) {
      throw const NetworkException(
        'Cannot sync local account right now. Please connect to the internet.',
      );
    }
  }

  /// Requests a password reset email link (requires internet).
  Future<void> requestPasswordReset({required String email}) async {
    try {
      await remoteApi.forgotPassword({'email': email});
    } on DioException catch (e) {
      throw NetworkException(
        'Internet connection is required to reset your password.',
        statusCode: e.response?.statusCode,
      );
    } catch (_) {
      throw const NetworkException(
        'Unable to reach server. Please check your internet connection.',
      );
    }
  }

  Future<void> _persistSession(AuthUser user) async {
    await localDao.saveSession(
      AuthSessionsCompanion(
        userId: Value(user.id),
        email: Value(user.email),
        displayName: Value(user.displayName),
        accessToken: Value(user.accessToken),
        syncStatus: Value(user.syncStatus),
        authenticatedAt: Value(DateTime.now()),
      ),
    );
  }

  AuthUser _toDomain(AuthSession session) {
    return AuthUser(
      id: session.userId,
      email: session.email,
      displayName: session.displayName,
      accessToken: session.accessToken,
      syncStatus: session.syncStatus,
    );
  }

  /// Updates the user's display name locally in Drift SQLite.
  Future<void> updateDisplayName(String displayName) async {
    final current = await getCurrentUser();
    if (current == null) return;
    await _persistSession(current.copyWith(displayName: displayName));
  }

  /// Clears the local session and notifies the server best-effort.
  Future<void> signOut() async {
    try {
      await remoteApi.logout();
    } catch (_) {
      // Local logout still completes cleanly once user confirms
    } finally {
      await localDao.clearSession();
    }
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(
    localDao: ref.watch(authLocalDaoProvider),
    remoteApi: ref.watch(authRemoteApiProvider),
  );
}
