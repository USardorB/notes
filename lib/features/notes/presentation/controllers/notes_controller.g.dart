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
/// `notesListStreamProvider` watches `currentUserProvider` (Auth) and
/// `notesRepositoryProvider` (Notes). When the user signs in or switches
/// accounts, it automatically re-subscribes to that user's SQLite notes stream.

@ProviderFor(notesListStream)
final notesListStreamProvider = NotesListStreamProvider._();

/// ============================================================================
/// ARCHITECTURAL NOTE — Reactive Composition in Riverpod
/// ============================================================================
/// `notesListStreamProvider` watches `currentUserProvider` (Auth) and
/// `notesRepositoryProvider` (Notes). When the user signs in or switches
/// accounts, it automatically re-subscribes to that user's SQLite notes stream.

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
  /// `notesListStreamProvider` watches `currentUserProvider` (Auth) and
  /// `notesRepositoryProvider` (Notes). When the user signs in or switches
  /// accounts, it automatically re-subscribes to that user's SQLite notes stream.
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

/// Holds the active view mode (single-column list vs 2-column staggered grid).

@ProviderFor(NotesViewModeNotifier)
final notesViewModeProvider = NotesViewModeNotifierProvider._();

/// Holds the active view mode (single-column list vs 2-column staggered grid).
final class NotesViewModeNotifierProvider
    extends $NotifierProvider<NotesViewModeNotifier, NotesViewMode> {
  /// Holds the active view mode (single-column list vs 2-column staggered grid).
  NotesViewModeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notesViewModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notesViewModeNotifierHash();

  @$internal
  @override
  NotesViewModeNotifier create() => NotesViewModeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotesViewMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotesViewMode>(value),
    );
  }
}

String _$notesViewModeNotifierHash() =>
    r'a63795f928eaf55e36141bcac6beb9ca3f5160ce';

/// Holds the active view mode (single-column list vs 2-column staggered grid).

abstract class _$NotesViewModeNotifier extends $Notifier<NotesViewMode> {
  NotesViewMode build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<NotesViewMode, NotesViewMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NotesViewMode, NotesViewMode>,
              NotesViewMode,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Holds the selected color filter (`null` = show all notes).

@ProviderFor(NotesColorFilter)
final notesColorFilterProvider = NotesColorFilterProvider._();

/// Holds the selected color filter (`null` = show all notes).
final class NotesColorFilterProvider
    extends $NotifierProvider<NotesColorFilter, int?> {
  /// Holds the selected color filter (`null` = show all notes).
  NotesColorFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notesColorFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notesColorFilterHash();

  @$internal
  @override
  NotesColorFilter create() => NotesColorFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }
}

String _$notesColorFilterHash() => r'6eced2e893e6bebcc103e3fdb43ccd9f045ac4cc';

/// Holds the selected color filter (`null` = show all notes).

abstract class _$NotesColorFilter extends $Notifier<int?> {
  int? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int?, int?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int?, int?>,
              int?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Derived reactive provider: automatically filters `notesListStream` whenever
/// either Drift emits new notes OR the user taps a color in "Filter by colour".

@ProviderFor(filteredNotes)
final filteredNotesProvider = FilteredNotesProvider._();

/// Derived reactive provider: automatically filters `notesListStream` whenever
/// either Drift emits new notes OR the user taps a color in "Filter by colour".

final class FilteredNotesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Note>>,
          AsyncValue<List<Note>>,
          AsyncValue<List<Note>>
        >
    with $Provider<AsyncValue<List<Note>>> {
  /// Derived reactive provider: automatically filters `notesListStream` whenever
  /// either Drift emits new notes OR the user taps a color in "Filter by colour".
  FilteredNotesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredNotesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredNotesHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<Note>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<Note>> create(Ref ref) {
    return filteredNotes(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<Note>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<Note>>>(value),
    );
  }
}

String _$filteredNotesHash() => r'a33a8cd9d800d13f90b5376ce43f28e655f1901c';

/// UI Controller for Note mutations (Create, Update, Delete, Todo Toggle).

@ProviderFor(NotesController)
final notesControllerProvider = NotesControllerProvider._();

/// UI Controller for Note mutations (Create, Update, Delete, Todo Toggle).
final class NotesControllerProvider
    extends $AsyncNotifierProvider<NotesController, void> {
  /// UI Controller for Note mutations (Create, Update, Delete, Todo Toggle).
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

String _$notesControllerHash() => r'7a6a3229663a6e5b467464ca9bc025a3c8331af1';

/// UI Controller for Note mutations (Create, Update, Delete, Todo Toggle).

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
