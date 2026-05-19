import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';

extension ThemeContextExtension on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Color get surfaceColor => isDarkMode ? AppColors.black : AppColors.white;

  Color get onSurfaceColor => isDarkMode ? AppColors.white : AppColors.black;

  Color get sectionCardColor =>
      isDarkMode ? AppColors.lightGrey : AppColors.black;

  Color get mutedOnSurfaceColor =>
      isDarkMode ? AppColors.lightGrey : AppColors.grey;
}
