import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/common/app_progress_pie_chart.dart';
import 'package:today/core/widgets/common/app_section_card.dart';
import 'package:today/core/widgets/common/app_trend_badge.dart';
import 'package:today/presentation/controllers/analytics/analytics_controller.dart';

class AnalyticsProductivityPercentageSection
    extends GetView<AnalyticsController> {
  const AnalyticsProductivityPercentageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final revision = controller.dashboardRevision.value;
      final animation = controller.chartAnimationFactor.value;
      controller.dashboard.value;
      final onCard = context.onSectionCardColor;
      final chartSize = AppResponsive.scaleSize(context, 112);

      return AppSectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppTexts.analyticsProductivityPercentageTitle,
              style: AppTextStyles.labelText(context).copyWith(
                color: onCard,
                fontWeight: FontWeight.w600,
                fontSize: AppResponsive.scaleSize(context, 12),
              ),
            ),
            AppSpacing.vertical(context, 0.015),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        controller.productivityPercentLabel,
                        style: AppTextStyles.heading(context).copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: AppResponsive.scaleSize(context, 36),
                          height: 1,
                        ),
                      ),
                      AppSpacing.horizontal(context, 0.02),
                      AppTrendBadge(
                        label: controller.productivityTrendLabel,
                        isUp: controller.isProductivityTrendUp,
                        isDown: controller.isProductivityTrendDown,
                      ),
                    ],
                  ),
                ),
                AppSpacing.horizontal(context, 0.02),
                AppProgressPieChart(
                  key: ValueKey('analytics-pie-$revision'),
                  size: chartSize,
                  goalsCount: controller.productivityGoalsCount,
                  goalsTotal: controller.productivityGoalsTotal,
                  tasksCount: controller.productivityTasksCount,
                  tasksTotal: controller.productivityTasksTotal,
                  animationFactor: animation,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
