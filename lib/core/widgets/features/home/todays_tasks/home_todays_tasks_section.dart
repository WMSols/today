import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/buttons/app_button.dart';
import 'package:today/core/widgets/buttons/app_text_button.dart';
import 'package:today/core/widgets/features/home/todays_tasks/home_today_task_item.dart';
import 'package:today/presentation/controllers/home/home_controller.dart';

class HomeTodaysTasksSection extends GetView<HomeController> {
  const HomeTodaysTasksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                children: [
                  Image.asset(
                    AppImages.lifetimeStats,
                    width: AppResponsive.iconSize(context, factor: 0.8),
                    height: AppResponsive.iconSize(context, factor: 0.8),
                  ),
                  AppSpacing.horizontal(context, 0.01),
                  Text(
                    AppTexts.todaysTasksHeading,
                    style: AppTextStyles.bodyText(context).copyWith(
                      color: context.onSurfaceColor,
                      fontWeight: FontWeight.w600,
                      fontSize: AppResponsive.scaleSize(context, 10),
                    ),
                  ),
                ],
              ),
            ),
            AppTextButton(
              label: AppTexts.viewAll,
              onPressed: controller.openGoalsTab,
              color: context.onSurfaceColor,
              icon: Iconsax.arrow_right_1,
              iconPosition: IconPosition.right,
            ),
          ],
        ),
        AppSpacing.vertical(context, 0.01),
        Obx(() {
          final tasks = controller.homeTodayTasksPreview;
          return Column(
            children: List.generate(tasks.length, (index) {
              final task = tasks[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < tasks.length - 1
                      ? AppResponsive.scaleSize(context, 10)
                      : 0,
                ),
                child: HomeTodayTaskItem(
                  task: task,
                  isSelected: controller.selectedTodayTaskId.value == task.id,
                  onTap: () => controller.selectTodayTask(task.id),
                  onDone: () => controller.completeTodayTask(task.id),
                  onSkip: () => controller.skipTodayTask(task.id),
                ),
              );
            }),
          );
        }),
      ],
    );
  }
}
