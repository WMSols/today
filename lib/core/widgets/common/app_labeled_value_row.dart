import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';

class AppLabeledValueRow extends StatelessWidget {
  const AppLabeledValueRow({
    super.key,
    required this.iconPath,
    required this.label,
    required this.value,
    this.iconSizeFactor = 0.8,
  });

  final String iconPath;
  final String label;
  final String value;
  final double iconSizeFactor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          iconPath,
          width: AppResponsive.iconSize(context, factor: iconSizeFactor),
          height: AppResponsive.iconSize(context, factor: iconSizeFactor),
        ),
        AppSpacing.horizontal(context, 0.02),
        Text(
          label,
          style: AppTextStyles.bodyText(context).copyWith(
            color: AppColors.grey,
            fontWeight: FontWeight.w600,
            fontSize: AppResponsive.scaleSize(context, 14),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: AppTextStyles.bodyText(context).copyWith(
            color: AppColors.grey,
            fontWeight: FontWeight.w600,
            fontSize: AppResponsive.scaleSize(context, 14),
          ),
        ),
      ],
    );
  }
}
