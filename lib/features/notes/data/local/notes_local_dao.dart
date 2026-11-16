import 'package:drift/drift.dart';
import 'package:notes/core/database/app_database.dart';
import 'package:notes/core/database/tables/notes_table.dart';
import 'package:notes/core/sync/sync_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notes_local_dao.g.dart';

/// ============================================================================
/// ARCHITECTURAL NOTE — Offline-First Queries & Tombstone Filtering
/// ============================================================================
/// Look closely at `watchVisibleNotes()`:
/// We filter out `SyncStatus.pendingDelete` right inside the SQLite query.
///
/// That means when the user swipes to delete a note while offline:
/// 1. We call `markAsPendingDelete(id)`.
/// 2. Drift immediately re-evaluates `watchVisibleNotes()`.
/// 3. The note vanishes from the UI in < 2ms!
/// 4. Meanwhile, `getUnsyncedNotes()` still sees the `pendingDelete` row so the
///    background sync engine knows to send `DELETE /notes/:id` when back online.
@DriftAccessor(tables: [Notes])
class NotesLocalDao extends DatabaseAccessor<AppDatabase>
    with _$NotesLocalDaoMixin {
  NotesLocalDao(super.attachedDatabase);

  /// Streams all active (non-deleted) notes ordered by most recently modified.
  Stream<List<NoteEntry>> watchVisibleNotes(String userId) {
    final query = select(notes)
      ..where(
        (tbl) =>
            tbl.userId.equals(userId) &
            tbl.syncStatus.isNotValue(SyncStatus.pendingDelete.name),
      )
      ..orderBy([
        (tbl) => OrderingTerm(
              expression: tbl.updatedAt,
              mode: OrderingMode.desc,
            ),
      ]);
    return query.watch();
  }

  /// Fetches a single note by ID (used for deep linking `/notes/:id`).
  Future<NoteEntry?> getNoteById(String id) {
    final query = select(notes)..where((tbl) => tbl.id.equals(id));
    return query.getSingleOrNull();
  }

  /// Inserts or updates a note locally.
  Future<void> upsertNote(NotesCompanion entry) async {
    await into(notes).insertOnConflictUpdate(entry);
  }

  /// Soft-deletes a note (Tombstone) so it disappears from UI immediately
  /// while awaiting remote server deletion.
  Future<void> markAsPendingDelete(String id) async {
    await (update(notes)..where((tbl) => tbl.id.equals(id))).write(
      const NotesCompanion(syncStatus: Value(SyncStatus.pendingDelete)),
    );
  }

  /// Permanently removes the row from SQLite after remote sync succeeds.
  Future<void> hardDeleteNote(String id) async {
    await (delete(notes)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Returns all dirty rows (`pendingCreate`, `pendingUpdate`, `pendingDelete`)
  /// that need to be pushed to the remote server.
  Future<List<NoteEntry>> getUnsyncedNotes(String userId) {
    final query = select(notes)
      ..where(
        (tbl) =>
            tbl.userId.equals(userId) &
            tbl.syncStatus.isNotValue(SyncStatus.synced.name),
      );
    return query.get();
  }

  /// Reactive stream of how many dirty rows are awaiting sync.
  Stream<int> watchUnsyncedCount(String userId) {
    final query = select(notes)
      ..where(
        (tbl) =>
            tbl.userId.equals(userId) &
            tbl.syncStatus.isNotValue(SyncStatus.synced.name),
      );
    return query.watch().map((rows) => rows.length);
  }
}

/// Notice: Because our domain model is also named `Note`, let's check Drift's
/// generated data class name on `Notes` table!
/// Wait: By default, Drift strips trailing 's' from `class Notes extends Table`
/// and generates a data class named `Note` unless `@DataClassName('NoteEntry')`
/// is specified on the `Notes` table!
@riverpod
NotesLocalDao notesLocalDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return NotesLocalDao(db);
}

