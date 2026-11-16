// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ============================================================================
/// ARCHITECTURAL NOTE — Reactive HTTP Client & Token Injection
/// ============================================================================
/// In a traditional GetIt + SharedPreferences setup, an interceptor has to reach
/// into a global `SharedPreferences` instance to attach the Bearer token.
///
/// With Riverpod + Drift, our interceptor queries the local SQLite session
/// (or cached provider state) cleanly through Dependency Injection (`ref`).

@ProviderFor(dioClient)
final dioClientProvider = DioClientProvider._();

/// ============================================================================
/// ARCHITECTURAL NOTE — Reactive HTTP Client & Token Injection
/// ============================================================================
/// In a traditional GetIt + SharedPreferences setup, an interceptor has to reach
/// into a global `SharedPreferences` instance to attach the Bearer token.
///
/// With Riverpod + Drift, our interceptor queries the local SQLite session
/// (or cached provider state) cleanly through Dependency Injection (`ref`).

final class DioClientProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// ============================================================================
  /// ARCHITECTURAL NOTE — Reactive HTTP Client & Token Injection
  /// ============================================================================
  /// In a traditional GetIt + SharedPreferences setup, an interceptor has to reach
  /// into a global `SharedPreferences` instance to attach the Bearer token.
  ///
  /// With Riverpod + Drift, our interceptor queries the local SQLite session
  /// (or cached provider state) cleanly through Dependency Injection (`ref`).
  DioClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioClientHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dioClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioClientHash() => r'15f42f2c3ea17a5fc461a1c4f5c9b6c638611587';
