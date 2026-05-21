import 'package:flutter/material.dart';

/// User-selectable accent: one base color drives cards, nav, and buttons.
enum AppAccentColor {
  classic,
  brown,
  green,
  violet;

  static const AppAccentColor defaultValue = AppAccentColor.classic;

  Color get color => switch (this) {
    AppAccentColor.classic => AppAccentColor._unused,
    AppAccentColor.brown => const Color(0xFF431A00),
    AppAccentColor.green => const Color(0xFF1B6B4A),
    AppAccentColor.violet => const Color(0xFF5E33AF),
  };

  bool get isClassic => this == AppAccentColor.classic;

  /// Sentinel for [classic]; use [AppAccentPalette.resolve] instead.
  static const Color _unused = Color(0x00000000);

  static AppAccentColor? tryParse(String? raw) {
    if (raw == null) return null;
    for (final v in AppAccentColor.values) {
      if (v.name == raw) return v;
    }
    return null;
  }
}
