import 'package:drift/drift.dart';
import 'package:notes/core/database/app_database.dart';
import 'package:notes/core/database/tables/auth_session_table.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_local_dao.g.dart';

/// ============================================================================
/// ARCHITECTURAL NOTE — Drift DAO (Level 1: From SharedPreferences to SQLite)
/// ============================================================================
/// A DAO (Data Access Object) encapsulates all SQLite queries for a specific
/// feature so `AppDatabase` doesn't become a 2,000-line God class.
///
/// PUZZLE SOLVER INSIGHT — `.getSingleOrNull()` vs `.watchSingleOrNull()`:
/// - `.getSingleOrNull()` returns a `Future<AuthSession?>` (one-time read, like
///   `prefs.getString()`).
/// - `.watchSingleOrNull()` returns a `Stream<AuthSession?>`! Drift automatically
///   tracks table mutations: the moment `saveSession()` or `clearSession()` runs
///   anywhere in the app, this Stream emits the new state automatically!
@DriftAccessor(tables: [AuthSessions])
class AuthLocalDao extends DatabaseAccessor<AppDatabase>
    with _$AuthLocalDaoMixin {
  AuthLocalDao(super.attachedDatabase);

  /// Reactive stream of the active session. Emits `null` when logged out.
  Stream<AuthSession?> watchActiveSession() {
    final query = select(authSessions)..limit(1);
    return query.watchSingleOrNull();
  }

  /// One-shot read of the active session.
  Future<AuthSession?> getActiveSession() {
    final query = select(authSessions)..limit(1);
    return query.getSingleOrNull();
  }

  /// Persists the authenticated user session atomically.
  /// Replaces any previous session in a single transaction.
  Future<void> saveSession(AuthSessionsCompanion session) async {
    await transaction(() async {
      await delete(authSessions).go();
      await into(authSessions).insertOnConflictUpdate(session);
    });
  }

  /// Clears the local session on logout.
  Future<void> clearSession() async {
    await delete(authSessions).go();
  }
}

@riverpod
AuthLocalDao authLocalDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return AuthLocalDao(db);
}

