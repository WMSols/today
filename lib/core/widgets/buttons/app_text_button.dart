import 'package:flutter/material.dart';

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
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final IconPosition iconPosition;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final textStyle =
        style ??
        AppTextStyles.bodyText(context).copyWith(color: AppColors.primary);
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
        padding: AppSpacing.symmetric(context, h: 0.02, v: 0.01),
      ),
      child: content,
    );
  }
}
