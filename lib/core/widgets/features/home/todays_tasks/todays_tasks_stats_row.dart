import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/features/home/todays_tasks/todays_tasks_metric_card.dart';
import 'package:today/core/widgets/features/home/todays_tasks/todays_tasks_progress_card.dart';
import 'package:today/presentation/controllers/home/home_controller.dart';

class TodaysTasksStatsRow extends GetView<HomeController> {
  const TodaysTasksStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final rowHeight = AppResponsive.scaleSize(context, 140);

    return SizedBox(
      height: rowHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(flex: 3, child: TodaysTasksProgressCard()),
          AppSpacing.horizontal(context, 0.02),
          Expanded(
            flex: 2,
            child: Obx(
              () => Column(
                children: [
                  Expanded(
                    child: TodaysTasksMetricCard(
                      icon: Iconsax.task,
                      label: AppTexts.todaysTasksTotalLabel,
                      value: '${controller.todayTasksTotalCount}',
                    ),
                  ),
                  SizedBox(height: AppResponsive.scaleSize(context, 6)),
                  Expanded(
                    child: TodaysTasksMetricCard(
                      icon: Iconsax.tick_circle,
                      label: AppTexts.todaysTasksCompletedLabel,
                      value: '${controller.todayTasksCompletedCount}',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
