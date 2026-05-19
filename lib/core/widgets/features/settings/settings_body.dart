import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/widgets/common/app_page_scaffold.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progressColor = isDark ? AppColors.white : AppColors.black;

    return SingleChildScrollView(
      padding: AppPageScaffold.defaultBodyPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Center(
              child: controller.isProfileLoading.value
                  ? CircularProgressIndicator(color: progressColor)
                  : SettingsProfileHeader(
                      username: controller.profileName,
                      photoUrl: controller.profilePhotoUrl,
                    ),
            ),
          ),
          AppSpacing.vertical(context, 0.03),
          SettingsStatsCard(onTap: controller.openSubscription),
          AppSpacing.vertical(context, 0.02),
          Obx(
            () => SettingsControlsCard(
              hapticsEnabled: controller.haptics.enabled.value,
              notificationsEnabled: controller.notificationsEnabled.value,
              onHapticsChanged: controller.haptics.setEnabled,
              onNotificationsChanged: controller.setNotifications,
              onNotificationPreferencesTap: controller.openNotifications,
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
