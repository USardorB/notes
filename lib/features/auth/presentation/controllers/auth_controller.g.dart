// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ============================================================================
/// ARCHITECTURAL NOTE — From Bloc to Riverpod (Queries vs Commands)
/// ============================================================================
/// We separate:
///   1. **The Reactive Data Stream (`currentUserProvider`)**: Watches Drift SQLite
///      directly. Whenever the `AuthSessions` table changes (including when a
///      local account transitions from `pendingCreate` -> `synced`), every
///      listener in the app automatically rebuilds!
///   2. **The Action Controller (`AuthController`)**: Tracks the lifecycle of user
///      button clicks (`signIn`, `signUp`, `resetPassword`, `syncAndSignOut`,
///      `signOut`) using `AsyncValue<void>`.

@ProviderFor(currentUser)
final currentUserProvider = CurrentUserProvider._();

/// ============================================================================
/// ARCHITECTURAL NOTE — From Bloc to Riverpod (Queries vs Commands)
/// ============================================================================
/// We separate:
///   1. **The Reactive Data Stream (`currentUserProvider`)**: Watches Drift SQLite
///      directly. Whenever the `AuthSessions` table changes (including when a
///      local account transitions from `pendingCreate` -> `synced`), every
///      listener in the app automatically rebuilds!
///   2. **The Action Controller (`AuthController`)**: Tracks the lifecycle of user
///      button clicks (`signIn`, `signUp`, `resetPassword`, `syncAndSignOut`,
///      `signOut`) using `AsyncValue<void>`.

final class CurrentUserProvider
    extends
        $FunctionalProvider<AsyncValue<AuthUser?>, AuthUser?, Stream<AuthUser?>>
    with $FutureModifier<AuthUser?>, $StreamProvider<AuthUser?> {
  /// ============================================================================
  /// ARCHITECTURAL NOTE — From Bloc to Riverpod (Queries vs Commands)
  /// ============================================================================
  /// We separate:
  ///   1. **The Reactive Data Stream (`currentUserProvider`)**: Watches Drift SQLite
  ///      directly. Whenever the `AuthSessions` table changes (including when a
  ///      local account transitions from `pendingCreate` -> `synced`), every
  ///      listener in the app automatically rebuilds!
  ///   2. **The Action Controller (`AuthController`)**: Tracks the lifecycle of user
  ///      button clicks (`signIn`, `signUp`, `resetPassword`, `syncAndSignOut`,
  ///      `signOut`) using `AsyncValue<void>`.
  CurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  $StreamProviderElement<AuthUser?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<AuthUser?> create(Ref ref) {
    return currentUser(ref);
  }
}

String _$currentUserHash() => r'9c24480a388a978a5702ecc0123186d46bb075d7';

/// UI Controller for authentication mutations.

@ProviderFor(AuthController)
final authControllerProvider = AuthControllerProvider._();

/// UI Controller for authentication mutations.
final class AuthControllerProvider
    extends $AsyncNotifierProvider<AuthController, void> {
  /// UI Controller for authentication mutations.
  AuthControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authControllerHash();

  @$internal
  @override
  AuthController create() => AuthController();
}

String _$authControllerHash() => r'e6aa313d4268e49dadf7de6c2c73421651ec8fe9';

/// UI Controller for authentication mutations.

abstract class _$AuthController extends $AsyncNotifier<void> {
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
