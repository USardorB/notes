import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:notes/app/router/auth_guard.dart';
import 'package:notes/app/shell/main_shell_screen.dart';
import 'package:notes/core/l10n/locale_controller.dart';
import 'package:notes/features/auth/data/auth_repository.dart';
import 'package:notes/features/auth/presentation/screens/create_account_screen.dart';
import 'package:notes/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:notes/features/auth/presentation/screens/login_screen.dart';
import 'package:notes/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:notes/features/auth/presentation/screens/splash_screen.dart';
import 'package:notes/features/notes/domain/note.dart';
import 'package:notes/features/notes/presentation/screens/note_editor_screen.dart';
import 'package:notes/features/notes/presentation/screens/todo_editor_screen.dart';
import 'package:notes/features/profile/presentation/screens/about_screen.dart';
import 'package:notes/features/profile/presentation/screens/legal_document_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.gr.dart';
part 'app_router.g.dart';

/// ============================================================================
/// ARCHITECTURAL NOTE — Declarative Router & Deep-Linking Foundation
/// ============================================================================
/// Notice how each `AutoRoute` specifies an explicit `path`:
///   - `/splash`
///   - `/onboarding`
///   - `/login`
///   - `/create-account`
///   - `/forgot-password`
///   - `/notes`
///   - `/notes/edit`
///   - `/todos/edit`
/// When you enable Deep Linking on iOS (Universal Links) / Android (App Links),
/// AutoRoute automatically matches incoming URLs against these `path` patterns
/// and runs the `AuthGuard` before rendering the target screen.
@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  final AuthGuard authGuard;

  AppRouter({required this.authGuard}) : super(navigatorKey: rootNavigatorKey);

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: SplashRoute.page,
          path: '/splash',
          initial: true,
        ),
        AutoRoute(
          page: OnboardingRoute.page,
          path: '/onboarding',
        ),
        AutoRoute(
          page: LoginRoute.page,
          path: '/login',
        ),
        AutoRoute(
          page: CreateAccountRoute.page,
          path: '/create-account',
        ),
        AutoRoute(
          page: ForgotPasswordRoute.page,
          path: '/forgot-password',
        ),
        AutoRoute(
          page: AboutRoute.page,
          path: '/about',
        ),
        AutoRoute(
          page: LegalDocumentRoute.page,
          path: '/legal',
        ),
        AutoRoute(
          page: MainShellRoute.page,
          path: '/notes',
          guards: [authGuard],
        ),
        AutoRoute(
          page: NoteEditorRoute.page,
          path: '/notes/edit',
          guards: [authGuard],
        ),
        AutoRoute(
          page: TodoEditorRoute.page,
          path: '/todos/edit',
          guards: [authGuard],
        ),
      ];
}

@Riverpod(keepAlive: true)
AppRouter appRouter(Ref ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return AppRouter(authGuard: AuthGuard(authRepo));
}
