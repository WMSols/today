import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/widgets/common/app_bottom_nav_bar.dart';
import 'package:today/core/widgets/features/goals/goals_body.dart';
import 'package:today/core/widgets/features/home/home_body.dart';
import 'package:today/core/widgets/features/settings/settings_body.dart';
import 'package:today/presentation/screens/analytics/analytics_screen.dart';
import 'package:today/presentation/controllers/main/main_app_controller.dart';

class MainAppScreen extends GetView<MainAppController> {
  const MainAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppBottomNavBarScaffold(
        currentIndex: controller.selectedTabIndex.value,
        onTap: controller.selectTab,
        children: const [
          HomeBody(),
          GoalsBody(),
          AnalyticsScreen(),
          SettingsBody(),
        ],
      ),
    );
  }
}
