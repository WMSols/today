import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/widgets/buttons/app_fab_menu_button.dart';
import 'package:today/core/widgets/common/app_bottom_nav_bar.dart';
import 'package:today/core/widgets/features/goals/goals_body.dart';
import 'package:today/core/widgets/features/home/home_body.dart';
import 'package:today/core/widgets/features/settings/settings_body.dart';
import 'package:today/presentation/controllers/home/home_controller.dart';
import 'package:today/presentation/controllers/main/main_app_controller.dart';
import 'package:today/presentation/screens/analytics/analytics_screen.dart';

class MainAppScreen extends GetView<MainAppController> {
  const MainAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final home = Get.find<HomeController>();
    return Obx(() {
      final isHomeTab =
          controller.selectedTabIndex.value == MainAppController.homeTabIndex;
      return AppBottomNavBarScaffold(
        currentIndex: controller.selectedTabIndex.value,
        onTap: controller.selectTab,
        overlay: isHomeTab
            ? AppFABMenuButton(
                onAddGoal: home.openPlanner,
                onRestructureGoal: home.openPlanner,
              )
            : null,
        children: const [
          HomeBody(),
          GoalsBody(),
          AnalyticsScreen(),
          SettingsBody(),
        ],
      );
    });
  }
}
