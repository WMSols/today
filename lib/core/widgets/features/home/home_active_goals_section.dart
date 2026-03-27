import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/widgets/features/home/home_goal_item.dart';

class HomeActiveGoalsSection extends StatelessWidget {
  const HomeActiveGoalsSection({super.key, this.onGoalTap});

  final VoidCallback? onGoalTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              AppImages.streak,
              width: AppResponsive.iconSize(context, factor: 0.8),
              height: AppResponsive.iconSize(context, factor: 0.8),
            ),
            AppSpacing.horizontal(context, 0.01),
            Text(
              'ACTIVE GOALS',
              style: AppTextStyles.bodyText(context).copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
                fontSize: AppResponsive.scaleSize(context, 10),
              ),
            ),
          ],
        ),
        AppSpacing.vertical(context, 0.01),
        Container(
          width: double.infinity,
          padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
          decoration: BoxDecoration(
            color: AppColors.darkGrey,
            borderRadius: BorderRadius.circular(
              AppResponsive.radius(context, factor: 5),
            ),
          ),
          child: Column(
            children: [
              HomeGoalItem(
                title: 'Get fit in 30 days',
                subtitle: 'DAY 07 OF 30',
                onTap: onGoalTap,
              ),
              HomeGoalItem(
                title: 'Speak French fluently',
                subtitle: 'DAY 04 OF 18',
                onTap: onGoalTap,
              ),
              HomeGoalItem(
                title: 'Speak French fluently',
                subtitle: 'DAY 04 OF 18',
                onTap: onGoalTap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
