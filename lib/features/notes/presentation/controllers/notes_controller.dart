import 'package:notes/features/auth/presentation/controllers/auth_controller.dart';
import 'package:notes/features/notes/application/save_note_usecase.dart';
import 'package:notes/features/notes/data/notes_repository.dart';
import 'package:notes/features/notes/domain/note.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notes_controller.g.dart';

enum NotesViewMode {
  list,
  grid,
}

/// ============================================================================
/// ARCHITECTURAL NOTE — Reactive Composition in Riverpod
/// ============================================================================
/// `notesListStreamProvider` watches `currentUserProvider` (Auth) and
/// `notesRepositoryProvider` (Notes). When the user signs in or switches
/// accounts, it automatically re-subscribes to that user's SQLite notes stream.
@riverpod
Stream<List<Note>> notesListStream(Ref ref) {
  final userAsync = ref.watch(currentUserProvider);
  final user = userAsync.value;
  if (user == null) {
    return Stream.value(const []);
  }
  return ref.watch(notesRepositoryProvider).watchNotes(user.id);
}

/// Streams the number of unsynced notes for the active user.
@riverpod
Stream<int> unsyncedNotesCount(Ref ref) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return Stream.value(0);
  return ref.watch(notesRepositoryProvider).watchUnsyncedCount(user.id);
}

/// Dedicated two-way sync controller used by the Notes header Sync button.
@riverpod
class NotesSyncController extends _$NotesSyncController {
  @override
  FutureOr<void> build() {}

  Future<void> syncNow() async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(notesRepositoryProvider).syncAll(user.id);
    });
  }
}

/// Holds the active view mode (single-column list vs 2-column staggered grid).
@riverpod
class NotesViewModeNotifier extends _$NotesViewModeNotifier {
  @override
  NotesViewMode build() => NotesViewMode.list;

  void toggle() {
    state = state == NotesViewMode.list
        ? NotesViewMode.grid
        : NotesViewMode.list;
  }
}

/// Holds the selected color filter (`null` = show all notes).
@riverpod
class NotesColorFilter extends _$NotesColorFilter {
  @override
  int? build() => null;

  void selectColor(int? colorValue) => state = colorValue;

  void reset() => state = null;
}

/// Derived reactive provider: automatically filters `notesListStream` whenever
/// either Drift emits new notes OR the user taps a color in "Filter by colour".
@riverpod
AsyncValue<List<Note>> filteredNotes(Ref ref) {
  final notesAsync = ref.watch(notesListStreamProvider);
  final selectedColor = ref.watch(notesColorFilterProvider);

  return notesAsync.whenData((notes) {
    if (selectedColor == null) return notes;
    return notes.where((n) => n.colorValue == selectedColor).toList();
  });
}

/// UI Controller for Note mutations (Create, Update, Delete, Todo Toggle).
@riverpod
class NotesController extends _$NotesController {
  @override
  FutureOr<void> build() {}

  Future<bool> saveNote({
    Note? existingNote,
    required String title,
    required String content,
    int colorValue = 0xFFFFFFFF,
    NoteType type = NoteType.note,
    List<TodoItem> todos = const [],
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(saveNoteUseCaseProvider).execute(
            existingNote: existingNote,
            rawTitle: title,
            rawContent: content,
            colorValue: colorValue,
            type: type,
            todos: todos,
          );
    });
    return !state.hasError;
  }

  Future<void> toggleTodoItem({
    required Note note,
    required String todoId,
  }) async {
    final updatedTodos = note.todos.map((item) {
      if (item.id == todoId) {
        return item.copyWith(isDone: !item.isDone);
      }
      return item;
    }).toList();

    await saveNote(
      existingNote: note,
      title: note.title,
      content: note.content,
      colorValue: note.colorValue,
      type: note.type,
      todos: updatedTodos,
    );
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
