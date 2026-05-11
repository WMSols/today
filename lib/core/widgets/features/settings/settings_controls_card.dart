import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/features/settings/settings_toggle_row.dart';
import 'package:today/presentation/controllers/theme/theme_controller.dart';

class SettingsControlsCard extends StatelessWidget {
  const SettingsControlsCard({
    super.key,
    required this.hapticsEnabled,
    required this.notificationsEnabled,
    required this.onHapticsChanged,
    required this.onNotificationsChanged,
  });

  final bool hapticsEnabled;
  final bool notificationsEnabled;
  final ValueChanged<bool> onHapticsChanged;
  final ValueChanged<bool> onNotificationsChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkGrey : AppColors.grey;
    final headingColor = isDark ? AppColors.white : AppColors.black;

    return Container(
      width: double.infinity,
      padding: AppSpacing.symmetric(context, h: 0.04, v: 0.04),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, factor: 5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                AppImages.streak,
                width: AppResponsive.iconSize(context, factor: 0.8),
                height: AppResponsive.iconSize(context, factor: 0.8),
              ),
              AppSpacing.horizontal(context, 0.02),
              Text(
                'SETTINGS',
                style: AppTextStyles.labelText(context).copyWith(
                  color: headingColor,
                  fontWeight: FontWeight.w600,
                  fontSize: AppResponsive.scaleSize(context, 10),
                ),
              ),
            ],
          ),
          AppSpacing.vertical(context, 0.03),
          SettingsToggleRow(
            label: 'HAPTICS',
            value: hapticsEnabled,
            onChanged: onHapticsChanged,
          ),
          AppSpacing.vertical(context, 0.025),
          SettingsToggleRow(
            label: 'NOTIFICATIONS',
            value: notificationsEnabled,
            onChanged: onNotificationsChanged,
          ),
          AppSpacing.vertical(context, 0.025),
          GetBuilder<ThemeController>(
            builder: (themeCtrl) {
              final useSystem =
                  themeCtrl.preference == AppThemePreference.system;
              final resolvedDark =
                  Theme.of(context).brightness == Brightness.dark;
              return SettingsToggleRow(
                label: AppTexts.themeDarkMode,
                value: useSystem
                    ? resolvedDark
                    : themeCtrl.preference == AppThemePreference.dark,
                onChanged: (v) {
                  if (useSystem) return;
                  themeCtrl.setPreference(
                    v ? AppThemePreference.dark : AppThemePreference.light,
                  );
                },
                showSystemCheckbox: true,
                systemCheckboxValue: useSystem,
                onSystemChanged: (v) {
                  if (v == true) {
                    themeCtrl.setPreference(AppThemePreference.system);
                  } else {
                    themeCtrl.setPreference(AppThemePreference.light);
                  }
                },
                toggleLocked: useSystem,
              );
            },
          ),
        ],
      ),
    );
  }
}
