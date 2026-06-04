import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';

/// Visual variants for toast and offline bottom bars.
enum AppToastStyle { neutral, success, information, warning, error }

/// Theme-aware background and foreground colors for [AppToastBar].
abstract class AppToastColors {
  AppToastColors._();

  static Color background(AppToastStyle style, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    switch (style) {
      case AppToastStyle.neutral:
        return isDark ? AppColors.darkGrey : AppColors.grey;
      case AppToastStyle.success:
        return AppColors.success;
      case AppToastStyle.information:
        return AppColors.information;
      case AppToastStyle.warning:
        return AppColors.warning;
      case AppToastStyle.error:
        return AppColors.error;
    }
  }

  static Color foreground(AppToastStyle style, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    switch (style) {
      case AppToastStyle.neutral:
        return isDark ? AppColors.white : AppColors.black;
      case AppToastStyle.success:
      case AppToastStyle.information:
      case AppToastStyle.warning:
      case AppToastStyle.error:
        return AppColors.white;
    }
  }
}
