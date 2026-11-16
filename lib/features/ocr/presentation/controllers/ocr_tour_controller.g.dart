// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocr_tour_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OcrTour)
final ocrTourProvider = OcrTourProvider._();

final class OcrTourProvider extends $NotifierProvider<OcrTour, OcrTourStep> {
  OcrTourProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ocrTourProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ocrTourHash();

  @$internal
  @override
  OcrTour create() => OcrTour();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OcrTourStep value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OcrTourStep>(value),
    );
  }
}

String _$ocrTourHash() => r'10c3db09a6123a501f42f782c34389f6efb9bada';

abstract class _$OcrTour extends $Notifier<OcrTourStep> {
  OcrTourStep build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<OcrTourStep, OcrTourStep>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OcrTourStep, OcrTourStep>,
              OcrTourStep,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
