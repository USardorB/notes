import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:notes/core/database/app_database.dart';
import 'package:notes/core/sync/sync_status.dart';
import 'package:notes/features/notes/data/local/notes_local_dao.dart';
import 'package:notes/features/notes/data/remote/notes_remote_api.dart';
import 'package:notes/features/notes/domain/note.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notes_repository.g.dart';

/// ============================================================================
/// ARCHITECTURAL NOTE — The Offline-First Sync Orchestrator (Level 3)
/// ============================================================================
/// This repository demonstrates the golden rule of Offline-First:
/// 1. The UI ONLY reads from Drift (`watchNotes`).
/// 2. Every mutation writes to Drift FIRST, then triggers `syncPendingNotes()`
///    unawaited in the background.
/// 3. If the user is in a subway tunnel without internet, `syncPendingNotes()`
///    quietly catches the network error and leaves the rows marked as `pending*`
///    for the next sync cycle—the UI never freezes or loses data!
class NotesRepository {
  final NotesLocalDao localDao;
  final NotesRemoteApi remoteApi;

  const NotesRepository({
    required this.localDao,
    required this.remoteApi,
  });

  /// Reactive stream of active notes from local SQLite (SSOT).
  Stream<List<Note>> watchNotes(String userId) {
    return localDao.watchVisibleNotes(userId).map(
          (rows) => rows.map(_toDomain).toList(),
        );
  }

  /// Fetches a single note by ID (used for Deep Linking `/notes/:id`).
  Future<Note?> getNoteById(String id) async {
    final row = await localDao.getNoteById(id);
    return row != null ? _toDomain(row) : null;
  }

  /// Writes the note to local SQLite immediately (< 2ms) and kicks off
  /// non-blocking background synchronization.
  Future<void> saveNoteLocally(Note note) async {
    await localDao.upsertNote(_toCompanion(note, note.syncStatus));

    // Non-blocking background sync (fire-and-forget)
    unawaited(syncPendingNotes(note.userId));
  }

  /// Soft-deletes a note locally (Tombstone) and kicks off background sync.
  Future<void> deleteNoteLocally({
    required String noteId,
    required String userId,
  }) async {
    await localDao.markAsPendingDelete(noteId);
    unawaited(syncPendingNotes(userId));
  }

  /// Pushes all local dirty rows (`pendingCreate`, `pendingUpdate`, `pendingDelete`)
  /// to the remote server and reconciles their status in Drift.
  Future<void> syncPendingNotes(String userId) async {
    final dirtyRows = await localDao.getUnsyncedNotes(userId);

    for (final row in dirtyRows) {
      final note = _toDomain(row);
      try {
        switch (note.syncStatus) {
          case SyncStatus.pendingCreate:
            await remoteApi.createNote(note);
            await _markAsSynced(note);
          case SyncStatus.pendingUpdate:
            await remoteApi.updateNote(note.id, note);
            await _markAsSynced(note);
          case SyncStatus.pendingDelete:
            await remoteApi.deleteNote(note.id);
            await localDao.hardDeleteNote(note.id);
          case SyncStatus.synced:
            break;
        }
      } catch (_) {
        // Offline or server unreachable: keep row in its `pending*` state.
        // It will automatically be retried on the next connectivity event.
      }
    }
  }

  Future<void> _markAsSynced(Note note) async {
    await localDao.upsertNote(_toCompanion(note, SyncStatus.synced));
  }

  NotesCompanion _toCompanion(Note note, SyncStatus syncStatus) {
    return NotesCompanion(
      id: Value(note.id),
      userId: Value(note.userId),
      title: Value(note.title),
      content: Value(note.content),
      colorValue: Value(note.colorValue),
      type: Value(note.type),
      todosJson: Value(
        jsonEncode(note.todos.map((item) => item.toMap()).toList()),
      ),
      updatedAt: Value(note.updatedAt),
      syncStatus: Value(syncStatus),
    );
  }

  Note _toDomain(NoteEntry row) {
    final decoded = (jsonDecode(row.todosJson) as List<dynamic>)
        .map((e) => TodoItemMapper.fromMap(e as Map<String, dynamic>))
        .toList();

    return Note(
      id: row.id,
      userId: row.userId,
      title: row.title,
      content: row.content,
      colorValue: row.colorValue,
      type: row.type,
      todos: decoded,
      updatedAt: row.updatedAt,
      syncStatus: row.syncStatus,
    );
  }
}

@riverpod
NotesRepository notesRepository(Ref ref) {
  return NotesRepository(
    localDao: ref.watch(notesLocalDaoProvider),
    remoteApi: ref.watch(notesRemoteApiProvider),
  );
}
