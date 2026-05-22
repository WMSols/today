import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_helper/app_helper.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/widgets/common/app_section_card.dart';
import 'package:today/core/widgets/features/goals/goal_progress_bar.dart';

class HomeActiveGoalItem extends StatelessWidget {
  const HomeActiveGoalItem({
    super.key,
    required this.title,
    required this.tasksText,
    required this.progress,
    this.onTap,
  });

  final String title;
  final String tasksText;
  final double progress;
  final VoidCallback? onTap;

  static Color get _onCardColor => AppColors.white;

  static Color get _progressTrackColor =>
      AppColors.white.withValues(alpha: 0.35);

  @override
  Widget build(BuildContext context) {
    final iconSize = AppResponsive.iconSize(context, factor: 1.1);

    return AppSectionCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bodyText(context).copyWith(
                    color: _onCardColor,
                    fontWeight: FontWeight.w600,
                    fontSize: AppResponsive.scaleSize(context, 15),
                    height: 1.2,
                  ),
                ),
              ),
              Icon(
                AppHelper.goalIconForTitle(title),
                size: iconSize,
                color: _onCardColor,
              ),
            ],
          ),
          AppSpacing.vertical(context, 0.008),
          Text(
            tasksText.toLowerCase(),
            style: AppTextStyles.labelText(context).copyWith(
              color: _onCardColor,
              fontWeight: FontWeight.w500,
              fontSize: AppResponsive.scaleSize(context, 12),
            ),
          ),
          AppSpacing.vertical(context, 0.015),
          GoalProgressBar(
            progress: progress,
            trackColor: _progressTrackColor,
            valueColor: _onCardColor,
          ),
        ],
      ),
    );
  }
}
