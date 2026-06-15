import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/widgets/buttons/app_button.dart';

/// Reusable text button with optional leading or trailing icon.
class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.style,
    this.useAccentPalette = true,
    this.color,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final IconPosition iconPosition;
  final TextStyle? style;

  /// When false, uses neutral black/white link color instead of the accent.
  final bool useAccentPalette;

  /// Overrides the resolved link color for label and icon.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final linkColor = useAccentPalette
        ? context.accentPalette.buttonOutlinedForeground
        : (isDark ? AppColors.secondary : AppColors.primary);
    final textStyle = (style ?? AppTextStyles.bodyText(context)).copyWith(
      color: color ?? style?.color ?? linkColor,
    );
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null && iconPosition == IconPosition.left) ...[
          Icon(
            icon,
            size: AppResponsive.iconSize(context),
            color: textStyle.color,
          ),
          AppSpacing.horizontal(context, 0.01),
        ],
        Text(label, style: textStyle),
        if (icon != null && iconPosition == IconPosition.right) ...[
          AppSpacing.horizontal(context, 0.01),
          Icon(
            icon,
            size: AppResponsive.iconSize(context),
            color: textStyle.color,
          ),
        ],
      ],
    );
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: textStyle.color,
        padding: AppSpacing.symmetric(context, h: 0.014, v: 0.005),
      ),
      child: content,
    );
  }
}
