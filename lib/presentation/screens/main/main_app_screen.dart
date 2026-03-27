import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/widgets/common/app_bottom_nav_bar.dart';
import 'package:today/core/widgets/features/goals/goals_body.dart';
import 'package:today/core/widgets/features/home/home_body.dart';
import 'package:today/core/widgets/features/settings/settings_body.dart';
import 'package:today/presentation/controllers/main/main_app_controller.dart';
import 'package:today/presentation/routes/app_routes.dart';

class MainAppScreen extends GetView<MainAppController> {
  const MainAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppBottomNavBarScaffold(
        currentIndex: controller.selectedTabIndex.value,
        onTap: controller.selectTab,
        backgroundColor: AppColors.black,
        children: [
          HomeBody(
            onDateTap: () => Get.toNamed(AppRoutes.homeCalendar),
            onGoalTap: () => Get.toNamed(AppRoutes.activeGoalDetails),
          ),
          const GoalsBody(),
          const SettingsBody(),
        ],
      ),
    );
  }
}
