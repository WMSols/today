import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:today/core/theme/app_accent_color.dart';
import 'package:today/core/theme/app_accent_palette.dart';
import 'package:today/core/theme/app_accent_theme_extension.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_fonts/app_fonts.dart';

/// Light/dark [ThemeData] with optional single-color accent via [AppAccentColor].
abstract final class AppTheme {
  static ThemeData light([AppAccentColor accent = AppAccentColor.classic]) {
    return _build(Brightness.light, accent);
  }

  static ThemeData dark([AppAccentColor accent = AppAccentColor.classic]) {
    return _build(Brightness.dark, accent);
  }

  static ThemeData _build(Brightness brightness, AppAccentColor accent) {
    final isDark = brightness == Brightness.dark;
    final palette = AppAccentPalette.resolve(accent, brightness);
    final surface = isDark ? AppColors.black : AppColors.white;
    final onSurface = isDark ? AppColors.white : AppColors.black;
    final schemePrimary = accent.isClassic
        ? (isDark ? AppColors.secondary : AppColors.primary)
        : palette.accent;
    final schemeOnPrimary = accent.isClassic
        ? (isDark ? AppColors.primary : AppColors.secondary)
        : palette.buttonFilledForeground;

    final scheme = ColorScheme(
      brightness: brightness,
      primary: schemePrimary,
      onPrimary: schemeOnPrimary,
      secondary: isDark ? AppColors.primary : AppColors.secondary,
      onSecondary: isDark ? AppColors.secondary : AppColors.primary,
      tertiary: AppColors.grey,
      onTertiary: AppColors.black,
      error: AppColors.error,
      onError: AppColors.secondary,
      surface: surface,
      onSurface: onSurface,
      onSurfaceVariant: AppColors.grey,
      outline: isDark ? AppColors.lightGrey : AppColors.grey,
      shadow: AppColors.black,
      scrim: AppColors.black,
      inverseSurface: isDark ? AppColors.white : AppColors.black,
      onInverseSurface: isDark ? AppColors.black : AppColors.white,
      inversePrimary: isDark ? AppColors.primary : AppColors.secondary,
      surfaceTint: palette.accent,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: surface,
      primaryColor: scheme.primary,
      canvasColor: surface,
      dividerColor: isDark ? AppColors.lightGrey : AppColors.grey,
      hintColor: AppColors.grey,
      extensions: [AppAccentThemeExtension.forAccent(accent, brightness)],
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: onSurface, fontFamily: AppFonts.mainFont),
        bodyMedium: TextStyle(color: onSurface, fontFamily: AppFonts.mainFont),
        titleLarge: TextStyle(color: onSurface, fontFamily: AppFonts.mainFont),
      ),
      splashFactory: InkRipple.splashFactory,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: surface,
        foregroundColor: onSurface,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: onSurface,
        unselectedItemColor: AppColors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? AppColors.lightGrey : AppColors.grey,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: TextStyle(color: AppColors.grey),
        labelStyle: TextStyle(color: AppColors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.lightGrey : AppColors.grey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.lightGrey : AppColors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: onSurface, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return onSurface;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStatePropertyAll(surface),
        side: BorderSide(color: onSurface, width: 1.5),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: schemePrimary,
        circularTrackColor: isDark
            ? AppColors.lightGrey.withValues(alpha: 0.35)
            : AppColors.grey.withValues(alpha: 0.35),
      ),
    );
  }
}
