import 'package:flutter/material.dart';

import 'package:today/core/theme/app_accent_color.dart';
import 'package:today/core/theme/app_accent_palette.dart';
import 'package:today/core/theme/app_accent_theme_extension.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';

extension ThemeContextExtension on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  AppAccentPalette get accentPalette {
    final extension = Theme.of(this).extension<AppAccentThemeExtension>();
    if (extension != null) return extension.palette;
    return AppAccentPalette.resolve(
      AppAccentColor.classic,
      Theme.of(this).brightness,
    );
  }

  Color get surfaceColor => isDarkMode ? AppColors.black : AppColors.white;

  Color get onSurfaceColor => isDarkMode ? AppColors.white : AppColors.black;

  Color get sectionCardColor => accentPalette.sectionCard;

  Color get onSectionCardColor => accentPalette.onSectionCard;

  Color get mutedOnSurfaceColor =>
      isDarkMode ? AppColors.lightGrey : AppColors.grey;
}
