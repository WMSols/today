import 'package:flutter/material.dart';

/// App palette. Use with [Theme.of(context).brightness] for light/dark UI, e.g.
/// `final isDark = Theme.of(context).brightness == Brightness.dark;`
/// `color: isDark ? AppColors.white : AppColors.black`.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF000000);
  static const Color secondary = Color(0xFFFFFFFF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color darkGrey = Color(0xFF1A1A1A);
  static Color lightGrey = white.withValues(alpha: 0.3);
  static const Color success = Color(0xFF4CAF50);
  static const Color information = Color(0xFF2196F3);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
}
