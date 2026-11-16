/// ============================================================================
/// ARCHITECTURAL NOTE — The Offline-First Sync State Machine
/// ============================================================================
/// In an online-only app, creating or deleting a note calls the REST API first.
/// In an OFFLINE-FIRST app, every user action writes to Drift SQLite immediately
/// and tags the record with a [SyncStatus].
///
/// WHY `pendingDelete` (TOMBSTONES) EXIST:
/// If a user deletes a note while offline and you run `DELETE FROM notes`,
/// the row vanishes locally. When the phone reconnects to Wi-Fi later, your app
/// won't remember that the note needs to be deleted on the server!
/// Marking it as [SyncStatus.pendingDelete] hides it from the UI immediately
/// while keeping a "tombstone" until the remote server confirms the deletion.
library;

enum SyncStatus {
  /// Local row matches the remote server state.
  synced,

  /// Created locally while offline (or awaiting background push).
  pendingCreate,

  /// Edited locally; local changes need to be pushed to the server.
  pendingUpdate,

  /// Soft-deleted locally (Tombstone). Hidden from UI queries, awaiting
  /// remote `DELETE /notes/:id` confirmation before hard-deleting from SQLite.
  pendingDelete;

  bool get needsSync => this != SyncStatus.synced;
}

