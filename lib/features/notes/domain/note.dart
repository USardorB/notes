import 'package:dart_mappable/dart_mappable.dart';
import 'package:notes/core/sync/sync_status.dart';

part 'note.mapper.dart';

/// ============================================================================
/// ARCHITECTURAL NOTE — Primary Constructor Domain Model (`dart_mappable`)
/// ============================================================================
/// Declared using Dart's primary constructor syntax (`class Note(...) with ...;`).
/// `dart_mappable` inspects the primary constructor parameters directly, and
/// `retrofit_generator` (configured globally via `build.yaml` with
/// `parser: dart_mappable`) automatically invokes `NoteMapper.fromMap` and
/// `note.toMap()`.
@MappableClass()
class Note({
  required final String id,
  required final String userId,
  required final String title,
  required final String content,
  required final DateTime updatedAt,
  final SyncStatus syncStatus = SyncStatus.pendingCreate,
}) with NoteMappable;
