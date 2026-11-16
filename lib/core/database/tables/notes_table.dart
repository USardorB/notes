import 'package:drift/drift.dart';
import 'package:notes/core/sync/sync_status.dart';
import 'package:notes/features/notes/domain/note.dart';

/// ============================================================================
/// ARCHITECTURAL NOTE — Offline-First Notes Table Schema
/// ============================================================================
/// Notice how we use a client-generated UUID (`id`) as the primary key instead
/// of an auto-incrementing SQLite integer (`1, 2, 3...`).
///
/// WHY UUIDs ARE MANDATORY FOR OFFLINE-FIRST:
/// If Device A and Device B both create a note while offline and use
/// auto-incrementing IDs, both notes get `id = 1`. When they sync to the server,
/// they collide! With client-generated UUIDs (or ULIDs), notes can be created,
/// edited, and linked offline with zero ID collisions.
///
/// `@DataClassName('NoteEntry')` prevents Drift's generated SQLite row class
/// from colliding with our `@MappableClass() class Note` domain model.
@DataClassName('NoteEntry')
class Notes extends Table {
  /// Client-generated ID.
  TextColumn get id => text()();

  /// Owner user ID (links to AuthSessions.userId).
  TextColumn get userId => text()();

  /// Note title.
  TextColumn get title => text()();

  /// Note body content.
  TextColumn get content => text()();

  /// ARGB color integer for the note card & editor background.
  IntColumn get colorValue => integer().withDefault(const Constant(0xFFFFFFFF))();

  /// Distinguishes regular notes from checklist to-dos.
  TextColumn get type =>
      textEnum<NoteType>().withDefault(Constant(NoteType.note.name))();

  /// JSON-encoded list of [TodoItem]s for checklist notes.
  TextColumn get todosJson => text().withDefault(const Constant('[]'))();

  /// Last modification timestamp (used for Last-Write-Wins conflict resolution).
  DateTimeColumn get updatedAt => dateTime()();

  /// Offline synchronization state (`synced`, `pendingCreate`, `pendingUpdate`, `pendingDelete`).
  /// Drift's `textEnum` automatically maps our Dart `SyncStatus` enum to a TEXT column!
  TextColumn get syncStatus =>
      textEnum<SyncStatus>().withDefault(Constant(SyncStatus.pendingCreate.name))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
