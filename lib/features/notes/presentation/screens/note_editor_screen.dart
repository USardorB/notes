import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notes/app/theme/app_theme.dart';
import 'package:notes/features/notes/domain/note.dart';
import 'package:notes/features/notes/presentation/controllers/notes_controller.dart';
import 'package:notes/features/notes/presentation/widgets/note_palette.dart';

@RoutePage()
class NoteEditorScreen extends HookConsumerWidget {
  final Note? existingNote;

  const NoteEditorScreen({super.key, this.existingNote});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController =
        useTextEditingController(text: existingNote?.title ?? '');
    final contentController =
        useTextEditingController(text: existingNote?.content ?? '');
    final selectedColor =
        useState<int>(existingNote?.colorValue ?? 0xFFFFFFFF);
    final hasHandledExit = useRef(false);

    Future<void> saveAndPop() async {
      if (hasHandledExit.value) return;
      hasHandledExit.value = true;

      final title = titleController.text.trim();
      final content = contentController.text.trim();
      final hasChanges = title != (existingNote?.title ?? '') ||
          content != (existingNote?.content ?? '') ||
          selectedColor.value != (existingNote?.colorValue ?? 0xFFFFFFFF);

      if ((title.isNotEmpty || content.isNotEmpty) && hasChanges) {
        await ref.read(notesControllerProvider.notifier).saveNote(
              existingNote: existingNote,
              title: title,
              content: content,
              colorValue: selectedColor.value,
              type: NoteType.note,
            );
      }

      if (context.mounted) {
        context.router.maybePop();
      }
    }

    Future<void> deleteAndPop() async {
      hasHandledExit.value = true;
      if (existingNote != null) {
        await ref
            .read(notesControllerProvider.notifier)
            .deleteNote(existingNote!.id);
      }
      if (context.mounted) {
        context.router.maybePop();
      }
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          saveAndPop();
        }
      },
      child: Scaffold(
        backgroundColor: Color(selectedColor.value),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: saveAndPop,
          ),
          title: Text(
            existingNote == null ? 'Add Note' : 'Edit Note',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 19,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              onPressed: () {
                showNoteOptionsSheet(
                  context: context,
                  currentColor: selectedColor.value,
                  onColorSelected: (color) => selectedColor.value = color,
                  onDelete: existingNote != null ? deleteAndPop : null,
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: titleController,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  style: const TextStyle(
                    fontSize: 26,
                    height: 1.3,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    hintStyle: TextStyle(color: Colors.black38),
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: contentController,
                  maxLines: null,
                  minLines: 14,
                  textCapitalization: TextCapitalization.sentences,
                  style: const TextStyle(
                    fontSize: 16.5,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Start typing...',
                    hintStyle: TextStyle(color: Colors.black38),
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
