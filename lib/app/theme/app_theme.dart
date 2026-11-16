import 'package:flutter/material.dart';

abstract final class AppColors {
  /// Primary brand amber/orange (`#FFB347`) used across Splash, Buttons, and SVGs.
  static const Color primary = Color(0xFFFFB347);

  /// Light warm gray background (`#F1F1F1`) used on Onboarding & Auth screens.
  static const Color background = Color(0xFFF1F1F1);

  /// Dark mode scaffold background.
  static const Color darkBackground = Color(0xFF141416);

  /// Dark mode elevated surface (cards, inputs, bottom nav).
  static const Color darkSurface = Color(0xFF1E1F23);
}

abstract final class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black,
        surfaceContainerLowest: Colors.white,
        surfaceContainerLow: Color(0xFFF7F7F7),
        surfaceContainer: AppColors.background,
        surfaceContainerHigh: Color(0xFFEDEDED),
        onSurfaceVariant: Colors.black54,
        outline: Colors.black87,
        outlineVariant: Color(0xFFD0D5DD),
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: Colors.black,
        surface: AppColors.darkBackground,
        onSurface: Color(0xFFF3F4F6),
        surfaceContainerLowest: Color(0xFF101012),
        surfaceContainerLow: Color(0xFF1A1B1E),
        surfaceContainer: AppColors.darkSurface,
        surfaceContainerHigh: Color(0xFF282A30),
        onSurfaceVariant: Color(0xFF9CA3AF),
        outline: Color(0xFF6B7280),
        outlineVariant: Color(0xFF374151),
      ),
    );
  }
}
