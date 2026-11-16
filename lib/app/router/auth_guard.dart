import 'package:auto_route/auto_route.dart';
import 'package:notes/app/router/app_router.dart';
import 'package:notes/features/auth/data/auth_repository.dart';

/// ============================================================================
/// ARCHITECTURAL NOTE — Offline-Capable Route Guard & Deep Linking
/// ============================================================================
/// When a user taps a deep link (e.g., `notesapp://notes`), AutoRoute runs
/// this `AuthGuard` BEFORE pushing the screen:
/// 1. It checks local Drift SQLite (`_authRepository.getCurrentUser()`) in < 2ms.
/// 2. If a valid local session exists, `resolver.next(true)` proceeds directly
///    to the deep-linked screen—even when the phone is offline!
/// 3. If logged out, it redirects to `LoginRoute`.
class AuthGuard extends AutoRouteGuard {
  final AuthRepository _authRepository;

  const AuthGuard(this._authRepository);

  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final user = await _authRepository.getCurrentUser();
    if (user != null) {
      resolver.next(true);
    } else {
      await router.replaceAll([const LoginRoute()]);
    }
  }
}

