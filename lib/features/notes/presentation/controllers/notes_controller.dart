import 'package:notes/features/auth/presentation/controllers/auth_controller.dart';
import 'package:notes/features/notes/application/save_note_usecase.dart';
import 'package:notes/features/notes/data/notes_repository.dart';
import 'package:notes/features/notes/domain/note.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notes_controller.g.dart';

/// ============================================================================
/// ARCHITECTURAL NOTE — Reactive Composition in Riverpod
/// ============================================================================
/// Look at `notesListStreamProvider` below:
/// It watches `currentUserProvider` (from the Auth feature) AND
/// `notesRepositoryProvider` (from the Notes feature).
///
/// The moment the user logs in or switches accounts, `currentUserProvider`
/// emits the new user, and `notesListStreamProvider` automatically re-subscribes
/// to that user's SQLite notes stream in Drift!
@riverpod
Stream<List<Note>> notesListStream(Ref ref) {
  final userAsync = ref.watch(currentUserProvider);
  final user = userAsync.value;
  if (user == null) {
    return Stream.value(const []);
  }
  return ref.watch(notesRepositoryProvider).watchNotes(user.id);
}

/// UI Controller for Note mutations (Create, Update, Delete).
@riverpod
class NotesController extends _$NotesController {
  @override
  FutureOr<void> build() {}

  Future<bool> saveNote({
    Note? existingNote,
    required String title,
    required String content,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(saveNoteUseCaseProvider).execute(
            existingNote: existingNote,
            rawTitle: title,
            rawContent: content,
          );
    });
    return !state.hasError;
  }

  Future<void> deleteNote(String noteId) async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(notesRepositoryProvider).deleteNoteLocally(
            noteId: noteId,
            userId: user.id,
          );
    });
  }
}

