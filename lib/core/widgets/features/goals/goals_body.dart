import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/widgets/common/app_page_scaffold.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/common/app_custom_app_bar.dart';
import 'package:today/core/widgets/feedback/app_loading_indicator.dart';
import 'package:today/core/widgets/features/goals/empty_goal.dart';
import 'package:today/core/widgets/features/goals/goals_card_item.dart';
import 'package:today/presentation/controllers/goals/goals_controller.dart';

class GoalsBody extends GetView<GoalsController> {
  const GoalsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppPageScaffold.defaultBodyPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppCustomAppBar.titleOnly(title: AppTexts.goals),
          Obx(
            () => controller.isLoading.value
                ? const Center(child: AppLoadingIndicator())
                : controller.showEmptyGoal.value
                ? const EmptyGoal()
                : Column(
                    children: [
                      AppSpacing.vertical(context, 0.02),
                      ...List.generate(controller.goalCards.length, (index) {
                        final card = controller.goalCards[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index == controller.goalCards.length - 1
                                ? 0
                                : AppResponsive.scaleSize(context, 12),
                          ),
                          child: GoalsCardItem(
                            title: card.title,
                            dayText: card.dayText,
                            tasksText: card.tasksText,
                            percentText: card.percentText,
                            totalTasksText: card.totalTasksText,
                            progress: card.progress,
                            iconPath: card.iconPath,
                            onTap: controller.openEmptyGoal,
                          ),
                        );
                      }),
                    ],
                  ),
          ),
          AppSpacing.vertical(context, 0.1),
        ],
      ),
    );
  }
}
