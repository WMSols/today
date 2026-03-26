import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/widgets/features/goals/goal_progress_bar.dart';

class GoalsCardItem extends StatelessWidget {
  const GoalsCardItem({
    super.key,
    required this.title,
    required this.dayText,
    required this.tasksText,
    required this.percentText,
    required this.gemsText,
    required this.totalTasksText,
    required this.progress,
    required this.iconPath,
  });

  final String title;
  final String dayText;
  final String tasksText;
  final String percentText;
  final String gemsText;
  final String totalTasksText;
  final double progress;
  final String iconPath;
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
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.heading(context).copyWith(
                        color: AppColors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w600,
                        fontSize: AppResponsive.scaleSize(context, 14),
                      ),
                    ),
                    AppSpacing.vertical(context, 0.004),
                    Text(
                      dayText,
                      style: AppTextStyles.labelText(context).copyWith(
                        color: AppColors.grey,
                        fontWeight: FontWeight.w700,
                        fontSize: AppResponsive.scaleSize(context, 10),
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset(
                iconPath,
                width: AppResponsive.iconSize(context, factor: 1.15),
                height: AppResponsive.iconSize(context, factor: 1.15),
              ),
            ],
          ),
          AppSpacing.vertical(context, 0.03),
          GoalProgressBar(progress: progress),
          AppSpacing.vertical(context, 0.01),
          Row(
            children: [
              Text(
                tasksText,
                style: AppTextStyles.labelText(context).copyWith(
                  color: AppColors.grey,
                  fontWeight: FontWeight.w700,
                  fontSize: AppResponsive.scaleSize(context, 10),
                ),
              ),
              const Spacer(),
              Text(
                percentText,
                style: AppTextStyles.labelText(context).copyWith(
                  color: AppColors.grey,
                  fontWeight: FontWeight.w700,
                  fontSize: AppResponsive.scaleSize(context, 10),
                ),
              ),
            ],
          ),
          AppSpacing.vertical(context, 0.03),
          Row(
            children: [
              Image.asset(
                AppImages.gem,
                width: AppResponsive.iconSize(context, factor: 0.8),
                height: AppResponsive.iconSize(context, factor: 0.8),
              ),
              AppSpacing.horizontal(context, 0.01),
              Text(
                gemsText,
                style: AppTextStyles.labelText(context).copyWith(
                  color: AppColors.grey,
                  fontWeight: FontWeight.w700,
                  fontSize: AppResponsive.scaleSize(context, 10),
                ),
              ),
              const Spacer(),
              Text(
                totalTasksText,
                style: AppTextStyles.labelText(context).copyWith(
                  color: AppColors.grey,
                  fontWeight: FontWeight.w700,
                  fontSize: AppResponsive.scaleSize(context, 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
