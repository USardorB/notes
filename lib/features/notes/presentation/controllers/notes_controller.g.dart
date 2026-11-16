// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(notesListStream)
final notesListStreamProvider = NotesListStreamProvider._();

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

final class NotesListStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Note>>,
          List<Note>,
          Stream<List<Note>>
        >
    with $FutureModifier<List<Note>>, $StreamProvider<List<Note>> {
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
  NotesListStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notesListStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notesListStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<Note>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Note>> create(Ref ref) {
    return notesListStream(ref);
  }
}

String _$notesListStreamHash() => r'e59ecfb720525baac96995858ef6949fff2cac58';

/// UI Controller for Note mutations (Create, Update, Delete).

@ProviderFor(NotesController)
final notesControllerProvider = NotesControllerProvider._();

/// UI Controller for Note mutations (Create, Update, Delete).
final class NotesControllerProvider
    extends $AsyncNotifierProvider<NotesController, void> {
  /// UI Controller for Note mutations (Create, Update, Delete).
  NotesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notesControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notesControllerHash();

  @$internal
  @override
  NotesController create() => NotesController();
}

String _$notesControllerHash() => r'0352674fdd14b00075d1cff0487d83dc4c6a943d';

/// UI Controller for Note mutations (Create, Update, Delete).

abstract class _$NotesController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
