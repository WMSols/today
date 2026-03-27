import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/widgets/features/goals/goal_progress_bar.dart';

class ActiveGoalOverviewCard extends StatelessWidget {
  const ActiveGoalOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.symmetric(context, h: 0.04, v: 0.04),
      decoration: BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, factor: 5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'DAY 01',
                style: AppTextStyles.labelText(context).copyWith(
                  color: AppColors.lightGrey,
                  fontWeight: FontWeight.w700,
                  fontSize: AppResponsive.scaleSize(context, 10),
                ),
              ),
              const Spacer(),
              Text(
                'OUT OF 10',
                style: AppTextStyles.labelText(context).copyWith(
                  color: AppColors.lightGrey,
                  fontWeight: FontWeight.w700,
                  fontSize: AppResponsive.scaleSize(context, 10),
                ),
              ),
              AppSpacing.horizontal(context, 0.01),
              Image.asset(
                AppImages.medal1,
                width: AppResponsive.scaleSize(context, 10),
                height: AppResponsive.scaleSize(context, 10),
              ),
            ],
          ),
          AppSpacing.vertical(context, 0.02),
          const GoalProgressBar(progress: 0.28),
          AppSpacing.vertical(context, 0.01),
          Row(
            children: [
              Text(
                '0/6 TASKS',
                style: AppTextStyles.labelText(context).copyWith(
                  color: AppColors.lightGrey,
                  fontWeight: FontWeight.w700,
                  fontSize: AppResponsive.scaleSize(context, 10),
                ),
              ),
              const Spacer(),
              Text(
                '0%',
                style: AppTextStyles.labelText(context).copyWith(
                  color: AppColors.lightGrey,
                  fontWeight: FontWeight.w700,
                  fontSize: AppResponsive.scaleSize(context, 10),
                ),
              ),
            ],
          ),
          AppSpacing.vertical(context, 0.03),
          Text(
            "DAY 1 IS ABOUT SHOWING UP - LET'S KEEP IT SIMPLE AND\nBUILD MOMENTUM BACK, YOU'VE GOT THIS!",
            style: AppTextStyles.labelText(context).copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
              fontSize: AppResponsive.scaleSize(context, 10),
            ),
          ),
        ],
      ),
    );
  }
}
