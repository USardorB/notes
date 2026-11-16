import 'package:auto_route/auto_route.dart';
import 'package:notes/app/router/auth_guard.dart';
import 'package:notes/features/auth/data/auth_repository.dart';
import 'package:notes/features/auth/presentation/screens/login_screen.dart';
import 'package:notes/features/notes/presentation/screens/notes_list_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.gr.dart';
part 'app_router.g.dart';

/// ============================================================================
/// ARCHITECTURAL NOTE — Declarative Router & Deep-Linking Foundation
/// ============================================================================
/// Notice how each `AutoRoute` specifies an explicit `path`:
///   - `/login`
///   - `/notes`
/// When you enable Deep Linking on iOS (Universal Links) / Android (App Links),
/// AutoRoute automatically matches incoming URLs against these `path` patterns
/// and runs the `AuthGuard` before rendering the target screen.
@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  final AuthGuard authGuard;

  AppRouter({required this.authGuard});

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: LoginRoute.page,
          path: '/login',
        ),
        AutoRoute(
          page: NotesListRoute.page,
          path: '/notes',
          initial: true,
          guards: [authGuard],
        ),
      ];
}

@Riverpod(keepAlive: true)
AppRouter appRouter(Ref ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return AppRouter(authGuard: AuthGuard(authRepo));
}

