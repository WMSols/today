import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/widgets/common/app_custom_app_bar.dart';
import 'package:today/core/widgets/features/home/active_goal_overview_card.dart';
import 'package:today/core/widgets/features/home/active_goal_tasks_card.dart';
import 'package:today/presentation/controllers/home/home_controller.dart';

class ActiveGoalDetailsScreen extends GetView<HomeController> {
  const ActiveGoalDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.symmetric(context, h: 0.03, v: 0.02),
          child: Column(
            children: [
              AppCustomAppBar.titleWithActions(
                title: 'Get fit in 30 days',
                onBack: Get.back,
                trailing: Image.asset(
                  AppImages.goalDetails,
                  width: AppResponsive.iconSize(context, factor: 0.9),
                  height: AppResponsive.iconSize(context, factor: 0.9),
                ),
              ),
              AppSpacing.vertical(context, 0.02),
              const ActiveGoalOverviewCard(),
              AppSpacing.vertical(context, 0.03),
              Obx(
                () => ActiveGoalTasksCard(
                  tasks: controller.activeGoalTasks.toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
