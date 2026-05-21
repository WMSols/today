import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/presentation/controllers/settings/haptics_controller.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_lotties/app_lotties.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';

/// Optional per-screen palette for [AppButton] filled vs outlined states.
///
/// [filled*] when [AppButton.primary] is true; [outlined*] when false.
class AppButtonColors {
  const AppButtonColors({
    required this.filledBackground,
    required this.filledForeground,
    required this.outlinedBackground,
    required this.outlinedForeground,
    required this.outlinedBorder,
  });

  final Color filledBackground;
  final Color filledForeground;
  final Color outlinedBackground;
  final Color outlinedForeground;
  final Color outlinedBorder;

  /// Accent-aware colors from settings. Set [useAccentPalette] to false on
  /// [AppButton] for neutral black/white styling instead.
  factory AppButtonColors.defaults(
    BuildContext context, {
    bool useAccentPalette = true,
  }) {
    if (!useAccentPalette) {
      return AppButtonColors.neutral(context);
    }
    final palette = context.accentPalette;
    return AppButtonColors(
      filledBackground: palette.buttonFilled,
      filledForeground: palette.buttonFilledForeground,
      outlinedBackground: Colors.transparent,
      outlinedForeground: palette.buttonOutlinedForeground,
      outlinedBorder: palette.buttonOutlinedBorder,
    );
  }

  /// Monochrome black/white button colors (ignores accent setting).
  factory AppButtonColors.neutral(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppButtonColors(
      filledBackground: isDark ? AppColors.secondary : AppColors.primary,
      filledForeground: isDark ? AppColors.primary : AppColors.secondary,
      outlinedBackground: Colors.transparent,
      outlinedForeground: isDark ? AppColors.secondary : AppColors.primary,
      outlinedBorder: isDark ? AppColors.secondary : AppColors.primary,
    );
  }
}

/// Visual scale for [AppButton]. [medium] matches the default layout.
enum AppButtonSize { small, medium, large }

class _AppButtonMetrics {
  const _AppButtonMetrics({
    required this.paddingHorizontal,
    required this.paddingVertical,
    required this.fontScale,
    required this.iconScale,
    required this.radiusFactor,
    required this.loaderScale,
  });

  final double paddingHorizontal;
  final double paddingVertical;
  final double fontScale;
  final double iconScale;
  final double radiusFactor;
  final double loaderScale;

