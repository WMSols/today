import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/widgets/features/goals/goal_progress_bar.dart';

enum GoalProgressMetricsStyle { goalsTab, overview }

/// Shared progress bar, task/percent row, and optional footer copy.
class GoalProgressMetrics extends StatelessWidget {
  const GoalProgressMetrics({
    super.key,
    required this.progress,
    required this.tasksText,
    required this.percentText,
    this.footerText,
    this.style = GoalProgressMetricsStyle.goalsTab,
  });

  final double progress;
  final String tasksText;
  final String percentText;
  final String? footerText;
  final GoalProgressMetricsStyle style;

  @override
  Widget build(BuildContext context) {
    final labelColor = style == GoalProgressMetricsStyle.overview
        ? context.mutedOnSurfaceColor
        : AppColors.grey;
    final footerColor = style == GoalProgressMetricsStyle.overview
        ? context.onSurfaceColor
        : AppColors.grey;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GoalProgressBar(progress: progress),
        AppSpacing.vertical(context, 0.01),
        Row(
          children: [
            Text(
              tasksText,
              style: AppTextStyles.labelText(context).copyWith(
                color: labelColor,
                fontWeight: FontWeight.w600,
                fontSize: AppResponsive.scaleSize(context, 10),
              ),
            ),
            const Spacer(),
            Text(
              percentText,
              style: AppTextStyles.labelText(context).copyWith(
                color: labelColor,
                fontWeight: FontWeight.w600,
                fontSize: AppResponsive.scaleSize(context, 10),
              ),
            ),
          ],
        ),
        if (footerText != null) ...[
          AppSpacing.vertical(context, 0.03),
          Text(
            footerText!,
            style: AppTextStyles.labelText(context).copyWith(
              color: footerColor,
              fontWeight: FontWeight.w600,
              fontSize: AppResponsive.scaleSize(context, 10),
            ),
          ),
        ],
      ],
    );
  }
}
