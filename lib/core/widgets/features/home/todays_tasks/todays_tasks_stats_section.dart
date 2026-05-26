import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/common/app_stats_summary_card.dart';
import 'package:today/presentation/controllers/home/home_controller.dart';

class TodaysTasksStatsSection extends GetView<HomeController> {
  const TodaysTasksStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppStatsSummaryCard(
        progress: controller.todayProgressCardRatio,
        progressAnimationFactor:
            controller.todayProgressRingAnimationFactor.value,
        progressTitle: AppTexts.todaysTasksProgressLabel,
        progressIcon: Iconsax.chart_2,
        hasProgressActivity: controller.todayTasksTotalCount > 0,
        metricTop: AppStatsMetric(
          icon: Iconsax.task,
          label: AppTexts.todaysTasksTotalLabel,
          value: '${controller.todayTasksTotalCount}',
        ),
        metricBottom: AppStatsMetric(
          icon: Iconsax.tick_circle,
          label: AppTexts.todaysTasksCompletedLabel,
          value: '${controller.todayTasksCompletedCount}',
        ),
      ),
    );
  }
}
