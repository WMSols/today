import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';

class AppCountBadge extends StatelessWidget {
  const AppCountBadge({
    super.key,
    required this.iconPath,
    required this.count,
    this.horizontalFactor = 0.035,
    this.verticalFactor = 0.01,
    this.iconFactor = 0.8,
  });

  final String iconPath;
  final String count;
  final double horizontalFactor;
  final double verticalFactor;
  final double iconFactor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.symmetric(
        context,
        h: horizontalFactor,
        v: verticalFactor,
      ),
      decoration: BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, factor: 5),
        ),
      ),
      child: Row(
        children: [
          Image.asset(
            iconPath,
            width: AppResponsive.iconSize(context, factor: iconFactor),
            height: AppResponsive.iconSize(context, factor: iconFactor),
          ),
          AppSpacing.horizontal(context, 0.01),
          Text(
            count,
            style: AppTextStyles.bodyText(context).copyWith(
              color: AppColors.grey,
              fontWeight: FontWeight.w500,
              fontSize: AppResponsive.scaleSize(context, 14),
            ),
          ),
        ],
      ),
    );
  }
}
