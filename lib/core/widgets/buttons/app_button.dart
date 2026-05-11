import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_lotties/app_lotties.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';

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
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool primary;
  final IconData? icon;
  final IconPosition iconPosition;

  /// Shown next to the loading Lottie when [isLoading] is true. If null, derived from [label] (e.g. "Login" → "Logging In").
  final String? loadingLabel;
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDisabled = !isLoading && onPressed == null;
    final effectivePrimary = primary && !isDisabled;

    final Color primaryBg = isDark ? AppColors.secondary : AppColors.primary;
    final Color primaryFg = isDark ? AppColors.primary : AppColors.secondary;
    final Color secondaryBg = isDark ? AppColors.black : AppColors.secondary;
    final Color secondaryFg = isDark ? AppColors.white : AppColors.primary;
    final Color secondaryBorder = isDark ? AppColors.white : AppColors.primary;

    final textColor = isDisabled
        ? AppColors.grey
        : (effectivePrimary ? primaryFg : secondaryFg);
    final iconColor = textColor;

    final String loadingLottie = effectivePrimary
        ? (isDark ? AppLotties.loadingBlack : AppLotties.loadingWhite)
        : (isDark ? AppLotties.loadingWhite : AppLotties.loadingBlack);

    final child = isLoading
        ? Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                loadingLabel ?? _defaultLoadingLabel(label),
                style: AppTextStyles.buttonText(
                  context,
                ).copyWith(color: effectivePrimary ? primaryFg : secondaryFg),
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
                ).copyWith(color: textColor),
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

    final backgroundColor = isDisabled
        ? (isDark ? AppColors.darkGrey : AppColors.grey)
        : (effectivePrimary ? primaryBg : secondaryBg);
    final border = isDisabled
        ? null
        : (effectivePrimary
              ? null
              : Border.all(color: secondaryBorder.withValues(alpha: 0.85)));

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(
        AppResponsive.radius(context, factor: 5),
      ),
      child: InkWell(
        onTap: isLoading ? null : onPressed,
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
