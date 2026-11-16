import 'package:flutter/material.dart';
import 'package:notes/core/l10n/app_texts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale_controller.g.dart';

/// Shared navigator key used by `AppRouter` and `AppTexts` so localized strings
/// can resolve without passing `BuildContext` through UseCases or Repositories.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

enum AppLanguage {
  en(Locale('en'), 'English'),
  ru(Locale('ru'), 'Русский'),
  uz(Locale('uz'), "O'zbekcha"),
  tr(Locale('tr'), 'Türkçe'),
  ar(Locale('ar'), 'العربية'),
  pl(Locale('pl'), 'Polski'),
  de(Locale('de'), 'Deutsch');

  final Locale locale;
  final String label;

  const AppLanguage(this.locale, this.label);
}

@Riverpod(keepAlive: true)
class AppLocale extends _$AppLocale {
  @override
  AppLanguage build() {
    AppTexts.setLanguage(AppLanguage.en);
    return AppLanguage.en;
  }

  void setLanguage(AppLanguage language) {
    AppTexts.setLanguage(language);
    state = language;
  }
}
