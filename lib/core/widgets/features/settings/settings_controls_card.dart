import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';

import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/common/app_section_card.dart';
import 'package:today/core/widgets/features/settings/settings_accent_color_row.dart';
import 'package:today/core/widgets/features/settings/settings_toggle_row.dart';
import 'package:today/presentation/controllers/settings/theme_controller.dart';

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
    return AppSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionCardHeader(
            icon: Iconsax.setting_4,
            title: AppTexts.settingsSectionHeading,
            iconColor: AppColors.white,
          ),
          AppSpacing.vertical(context, 0.02),
          SettingsToggleRow(
            label: AppTexts.settingsHapticsLabel,
            value: hapticsEnabled,
            onChanged: onHapticsChanged,
          ),
          AppSpacing.vertical(context, 0.015),
          SettingsToggleRow(
            label: AppTexts.settingsNotificationsLabel,
            value: notificationsEnabled,
            onChanged: onNotificationsChanged,
          ),

          AppSpacing.vertical(context, 0.015),
          const SettingsAccentColorRow(),
          AppSpacing.vertical(context, 0.015),
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
