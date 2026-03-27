import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';

class HomeGoalItem extends StatelessWidget {
  const HomeGoalItem({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: AppSpacing.symmetric(context, v: 0.01, h: 0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.heading(context).copyWith(
                      color: AppColors.grey,
                      fontWeight: FontWeight.w600,
                      fontSize: AppResponsive.scaleSize(context, 14),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.labelText(context).copyWith(
                      color: AppColors.lightGrey,
                      fontWeight: FontWeight.w700,
                      fontSize: AppResponsive.scaleSize(context, 10),
                    ),
                  ),
                ],
              ),
            ),
            Image.asset(
              AppImages.medal3,
              width: AppResponsive.iconSize(context, factor: 1.2),
              height: AppResponsive.iconSize(context, factor: 1.2),
            ),
          ],
        ),
      ),
    );
  }
}
