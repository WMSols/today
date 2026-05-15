import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/widgets/common/app_section_card.dart';
import 'package:today/core/widgets/features/goals/goal_progress_metrics.dart';
import 'package:today/presentation/controllers/home/home_controller.dart';

class ActiveGoalOverviewCard extends GetView<HomeController> {
  const ActiveGoalOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final display = controller.activeGoalOverviewDisplay;

      return AppSectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  display.dayLeftDisplay,
                  style: AppTextStyles.labelText(context).copyWith(
                    color: context.mutedOnSurfaceColor,
                    fontWeight: FontWeight.w600,
                    fontSize: AppResponsive.scaleSize(context, 10),
                  ),
                ),
                const Spacer(),
                Text(
                  display.dayRightDisplay,
                  style: AppTextStyles.labelText(context).copyWith(
                    color: context.mutedOnSurfaceColor,
                    fontWeight: FontWeight.w600,
                    fontSize: AppResponsive.scaleSize(context, 10),
                  ),
                ),
                AppSpacing.horizontal(context, 0.01),
                Image.asset(
                  display.medalIconPath,
                  width: AppResponsive.scaleSize(context, 10),
                  height: AppResponsive.scaleSize(context, 10),
                ),
              ],
            ),
            AppSpacing.vertical(context, 0.02),
            GoalProgressMetrics(
              progress: display.progress,
              tasksText: display.tasksText,
              percentText: display.percentText,
              footerText: display.footerText,
              style: GoalProgressMetricsStyle.overview,
            ),
          ],
        ),
      );
    });
  }
}
