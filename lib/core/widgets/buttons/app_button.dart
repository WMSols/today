import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

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

  factory AppButtonColors.defaults(BuildContext context) {
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
    this.colors,
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

  /// When null, [AppButtonColors.defaults] is used.
  final AppButtonColors? colors;

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDisabled = !isLoading && onPressed == null;
    final effectivePrimary = primary && !isDisabled;

    final scheme = colors ?? AppButtonColors.defaults(context);

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
                style: AppTextStyles.buttonText(
                  context,
                ).copyWith(color: foregroundColor),
              ),
              AppSpacing.horizontal(context, 0.01),
              Lottie.asset(
                loadingLottie,
                width: AppResponsive.buttonLoaderSize(context),
                fit: BoxFit.contain,
              ),
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null && iconPosition == IconPosition.left) ...[
                Icon(
                  icon,
                  size: AppResponsive.iconSize(context),
                  color: iconColor,
                ),
                AppSpacing.horizontal(context, 0.01),
              ],
              Text(
                label,
                style: AppTextStyles.buttonText(
                  context,
                ).copyWith(color: foregroundColor),
              ),
              if (icon != null && iconPosition == IconPosition.right) ...[
                AppSpacing.horizontal(context, 0.01),
                Icon(
                  icon,
                  size: AppResponsive.iconSize(context),
                  color: iconColor,
                ),
              ],
            ],
          );

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(
        AppResponsive.radius(context, factor: 5),
      ),
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
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, factor: 5),
        ),
        child: AnimatedContainer(
          duration: _animationDuration,
          curve: Curves.easeOutCubic,
          padding: AppSpacing.symmetric(context, h: 0.04, v: 0.015),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(
              AppResponsive.radius(context, factor: 5),
            ),
            border: border,
          ),
          child: child,
        ),
      ),
    );
  }
}

enum IconPosition { left, right }
