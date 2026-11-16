// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocr_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OcrController)
final ocrControllerProvider = OcrControllerProvider._();

final class OcrControllerProvider
    extends $NotifierProvider<OcrController, OcrState> {
  OcrControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ocrControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ocrControllerHash();

  @$internal
  @override
  OcrController create() => OcrController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OcrState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OcrState>(value),
    );
  }
}

String _$ocrControllerHash() => r'aa83d4e9d4ab446aab9d92066bc839fc4b97e820';

abstract class _$OcrController extends $Notifier<OcrState> {
  OcrState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<OcrState, OcrState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OcrState, OcrState>,
              OcrState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
