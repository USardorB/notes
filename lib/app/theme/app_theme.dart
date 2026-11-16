import 'package:flutter/material.dart';

abstract final class AppColors {
  /// Primary brand amber/orange (`#FFB347`) used across Splash, Buttons, and SVGs.
  static const Color primary = Color(0xFFFFB347);

  /// Light warm gray background (`#F1F1F1`) used on Onboarding & Auth screens.
  static const Color background = Color(0xFFF1F1F1);

  /// Soft peach/cream used in the menu gradient.
  static const Color menuGradientMid = Color(0xFFFDF3E1);

  /// Text primary dark color.
  static const Color textPrimary = Color(0xFF111111);
}

abstract final class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.background,
        brightness: Brightness.light,
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        brightness: Brightness.dark,
      ),
    );
  }
}
