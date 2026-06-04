import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/widgets/buttons/app_fab_menu_button.dart';
import 'package:today/core/widgets/common/app_bottom_nav_bar.dart';
import 'package:today/presentation/controllers/home/home_controller.dart';
import 'package:today/presentation/controllers/main/main_app_controller.dart';
import 'package:today/presentation/screens/analytics/analytics_screen.dart';
import 'package:today/presentation/screens/goals/goals_screen.dart';
import 'package:today/presentation/screens/home/home_screen.dart';
import 'package:today/presentation/screens/settings/settings_screen.dart';

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
                onNewTask: home.openCreateTask,
                onRestructureGoal: home.openPlanner,
              )
            : null,
        children: const [
          HomeScreen(),
          GoalsScreen(),
          AnalyticsScreen(),
          SettingsScreen(),
        ],
      );
    });
  }
}
