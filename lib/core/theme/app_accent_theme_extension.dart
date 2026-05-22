import 'package:flutter/material.dart';

import 'package:today/core/theme/app_accent_color.dart';
import 'package:today/core/theme/app_accent_palette.dart';

/// [ThemeData] extension for the active single-color accent palette.
class AppAccentThemeExtension extends ThemeExtension<AppAccentThemeExtension> {
  const AppAccentThemeExtension({required this.accent, required this.palette});

  final AppAccentColor accent;
  final AppAccentPalette palette;

  factory AppAccentThemeExtension.forAccent(
    AppAccentColor accent,
    Brightness brightness,
  ) {
    return AppAccentThemeExtension(
      accent: accent,
      palette: AppAccentPalette.resolve(accent, brightness),
    );
  }

  @override
  AppAccentThemeExtension copyWith({
    AppAccentColor? accent,
    AppAccentPalette? palette,
  }) {
    return AppAccentThemeExtension(
      accent: accent ?? this.accent,
      palette: palette ?? this.palette,
    );
  }

  @override
  AppAccentThemeExtension lerp(
    covariant AppAccentThemeExtension? other,
    double t,
  ) {
    if (other == null) return this;
    return t < 0.5 ? this : other;
  }
}
