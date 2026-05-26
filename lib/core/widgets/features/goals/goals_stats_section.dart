import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/common/app_stats_summary_card.dart';
import 'package:today/presentation/controllers/goals/goals_controller.dart';

class GoalsStatsSection extends GetView<GoalsController> {
  const GoalsStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppStatsSummaryCard(
        progress: controller.goalsAggregateProgress,
        progressAnimationFactor: 1,
        progressTitle: AppTexts.goalsProgressLabel,
        progressIcon: Iconsax.chart_2,
        hasProgressActivity: controller.goalsTotalCount > 0,
        metricTop: AppStatsMetric(
          icon: Iconsax.flag,
          label: AppTexts.goalsTotalLabel,
          value: '${controller.goalsTotalCount}',
        ),
        metricBottom: AppStatsMetric(
          icon: Iconsax.tick_circle,
          label: AppTexts.goalsCompletedTasksLabel,
          value: '${controller.goalsCompletedTasksCount}',
        ),
      ),
    );
  }
}
