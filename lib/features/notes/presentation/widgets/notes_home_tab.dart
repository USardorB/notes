import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notes/app/router/app_router.dart';
import 'package:notes/app/theme/app_theme.dart';
import 'package:notes/features/notes/domain/note.dart';
import 'package:notes/features/notes/presentation/controllers/notes_controller.dart';
import 'package:notes/features/notes/presentation/widgets/note_card.dart';
import 'package:notes/features/notes/presentation/widgets/note_palette.dart';

class NotesHomeTab extends ConsumerWidget {
  const NotesHomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(filteredNotesProvider);
    final viewMode = ref.watch(notesViewModeProvider);
    final selectedColor = ref.watch(notesColorFilterProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 16, 12),
          child: Row(
            children: [
              const Text(
                'Notes',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Filter by colour',
                icon: Badge(
                  isLabelVisible: selectedColor != null,
                  backgroundColor: AppColors.primary,
                  child: const Icon(
                    Icons.palette,
                    color: Colors.black,
                    size: 26,
                  ),
                ),
                onPressed: () {
                  showFilterByColourSheet(
                    context: context,
                    selectedColor: selectedColor,
                    onSelectColor: (color) => ref
                        .read(notesColorFilterProvider.notifier)
                        .selectColor(color),
                  );
                },
              ),
              IconButton(
                tooltip: viewMode == NotesViewMode.list
                    ? 'Grid view'
                    : 'List view',
                icon: Icon(
                  viewMode == NotesViewMode.list
                      ? Icons.grid_view_outlined
                      : Icons.drag_handle_rounded,
                  color: Colors.black,
                  size: 26,
                ),
                onPressed: () =>
                    ref.read(notesViewModeProvider.notifier).toggle(),
              ),
            ],
          ),
        ),
        Expanded(
          child: notesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
            data: (notes) {
              if (notes.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 48),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/vectors/rafiki.svg',
                          height: 220,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          selectedColor != null
                              ? 'No notes match this colour'
                              : 'Create your first note !',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w300,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (viewMode == NotesViewMode.list) {
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 96),
                  itemCount: notes.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, index) => NoteCard(
                    note: notes[index],
                    onTap: () => _openEditor(context, notes[index]),
                    onToggleTodo: (todoId) => ref
                        .read(notesControllerProvider.notifier)
                        .toggleTodoItem(note: notes[index], todoId: todoId),
                  ),
                );
              }

              final leftColumn = <Note>[];
              final rightColumn = <Note>[];
              for (var i = 0; i < notes.length; i++) {
                if (i.isEven) {
                  leftColumn.add(notes[i]);
                } else {
                  rightColumn.add(notes[i]);
                }
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 96),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _MasonryColumn(
                        notes: leftColumn,
                        onOpenEditor: (n) => _openEditor(context, n),
                        onToggleTodo: (n, todoId) => ref
                            .read(notesControllerProvider.notifier)
                            .toggleTodoItem(note: n, todoId: todoId),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _MasonryColumn(
                        notes: rightColumn,
                        onOpenEditor: (n) => _openEditor(context, n),
                        onToggleTodo: (n, todoId) => ref
                            .read(notesControllerProvider.notifier)
                            .toggleTodoItem(note: n, todoId: todoId),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _openEditor(BuildContext context, Note note) {
    if (note.type == NoteType.todo) {
      context.router.push(TodoEditorRoute(existingNote: note));
    } else {
      context.router.push(NoteEditorRoute(existingNote: note));
    }
  }
}

class _MasonryColumn extends StatelessWidget {
  final List<Note> notes;
  final ValueChanged<Note> onOpenEditor;
  final void Function(Note note, String todoId) onToggleTodo;

  const _MasonryColumn({
    required this.notes,
    required this.onOpenEditor,
    required this.onToggleTodo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final note in notes) ...[
          NoteCard(
            note: note,
            onTap: () => onOpenEditor(note),
            onToggleTodo: (todoId) => onToggleTodo(note, todoId),
          ),
          const SizedBox(height: 14),
        ],
      ],
    );
  }
}
