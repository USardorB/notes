import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:notes/core/database/tables/auth_session_table.dart';
import 'package:notes/core/database/tables/notes_table.dart';
import 'package:notes/core/sync/sync_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_database.g.dart';

/// ============================================================================
/// ARCHITECTURAL NOTE — Central Drift Database (Single Source of Truth)
/// ============================================================================
/// 1. Coming from `SharedPreferences`, this class replaces scattered key-value
///    reads with a relational, reactive SQLite database.
/// 2. Coming from `GetIt` (`sl<AppDatabase>()`), notice how `appDatabaseProvider`
///    below manages the singleton lifecycle and automatically closes the SQLite
///    connection if the provider is ever disposed (`ref.onDispose(db.close)`).
@DriftDatabase(tables: [AuthSessions, Notes])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    // `driftDatabase` from `package:drift_flutter` automatically resolves the
    // platform-correct application documents directory and runs SQLite on a
    // background isolate so UI frames never drop!
    return driftDatabase(name: 'notes_offline_first_db');
  }
}

/// Provides a singleton instance of [AppDatabase] across the app.
/// `keepAlive: true` ensures the database connection stays open for the
/// entire lifecycle of the app.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}
