import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';

/// Signed percentage-point change with directional arrow.
class AppTrendBadge extends StatelessWidget {
  const AppTrendBadge({
    super.key,
    required this.label,
    required this.isUp,
    required this.isDown,
  });

  final String label;
  final bool isUp;
  final bool isDown;

  @override
  Widget build(BuildContext context) {
    final Color accent;
    final IconData icon;
    if (isUp) {
      accent = AppColors.white;
      icon = Icons.arrow_upward_rounded;
    } else if (isDown) {
      accent = AppColors.white;
      icon = Icons.arrow_downward_rounded;
    } else {
      accent = AppColors.white;
      icon = Icons.remove_rounded;
    }

    final fontSize = AppResponsive.scaleSize(context, 14);
    final labelStyle = AppTextStyles.labelText(context).copyWith(
      color: accent,
      fontWeight: FontWeight.w600,
      fontSize: fontSize,
      height: 1,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: fontSize, color: accent),
        AppSpacing.horizontal(context, 0.005),
        Text(label, style: labelStyle),
      ],
    );
  }
}
