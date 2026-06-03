import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/common/app_section_card.dart';
import 'package:today/core/widgets/common/app_weekly_bar_chart.dart';
import 'package:today/presentation/controllers/analytics/analytics_controller.dart';

class AnalyticsWeeklyConsistencySection extends GetView<AnalyticsController> {
  const AnalyticsWeeklyConsistencySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final revision = controller.dashboardRevision.value;
      final animation = controller.chartAnimationFactor.value;
      controller.dashboard.value;
      final onCard = context.onSectionCardColor;

      return AppSectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    AppTexts.analyticsWeeklyConsistencyTitle,
                    style: AppTextStyles.labelText(context).copyWith(
                      color: onCard,
                      fontWeight: FontWeight.w600,
                      fontSize: AppResponsive.scaleSize(context, 12),
                    ),
                  ),
                ),
                Icon(
                  Iconsax.chart_2,
                  size: AppResponsive.iconSize(context, factor: 0.7),
                  color: onCard,
                ),
              ],
            ),
            AppSpacing.vertical(context, 0.015),
            AppWeeklyBarChart(
              key: ValueKey('analytics-weekly-$revision'),
              progressValues: controller.weeklyProgress,
              dayLabels: controller.weeklyDayLabels,
              animationFactor: animation,
            ),
          ],
        ),
      );
    });
  }
}
