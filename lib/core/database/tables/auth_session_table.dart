import 'package:drift/drift.dart';

/// ============================================================================
/// ARCHITECTURAL NOTE — Drift vs SharedPreferences for Auth Session
/// ============================================================================
/// Coming from `SharedPreferences`, you are used to storing keys like:
///   `prefs.setString('user_id', ...)`
///   `prefs.setString('email', ...)`
///
/// WHY DRIFT IS MORE MATURE HERE:
/// 1. SharedPreferences is NOT reactive by default (you have to manually notify
///    Blocs when keys change). Drift tables emit a real-time `Stream<AuthSession?>`
///    automatically whenever the row is inserted, updated, or cleared!
/// 2. Atomic transactions: Clearing a user session and wiping unsynced private
///    data on logout happens in a single atomic SQLite transaction.
/// 3. Type safety: Schema migrations and typed columns prevent runtime cast bugs.
class AuthSessions extends Table {
  /// User ID from backend (Primary Key).
  TextColumn get userId => text()();

  /// Authenticated user's email address.
  TextColumn get email => text()();

  /// Display name.
  TextColumn get displayName => text()();

  /// Access token (Note: in high-security production apps, sensitive raw tokens
  /// can be paired with `flutter_secure_storage`, while user profile & session
  /// metadata live reactively in Drift).
  TextColumn get accessToken => text()();

  /// Timestamp when the session was last refreshed.
  DateTimeColumn get authenticatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {userId};
}
