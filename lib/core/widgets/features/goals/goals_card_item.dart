import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/widgets/common/app_section_card.dart';
import 'package:today/core/widgets/features/goals/goal_progress_metrics.dart';

class GoalsCardItem extends StatelessWidget {
  const GoalsCardItem({
    super.key,
    required this.title,
    required this.dayText,
    required this.tasksText,
    required this.percentText,
    required this.totalTasksText,
    required this.progress,
    required this.iconPath,
    this.onTap,
  });

  final String title;
  final String dayText;
  final String tasksText;
  final String percentText;
  final String totalTasksText;
  final double progress;
  final String iconPath;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      onTap: onTap,
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
                        color: context.onSurfaceColor,
                        fontWeight: FontWeight.w600,
                        fontSize: AppResponsive.scaleSize(context, 14),
                      ),
                    ),
                    AppSpacing.vertical(context, 0.004),
                    Text(
                      dayText,
                      style: AppTextStyles.labelText(context).copyWith(
                        color: AppColors.grey,
                        fontWeight: FontWeight.w600,
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
          GoalProgressMetrics(
            progress: progress,
            tasksText: tasksText,
            percentText: percentText,
            footerText: totalTasksText,
          ),
        ],
      ),
    );
  }
}
