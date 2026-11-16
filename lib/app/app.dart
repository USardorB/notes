import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notes/app/router/app_router.dart';
import 'package:notes/app/theme/app_theme.dart';
import 'package:notes/app/theme/theme_controller.dart';
import 'package:notes/core/l10n/generated/app_localizations.dart';
import 'package:notes/core/l10n/locale_controller.dart';

class NotesApp extends ConsumerWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(appRouterProvider);
    final themeMode = ref.watch(appThemeModeProvider);
    final appLanguage = ref.watch(appLocaleProvider);

    return MaterialApp.router(
      title: 'HaBIT Note',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: appLanguage.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: appRouter.config(
        deepLinkTransformer: (uri) async {
          if (uri.scheme == 'habitnote') {
            final normalizedPath = uri.host.isEmpty
                ? uri.path
                : '/${uri.host}${uri.path}';
            return Uri(
              path: normalizedPath.isEmpty ? '/notes' : normalizedPath,
              queryParameters:
                  uri.queryParameters.isEmpty ? null : uri.queryParameters,
            );
          }
          return uri;
        },
      ),
    );
  }
}
