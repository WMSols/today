import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/utils/app_formatter/app_formatter.dart';
import 'package:today/core/widgets/common/app_custom_app_bar.dart';
import 'package:today/presentation/controllers/settings/settings_controller.dart';

class HomeTopHeader extends GetView<SettingsController> {
  const HomeTopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppCustomAppBar.homeStatus(
        greetingName: controller.greetingDisplayName,
        greetingTimeOfDay: AppFormatter.timeOfDayGreeting(),
        profilePhotoUrl: controller.profilePhotoUrl,
        onTapProfile: controller.openSettingsTab,
        onTapNotifications: controller.openNotifications,
        hasUnreadNotifications: controller.hasUnreadNotifications.value,
      ),
    );
  }
}
