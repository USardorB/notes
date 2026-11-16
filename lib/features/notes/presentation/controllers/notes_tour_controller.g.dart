// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes_tour_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NotesTour)
final notesTourProvider = NotesTourProvider._();

final class NotesTourProvider
    extends $NotifierProvider<NotesTour, NotesTourStep> {
  NotesTourProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notesTourProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notesTourHash();

  @$internal
  @override
  NotesTour create() => NotesTour();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotesTourStep value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotesTourStep>(value),
    );
  }
}

String _$notesTourHash() => r'9220f98ab77b5bbdbaaceda337ced363ed426734';

abstract class _$NotesTour extends $Notifier<NotesTourStep> {
  NotesTourStep build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<NotesTourStep, NotesTourStep>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NotesTourStep, NotesTourStep>,
              NotesTourStep,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
