import 'package:flutter/material.dart';
import 'package:notes/core/l10n/app_texts.dart';
import 'package:notes/features/notes/domain/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final ValueChanged<String> onToggleTodo;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onToggleTodo,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final isDefaultWhite = note.colorValue == 0xFFFFFFFF;

    // Default white cards adapt to dark surface in Dark Mode;
    // pastel colored cards keep dark text for optimal contrast.
    final cardColor = isDefaultWhite && isDark
        ? colors.surfaceContainerHigh
        : Color(note.colorValue);
    final textColor = isDefaultWhite && isDark ? colors.onSurface : Colors.black;
    final subtleTextColor =
        isDefaultWhite && isDark ? colors.onSurfaceVariant : Colors.black87;

    final displayTitle = note.title.isNotEmpty ? note.title : note.content;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: isDefaultWhite
              ? Border.all(
                  color: isDark ? colors.outlineVariant : Colors.black87,
                  width: 1,
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (note.type == NoteType.todo) ...[
              if (note.title.isNotEmpty) ...[
                Text(
                  note.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
              ],
              for (final item in note.todos.take(4))
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 22,
                        height: 22,
                        child: Checkbox(
                          value: item.isDone,
                          onChanged: (_) => onToggleTodo(item.id),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          activeColor: subtleTextColor,
                          side: BorderSide(
                            color: subtleTextColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item.text,
                          style: TextStyle(
                            fontSize: 15.5,
                            color: textColor,
                            decoration: item.isDone
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ] else
              Text(
                displayTitle,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 19,
                  height: 1.3,
                  fontWeight: FontWeight.w400,
                  color: textColor,
                ),
              ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                AppTexts.formatRelativeTime(note.updatedAt),
                style: TextStyle(
                  fontSize: 12,
                  color: subtleTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
