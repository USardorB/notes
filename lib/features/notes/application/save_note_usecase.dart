import 'package:notes/core/error/app_exception.dart';
import 'package:notes/core/sync/sync_status.dart';
import 'package:notes/features/auth/data/auth_repository.dart';
import 'package:notes/features/notes/data/notes_repository.dart';
import 'package:notes/features/notes/domain/note.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'save_note_usecase.g.dart';

/// ============================================================================
/// ARCHITECTURAL NOTE — Cross-Feature UseCase Orchestration
/// ============================================================================
/// Notice why `SaveNoteUseCase` exists instead of the UI calling
/// `notesRepository.saveNoteLocally()` directly:
/// 1. It verifies the user is authenticated (`AuthRepository`).
/// 2. It enforces domain validation (rejects completely empty notes).
/// 3. It enforces domain invariants:
///    - Generates a deterministic/unique offline ID if creating a new note.
///    - Preserves `SyncStatus.pendingCreate` if a newly created offline note is
///      edited again before its first sync, or transitions `synced` -> `pendingUpdate`.
class SaveNoteUseCase {
  final NotesRepository notesRepository;
  final AuthRepository authRepository;

  const SaveNoteUseCase({
    required this.notesRepository,
    required this.authRepository,
  });

  Future<Note> execute({
    Note? existingNote,
    required String rawTitle,
    required String rawContent,
  }) async {
    final title = rawTitle.trim();
    final content = rawContent.trim();

    // 1. Business Rule Validation
    if (title.isEmpty && content.isEmpty) {
      throw const ValidationException('Cannot save an empty note.');
    }

    // 2. Ensure active user session exists
    final currentUser = await authRepository.getCurrentUser();
    if (currentUser == null) {
      throw const UnauthorizedException();
    }

    // 3. Offline Sync State Machine Transition:
    // If the note was created offline (`pendingCreate`) and never synced yet,
    // editing it again MUST keep it as `pendingCreate` (so the server receives
    // POST instead of PUT for an ID it doesn't know yet!).
    final nextSyncStatus = switch (existingNote?.syncStatus) {
      null => SyncStatus.pendingCreate,
      SyncStatus.pendingCreate => SyncStatus.pendingCreate,
      _ => SyncStatus.pendingUpdate,
    };

    final note = Note(
      id: existingNote?.id ?? 'note_${DateTime.now().microsecondsSinceEpoch}',
      userId: currentUser.id,
      title: title.isEmpty ? 'Untitled Note' : title,
      content: content,
      updatedAt: DateTime.now(),
      syncStatus: nextSyncStatus,
    );

    // 4. Persist locally & trigger background sync
    await notesRepository.saveNoteLocally(note);

    return note;
  }
}

@riverpod
SaveNoteUseCase saveNoteUseCase(Ref ref) {
  return SaveNoteUseCase(
    notesRepository: ref.watch(notesRepositoryProvider),
    authRepository: ref.watch(authRepositoryProvider),
  );
}