  static _AppButtonMetrics forSize(AppButtonSize? size) {
    switch (size ?? AppButtonSize.medium) {
      case AppButtonSize.small:
        return const _AppButtonMetrics(
          paddingHorizontal: 0.02,
          paddingVertical: 0.005,
          fontScale: 0.8,
          iconScale: 0.8,
          radiusFactor: 2,
          loaderScale: 0.8,
        );
      case AppButtonSize.medium:
        return const _AppButtonMetrics(
          paddingHorizontal: 0.04,
          paddingVertical: 0.015,
          fontScale: 1,
          iconScale: 1,
          radiusFactor: 5,
          loaderScale: 1,
        );
      case AppButtonSize.large:
        return const _AppButtonMetrics(
          paddingHorizontal: 0.05,
          paddingVertical: 0.02,
          fontScale: 1.08,
          iconScale: 1.08,
          radiusFactor: 5,
          loaderScale: 1.08,
        );
    }
  }
}

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.primary = true,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.loadingLabel,
    this.useHapticFeedback = true,
    this.useAccentPalette = true,
    this.colors,
    this.size,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool primary;
  final IconData? icon;
  final IconPosition iconPosition;

  /// Shown next to the loading Lottie when [isLoading] is true. If null, derived from [label] (e.g. "Login" → "Logging In").
  final String? loadingLabel;

  /// Light impact on tap when [HapticsController] is registered and enabled.
  final bool useHapticFeedback;

  /// When false, uses neutral black/white colors instead of the accent palette.
  final bool useAccentPalette;

  /// When null, [AppButtonColors.defaults] or [AppButtonColors.neutral] is used.
  final AppButtonColors? colors;

  /// When null, [AppButtonSize.medium] is used.
  final AppButtonSize? size;

  static const _animationDuration = Duration(milliseconds: 220);

  static String _defaultLoadingLabel(String label) {
    switch (label) {
      case AppTexts.login:
        return AppTexts.loggingIn;
      case AppTexts.submit:
        return AppTexts.submitting;
      default:
        return AppTexts.loading;
    }
  }

  static String _lottieForContrast(Color reference) {
    final brightness = ThemeData.estimateBrightnessForColor(reference);
    return brightness == Brightness.dark
        ? AppLotties.loadingWhite
        : AppLotties.loadingBlack;
  }

  @override
  Widget build(BuildContext context) {
    final metrics = _AppButtonMetrics.forSize(size);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDisabled = !isLoading && onPressed == null;
    final effectivePrimary = primary && !isDisabled;
    final baseButtonTextStyle = AppTextStyles.buttonText(context);
    final buttonTextStyle = baseButtonTextStyle.copyWith(
      fontSize: (baseButtonTextStyle.fontSize ?? 14) * metrics.fontScale,
    );
    final iconSize = AppResponsive.iconSize(context, factor: metrics.iconScale);
    final borderRadius = AppResponsive.radius(
      context,
      factor: metrics.radiusFactor,
    );

    final scheme =
        colors ??
        AppButtonColors.defaults(context, useAccentPalette: useAccentPalette);

    final Color backgroundColor;
    final Color foregroundColor;
    final BoxBorder? border;

    if (isDisabled) {
      backgroundColor = isDark ? AppColors.darkGrey : AppColors.grey;
      foregroundColor = AppColors.grey;
      border = null;
    } else if (effectivePrimary) {
      backgroundColor = scheme.filledBackground;
      foregroundColor = scheme.filledForeground;
      border = null;
    } else {
      backgroundColor = scheme.outlinedBackground;
      foregroundColor = scheme.outlinedForeground;
      border = Border.all(color: scheme.outlinedBorder);
    }

    final iconColor = foregroundColor;

    final String loadingLottie = effectivePrimary
        ? _lottieForContrast(scheme.filledBackground)
        : _lottieForContrast(scheme.outlinedForeground);

    final child = isLoading
        ? Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                loadingLabel ?? _defaultLoadingLabel(label),
                style: buttonTextStyle.copyWith(color: foregroundColor),
              ),
              AppSpacing.horizontal(context, 0.01),
              Lottie.asset(
                loadingLottie,
                width: AppResponsive.buttonLoaderSize(
                  context,
                  factor: metrics.loaderScale,
                ),
                fit: BoxFit.contain,
              ),
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null && iconPosition == IconPosition.left) ...[
                Icon(icon, size: iconSize, color: iconColor),
                AppSpacing.horizontal(context, 0.01),
              ],
              Text(
                label,
                style: buttonTextStyle.copyWith(color: foregroundColor),
              ),
              if (icon != null && iconPosition == IconPosition.right) ...[
                AppSpacing.horizontal(context, 0.01),
                Icon(icon, size: iconSize, color: iconColor),
              ],
            ],
          );

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: isLoading
            ? null
            : onPressed == null
            ? null
            : () {
                if (useHapticFeedback) {
                  if (Get.isRegistered<HapticsController>()) {
                    Get.find<HapticsController>().impact();
                  }
                }
                onPressed!();
              },
        borderRadius: BorderRadius.circular(borderRadius),
        child: AnimatedContainer(
          duration: _animationDuration,
          curve: Curves.easeOutCubic,
          padding: AppSpacing.symmetric(
            context,
            h: metrics.paddingHorizontal,
            v: metrics.paddingVertical,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: border,
          ),
          child: child,
        ),
      ),
    );
  }
}

enum IconPosition { left, right }
