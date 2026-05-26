import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/buttons/app_button.dart';
import 'package:today/core/widgets/buttons/app_text_button.dart';
import 'package:today/core/widgets/features/home/todays_tasks/home_today_tasks_timeline.dart';
import 'package:today/presentation/controllers/home/home_controller.dart';

class HomeTodaysTasksSection extends GetView<HomeController> {
  const HomeTodaysTasksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppTexts.todaysTasksHeading,
              style: AppTextStyles.bodyText(context).copyWith(
                color: context.onSurfaceColor,
                fontWeight: FontWeight.w600,
                fontSize: AppResponsive.scaleSize(context, 14),
              ),
            ),
            AppTextButton(
              label: AppTexts.viewAll,
              onPressed: controller.openTodaysTasksScreen,
              color: context.accentPalette.accent,
              icon: Iconsax.arrow_right_3,
              iconPosition: IconPosition.right,
            ),
          ],
        ),
        AppSpacing.vertical(context, 0.012),
        Obx(() {
          final tasks = controller.homeTodayTasksPreview;
          return HomeTodayTasksTimeline(
            tasks: tasks,
            selectedTaskId: controller.selectedTodayTaskId.value,
            onTaskTap: controller.selectTodayTask,
            onTaskDone: controller.completeTodayTask,
            onTaskSkip: controller.skipTodayTask,
          );
        }),
      ],
    );
  }
}
