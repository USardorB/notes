import 'package:dart_mappable/dart_mappable.dart';
import 'package:notes/core/sync/sync_status.dart';

part 'note.mapper.dart';

@MappableEnum()
enum NoteType {
  note,
  todo,
}

@MappableClass()
class TodoItem({
  required final String id,
  required final String text,
  final bool isDone = false,
}) with TodoItemMappable;

/// ============================================================================
/// ARCHITECTURAL NOTE — Primary Constructor Domain Model (`dart_mappable`)
/// ============================================================================
/// Declared using Dart's primary constructor syntax (`class Note(...) with ...;`).
/// Supports both standard text notes (`NoteType.note`) and checklist to-dos
/// (`NoteType.todo`), plus per-note color (`colorValue` ARGB int).
@MappableClass()
class Note({
  required final String id,
  required final String userId,
  required final String title,
  required final String content,
  required final DateTime updatedAt,
  final int colorValue = 0xFFFFFFFF,
  final NoteType type = NoteType.note,
  final List<TodoItem> todos = const [],
  final SyncStatus syncStatus = SyncStatus.pendingCreate,
}) with NoteMappable;
