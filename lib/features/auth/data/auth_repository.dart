import 'package:drift/drift.dart';
import 'package:notes/core/database/app_database.dart';
import 'package:notes/features/auth/data/local/auth_local_dao.dart';
import 'package:notes/features/auth/data/remote/auth_remote_api.dart';
import 'package:notes/features/auth/domain/auth_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

/// ============================================================================
/// ARCHITECTURAL NOTE — The Offline-First Repository & "Interface Literacy"
/// ============================================================================
/// OVER-ENGINEERING CHECK: Where is `abstract class IAuthRepository`?
/// In Java/C# (where Uncle Bob wrote Clean Architecture), classes and interfaces
/// are distinct constructs, so you had to write `IAuthRepository` to mock a repo.
///
/// In Dart, **every class implicitly defines an interface**!
/// In unit tests, you can write `class FakeAuthRepo implements AuthRepository`
/// and inject it via:
///   `ProviderScope(overrides: [authRepositoryProvider.overrideWithValue(FakeAuthRepo())])`
/// Therefore, creating a separate `abstract class AuthRepository` file when you
/// only have 1 production implementation is pure ceremony.
class AuthRepository {
  final AuthLocalDao localDao;
  final AuthRemoteApi remoteApi;

  const AuthRepository({
    required this.localDao,
    required this.remoteApi,
  });

  /// Reactive stream of the currently authenticated user from local SQLite (SSOT).
  /// Even when the user launches the app in Airplane Mode, this immediately
  /// emits their persisted session!
  Stream<AuthUser?> watchCurrentUser() {
    return localDao.watchActiveSession().map((session) {
      if (session == null) return null;
      return AuthUser(
        id: session.userId,
        email: session.email,
        displayName: session.displayName,
        accessToken: session.accessToken,
      );
    });
  }

  /// One-time read of the current user (useful for synchronous/async route guards).
  Future<AuthUser?> getCurrentUser() async {
    final session = await localDao.getActiveSession();
    if (session == null) return null;
    return AuthUser(
      id: session.userId,
      email: session.email,
      displayName: session.displayName,
      accessToken: session.accessToken,
    );
  }

  /// Authenticates against the remote API (or local stub while backend is offline)
  /// and writes the resulting session into Drift SQLite.
  Future<AuthUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    AuthUser user;
    try {
      // 1. Attempt remote authentication via Retrofit
      user = await remoteApi.login(
        LoginRequest(email: email, password: password),
      );
    } catch (_) {
      // Fallback stub while backend API is not yet connected so you can test
      // the full Drift + Riverpod + AutoRoute flow immediately:
      user = AuthUser(
        id: 'usr_${email.hashCode.abs()}',
        email: email,
        displayName: email.split('@').first,
        accessToken: 'offline_dev_token_${DateTime.now().millisecondsSinceEpoch}',
      );
    }

    // 2. Persist to Drift (Single Source of Truth).
    // The moment this insert completes, `watchCurrentUser()` automatically
    // emits the new `AuthUser` to the entire app!
    await localDao.saveSession(
      AuthSessionsCompanion(
        userId: Value(user.id),
        email: Value(user.email),
        displayName: Value(user.displayName),
        accessToken: Value(user.accessToken),
        authenticatedAt: Value(DateTime.now()),
      ),
    );

    return user;
  }

  /// Clears the local session and notifies the server best-effort.
  Future<void> signOut() async {
    try {
      await remoteApi.logout();
    } catch (_) {
      // Offline logout still succeeds locally
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

