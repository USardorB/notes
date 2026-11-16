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
/// Coming from Bloc, you are used to packing everything into a single `AuthBloc`
/// with `AuthInitial`, `AuthLoading`, `AuthAuthenticated`, `AuthError`.
///
/// THE PROBLEM WITH SINGLE-STATE BLOCS:
/// When the user is already logged in (or logging in) and an action fails,
/// emitting `AuthError` often wipes out the current data state unless you
/// manually copy fields across states.
///
/// HOW RIVERPOD SOLVES THIS CLEANLY:
/// We separate:
///   1. **The Reactive Data Stream (`currentUserProvider`)**: Watches Drift SQLite
///      directly. Whenever the `AuthSessions` table changes, every listener in
///      the app automatically rebuilds!
///   2. **The Action Controller (`AuthController`)**: Tracks the lifecycle of user
///      button clicks (`signIn`, `signUp`, `resetPassword`, `signOut`) using
///      `AsyncValue<void>` (`AsyncLoading`, `AsyncData`, `AsyncError`).

@ProviderFor(currentUser)
final currentUserProvider = CurrentUserProvider._();

/// ============================================================================
/// ARCHITECTURAL NOTE — From Bloc to Riverpod (Queries vs Commands)
/// ============================================================================
/// Coming from Bloc, you are used to packing everything into a single `AuthBloc`
/// with `AuthInitial`, `AuthLoading`, `AuthAuthenticated`, `AuthError`.
///
/// THE PROBLEM WITH SINGLE-STATE BLOCS:
/// When the user is already logged in (or logging in) and an action fails,
/// emitting `AuthError` often wipes out the current data state unless you
/// manually copy fields across states.
///
/// HOW RIVERPOD SOLVES THIS CLEANLY:
/// We separate:
///   1. **The Reactive Data Stream (`currentUserProvider`)**: Watches Drift SQLite
///      directly. Whenever the `AuthSessions` table changes, every listener in
///      the app automatically rebuilds!
///   2. **The Action Controller (`AuthController`)**: Tracks the lifecycle of user
///      button clicks (`signIn`, `signUp`, `resetPassword`, `signOut`) using
///      `AsyncValue<void>` (`AsyncLoading`, `AsyncData`, `AsyncError`).

final class CurrentUserProvider
    extends
        $FunctionalProvider<AsyncValue<AuthUser?>, AuthUser?, Stream<AuthUser?>>
    with $FutureModifier<AuthUser?>, $StreamProvider<AuthUser?> {
  /// ============================================================================
  /// ARCHITECTURAL NOTE — From Bloc to Riverpod (Queries vs Commands)
  /// ============================================================================
  /// Coming from Bloc, you are used to packing everything into a single `AuthBloc`
  /// with `AuthInitial`, `AuthLoading`, `AuthAuthenticated`, `AuthError`.
  ///
  /// THE PROBLEM WITH SINGLE-STATE BLOCS:
  /// When the user is already logged in (or logging in) and an action fails,
  /// emitting `AuthError` often wipes out the current data state unless you
  /// manually copy fields across states.
  ///
  /// HOW RIVERPOD SOLVES THIS CLEANLY:
  /// We separate:
  ///   1. **The Reactive Data Stream (`currentUserProvider`)**: Watches Drift SQLite
  ///      directly. Whenever the `AuthSessions` table changes, every listener in
  ///      the app automatically rebuilds!
  ///   2. **The Action Controller (`AuthController`)**: Tracks the lifecycle of user
  ///      button clicks (`signIn`, `signUp`, `resetPassword`, `signOut`) using
  ///      `AsyncValue<void>` (`AsyncLoading`, `AsyncData`, `AsyncError`).
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

/// UI Controller for authentication mutations (Sign In / Sign Up / Reset / Sign Out).

@ProviderFor(AuthController)
final authControllerProvider = AuthControllerProvider._();

/// UI Controller for authentication mutations (Sign In / Sign Up / Reset / Sign Out).
final class AuthControllerProvider
    extends $AsyncNotifierProvider<AuthController, void> {
  /// UI Controller for authentication mutations (Sign In / Sign Up / Reset / Sign Out).
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

String _$authControllerHash() => r'de0f57714c603faca091b8c2b66f01c0e377a205';

/// UI Controller for authentication mutations (Sign In / Sign Up / Reset / Sign Out).

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
