import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/buttons/app_button.dart';
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
          Obx(
            () => Center(
              child: controller.isProfileLoading.value
                  ? const CircularProgressIndicator(color: AppColors.white)
                  : SettingsProfileHeader(
                      onTapClaimRewards: controller.openClaimRewards,
                      username: controller.profileName,
                      gemsCount: controller.gemsCount,
                      streakCount: controller.streakCount,
                    ),
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
          AppSpacing.vertical(context, 0.02),
          Center(
            child: SizedBox(
              width: double.infinity,
              child: AppButton(
                label: AppTexts.logout,
                primary: true,
                icon: Iconsax.logout_1,
                iconPosition: IconPosition.right,
                onPressed: controller.logout,
              ),
            ),
          ),
          AppSpacing.vertical(context, 0.1),
        ],
      ),
    );
  }
}
