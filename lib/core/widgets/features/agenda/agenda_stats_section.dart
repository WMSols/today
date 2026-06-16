import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/common/app_stats_summary_card.dart';
import 'package:today/presentation/controllers/agenda/agenda_controller.dart';

class AgendaStatsSection extends GetView<AgendaController> {
  const AgendaStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppStatsSummaryCard(
        progress: controller.completionProgress,
        progressAnimationFactor: controller.progressRingAnimationFactor.value,
        progressTitle: AppTexts.agendaProgressLabel,
        progressIcon: Iconsax.chart_2,
        hasProgressActivity: controller.totalCount > 0,
        metricTop: AppStatsMetric(
          icon: Iconsax.task,
          label: AppTexts.agendaTotalLabel,
          value: '${controller.totalCount}',
        ),
        metricBottom: AppStatsMetric(
          icon: Iconsax.tick_circle,
          label: AppTexts.agendaCompletedLabel,
          value: '${controller.completedCount}',
        ),
      ),
    );
  }
}
