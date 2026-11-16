import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notes/app/theme/app_theme.dart';
import 'package:notes/core/l10n/app_texts.dart';
import 'package:notes/core/utils/uuid_v7.dart';
import 'package:notes/features/notes/domain/note.dart';
import 'package:notes/features/notes/presentation/controllers/notes_controller.dart';
import 'package:notes/features/notes/presentation/widgets/note_palette.dart';

@RoutePage()
class TodoEditorScreen extends HookConsumerWidget {
  final Note? existingNote;

  const TodoEditorScreen({super.key, this.existingNote});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newItemController = useTextEditingController();
    final newItemFocusNode = useFocusNode();
    final todos = useState<List<TodoItem>>(existingNote?.todos ?? const []);
    final selectedColor =
        useState<int>(existingNote?.colorValue ?? 0xFFFFFFFF);
    final hasHandledExit = useRef(false);

    void addTodoItem() {
      final text = newItemController.text.trim();
      if (text.isEmpty) return;

      todos.value = [
        ...todos.value,
        TodoItem(
          id: UuidV7.generate(),
          text: text,
        ),
      ];
      newItemController.clear();
      newItemFocusNode.requestFocus();
    }

    void toggleItem(String id) {
      todos.value = todos.value.map((item) {
        if (item.id == id) return item.copyWith(isDone: !item.isDone);
        return item;
      }).toList();
    }

    Future<void> saveAndPop() async {
      if (hasHandledExit.value) return;
      hasHandledExit.value = true;

      // Capture any uncommitted text typed in the input field
      final pendingText = newItemController.text.trim();
      final finalTodos = pendingText.isNotEmpty
          ? [
              ...todos.value,
              TodoItem(
                id: UuidV7.generate(),
                text: pendingText,
              ),
            ]
          : todos.value;

      if (finalTodos.isNotEmpty) {
        await ref.read(notesControllerProvider.notifier).saveNote(
              existingNote: existingNote,
              title: existingNote?.title ?? '',
              content: '',
              colorValue: selectedColor.value,
              type: NoteType.todo,
              todos: finalTodos,
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

    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final isDefaultWhite = selectedColor.value == 0xFFFFFFFF;
    final bgColor =
        isDefaultWhite && isDark ? colors.surface : Color(selectedColor.value);
    final fgColor = isDefaultWhite && isDark ? colors.onSurface : Colors.black;
    final subtleColor =
        isDefaultWhite && isDark ? colors.onSurfaceVariant : Colors.black54;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          saveAndPop();
        }
      },
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: saveAndPop,
          ),
          title: Text(
            existingNote == null
                ? AppTexts.addTodoTitle
                : AppTexts.editTodoTitle,
            style: TextStyle(
              color: fgColor,
              fontSize: 19,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.more_vert, color: fgColor),
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
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.add, color: subtleColor, size: 26),
                    onPressed: addTodoItem,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: TextField(
                      controller: newItemController,
                      focusNode: newItemFocusNode,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => addTodoItem(),
                      style: TextStyle(
                        fontSize: 19,
                        color: fgColor,
                      ),
                      decoration: InputDecoration(
                        hintText: AppTexts.todoInputHint,
                        hintStyle: TextStyle(
                          fontSize: 19,
                          color: subtleColor,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              for (final item in todos.value)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Checkbox(
                        value: item.isDone,
                        onChanged: (_) => toggleItem(item.id),
                        activeColor: fgColor,
                        side: BorderSide(
                          color: fgColor,
                          width: 1.6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => toggleItem(item.id),
                          child: Text(
                            item.text,
                            style: TextStyle(
                              fontSize: 16.5,
                              color: fgColor,
                              decoration: item.isDone
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
