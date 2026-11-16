// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_note_usecase.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(saveNoteUseCase)
final saveNoteUseCaseProvider = SaveNoteUseCaseProvider._();

final class SaveNoteUseCaseProvider
    extends
        $FunctionalProvider<SaveNoteUseCase, SaveNoteUseCase, SaveNoteUseCase>
    with $Provider<SaveNoteUseCase> {
  SaveNoteUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'saveNoteUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$saveNoteUseCaseHash();

  @$internal
  @override
  $ProviderElement<SaveNoteUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SaveNoteUseCase create(Ref ref) {
    return saveNoteUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SaveNoteUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SaveNoteUseCase>(value),
    );
  }
}

String _$saveNoteUseCaseHash() => r'86cba1a90b6e9be1218c6dcd5d92a33f7ffc14b1';
