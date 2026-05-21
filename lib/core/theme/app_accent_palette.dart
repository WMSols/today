import 'package:flutter/material.dart';

import 'package:today/core/theme/app_accent_color.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';

/// Resolved accent tokens for cards, navigation, and buttons.
class AppAccentPalette {
  const AppAccentPalette({
    required this.accent,
    required this.sectionCard,
    required this.onSectionCard,
    required this.navBar,
    required this.navBubble,
    required this.onNavBar,
    required this.buttonFilled,
    required this.buttonFilledForeground,
    required this.buttonOutlinedForeground,
    required this.buttonOutlinedBorder,
    required this.fabBackground,
    required this.fabMenuSurface,
    required this.fabMenuForeground,
    required this.fabMenuBorder,
  });

  final Color accent;
  final Color sectionCard;
  final Color onSectionCard;
  final Color navBar;
  final Color navBubble;
  final Color onNavBar;
  final Color buttonFilled;
  final Color buttonFilledForeground;
  final Color buttonOutlinedForeground;
  final Color buttonOutlinedBorder;
  final Color fabBackground;
  final Color fabMenuSurface;
  final Color fabMenuForeground;
  final Color fabMenuBorder;

  factory AppAccentPalette.resolve(
    AppAccentColor accent,
    Brightness brightness,
  ) {
    if (accent.isClassic) {
      return _classic(brightness);
    }
    return _fromBase(accent.color, brightness);
  }

  static AppAccentPalette _classic(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final filledBg = isDark ? AppColors.secondary : AppColors.primary;
    final filledFg = isDark ? AppColors.primary : AppColors.secondary;
    final navBar = isDark ? AppColors.lightGrey : AppColors.black;
    final navBubble = isDark ? AppColors.black : AppColors.lightGrey;

    return AppAccentPalette(
      accent: filledBg,
      sectionCard: navBar,
      onSectionCard: AppColors.white,
      navBar: navBar,
      navBubble: navBubble,
      onNavBar: AppColors.white,
      buttonFilled: filledBg,
      buttonFilledForeground: filledFg,
      buttonOutlinedForeground: filledFg,
      buttonOutlinedBorder: filledFg,
      fabBackground: navBar,
      fabMenuSurface: navBar,
      fabMenuForeground: AppColors.white,
      fabMenuBorder: isDark ? AppColors.lightGrey : AppColors.grey,
    );
  }

  static AppAccentPalette _fromBase(Color base, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final onAccent = _onAccent(base);

    final sectionCard = isDark ? _shade(base, 0.18) : base;
    final navBubble = isDark ? _tint(base, 0.22) : _tint(base, 0.28);
    final fabMenuSurface = isDark ? _shade(base, 0.12) : _shade(base, 0.08);

    return AppAccentPalette(
      accent: base,
      sectionCard: sectionCard,
      onSectionCard: onAccent,
      navBar: sectionCard,
      navBubble: navBubble,
      onNavBar: onAccent,
      buttonFilled: base,
      buttonFilledForeground: onAccent,
      buttonOutlinedForeground: base,
      buttonOutlinedBorder: base,
      fabBackground: base,
      fabMenuSurface: fabMenuSurface,
      fabMenuForeground: onAccent,
      fabMenuBorder: isDark
          ? _tint(base, 0.35).withValues(alpha: 0.6)
          : _shade(base, 0.15).withValues(alpha: 0.5),
    );
  }

  static Color _onAccent(Color color) =>
      color.computeLuminance() > 0.45 ? AppColors.black : AppColors.white;

  static Color _shade(Color color, double amount) =>
      Color.lerp(color, AppColors.black, amount.clamp(0.0, 1.0))!;

  static Color _tint(Color color, double amount) =>
      Color.lerp(color, AppColors.white, amount.clamp(0.0, 1.0))!;
}
