import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/common/app_activity_heatmap.dart';
import 'package:today/core/widgets/common/app_section_card.dart';
import 'package:today/presentation/controllers/analytics/analytics_controller.dart';

class AnalyticsActivityHeatmapSection extends GetView<AnalyticsController> {
  const AnalyticsActivityHeatmapSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final revision = controller.dashboardRevision.value;
      controller.dashboard.value;
      final onCard = context.onSectionCardColor;
      final muted = onCard.withValues(alpha: 0.7);

      return AppSectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    AppTexts.analyticsActivityHeatmapTitle,
                    style: AppTextStyles.labelText(context).copyWith(
                      color: onCard,
                      fontWeight: FontWeight.w600,
                      fontSize: AppResponsive.scaleSize(context, 12),
                    ),
                  ),
                ),
                Text(
                  AppTexts.analyticsHeatmapRangeLabel,
                  style: AppTextStyles.labelText(context).copyWith(
                    color: muted,
                    fontWeight: FontWeight.w500,
                    fontSize: AppResponsive.scaleSize(context, 10),
                  ),
                ),
              ],
            ),
            AppSpacing.vertical(context, 0.015),
            AppActivityHeatmap(
              key: ValueKey('analytics-heatmap-$revision'),
              levels: controller.heatmapLevels,
              weekColumns: controller.heatmapWeekColumns,
              maxLevel: controller.heatmapMaxLevel,
            ),
          ],
        ),
      );
    });
  }
}
