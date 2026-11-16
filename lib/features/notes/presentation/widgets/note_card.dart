import 'package:flutter/material.dart';
import 'package:notes/features/notes/domain/note.dart';
import 'package:notes/features/notes/presentation/widgets/note_palette.dart';

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
    final isWhite = note.colorValue == 0xFFFFFFFF;
    final displayTitle = note.title.isNotEmpty ? note.title : note.content;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        decoration: BoxDecoration(
          color: Color(note.colorValue),
          borderRadius: BorderRadius.circular(12),
          border: isWhite ? Border.all(color: Colors.black87, width: 1) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (note.type == NoteType.todo) ...[
              if (note.title.isNotEmpty) ...[
                Text(
                  note.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
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
                          activeColor: Colors.black87,
                          side: const BorderSide(
                            color: Colors.black87,
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
                            color: Colors.black,
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
                style: const TextStyle(
                  fontSize: 19,
                  height: 1.3,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                formatRelativeTime(note.updatedAt),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
