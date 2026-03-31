import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/widgets/features/settings/settings_controls_card.dart';
import 'package:today/core/widgets/features/settings/settings_profile_header.dart';
import 'package:today/core/widgets/features/settings/settings_stats_card.dart';
import 'package:today/presentation/controllers/settings/settings_controller.dart';

class SettingsBody extends GetView<SettingsController> {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SettingsProfileHeader(
              onTapClaimRewards: controller.openClaimRewards,
            ),
          ),
          AppSpacing.vertical(context, 0.03),
          SettingsStatsCard(onTap: controller.openSubscription),
          AppSpacing.vertical(context, 0.02),
          Obx(
            () => SettingsControlsCard(
              hapticsEnabled: controller.hapticsEnabled.value,
              notificationsEnabled: controller.notificationsEnabled.value,
              onHapticsChanged: controller.setHaptics,
              onNotificationsChanged: controller.setNotifications,
            ),
          ),
          AppSpacing.vertical(context, 0.1),
        ],
      ),
    );
  }
}
