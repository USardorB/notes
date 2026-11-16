// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes_local_dao.dart';

// ignore_for_file: type=lint
mixin _$NotesLocalDaoMixin on DatabaseAccessor<AppDatabase> {
  $NotesTable get notes => attachedDatabase.notes;
  NotesLocalDaoManager get managers => NotesLocalDaoManager(this);
}

class NotesLocalDaoManager {
  final _$NotesLocalDaoMixin _db;
  NotesLocalDaoManager(this._db);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db.attachedDatabase, _db.notes);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notice: Because our domain model is also named `Note`, let's check Drift's
/// generated data class name on `Notes` table!
/// Wait: By default, Drift strips trailing 's' from `class Notes extends Table`
/// and generates a data class named `Note` unless `@DataClassName('NoteEntry')`
/// is specified on the `Notes` table!

@ProviderFor(notesLocalDao)
final notesLocalDaoProvider = NotesLocalDaoProvider._();

/// Notice: Because our domain model is also named `Note`, let's check Drift's
/// generated data class name on `Notes` table!
/// Wait: By default, Drift strips trailing 's' from `class Notes extends Table`
/// and generates a data class named `Note` unless `@DataClassName('NoteEntry')`
/// is specified on the `Notes` table!

final class NotesLocalDaoProvider
    extends $FunctionalProvider<NotesLocalDao, NotesLocalDao, NotesLocalDao>
    with $Provider<NotesLocalDao> {
  /// Notice: Because our domain model is also named `Note`, let's check Drift's
  /// generated data class name on `Notes` table!
  /// Wait: By default, Drift strips trailing 's' from `class Notes extends Table`
  /// and generates a data class named `Note` unless `@DataClassName('NoteEntry')`
  /// is specified on the `Notes` table!
  NotesLocalDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notesLocalDaoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notesLocalDaoHash();

  @$internal
  @override
  $ProviderElement<NotesLocalDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NotesLocalDao create(Ref ref) {
    return notesLocalDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotesLocalDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotesLocalDao>(value),
    );
  }
}

String _$notesLocalDaoHash() => r'e08976343622b949fe115e1ccea31f9f09050736';
