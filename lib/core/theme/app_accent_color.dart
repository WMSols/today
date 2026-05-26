import 'package:flutter/material.dart';

/// User-selectable accent: one base color drives cards, nav, and buttons.
enum AppAccentColor {
  classic,
  lavendar;

  static const AppAccentColor defaultValue = AppAccentColor.classic;

  Color get color => switch (this) {
    AppAccentColor.classic => AppAccentColor._unused,
    AppAccentColor.lavendar => const Color(0xFF403EB3),
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
