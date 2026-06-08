import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/features/settings/settings_accent_color_row.dart';
import 'package:today/core/widgets/features/settings/settings_control_tile.dart';
import 'package:today/core/widgets/features/settings/settings_toggle_row.dart';
import 'package:today/presentation/controllers/settings/theme_controller.dart';

class SettingsControlsCard extends StatelessWidget {
  const SettingsControlsCard({
    super.key,
    required this.profileSetupSubtitle,
    required this.onProfileSetupTap,
    required this.hapticsEnabled,
    required this.notificationsEnabled,
    required this.vacationModeEnabled,
    required this.onHapticsChanged,
    required this.onNotificationsChanged,
    required this.onVacationModeChanged,
  });

  final String profileSetupSubtitle;
  final VoidCallback onProfileSetupTap;
  final bool hapticsEnabled;
  final bool notificationsEnabled;
  final bool vacationModeEnabled;
  final ValueChanged<bool> onHapticsChanged;
  final ValueChanged<bool> onNotificationsChanged;
  final ValueChanged<bool> onVacationModeChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsControlTile(
          title: AppTexts.settingsProfileSetupLabel,
          subtitle: profileSetupSubtitle,
          onTap: onProfileSetupTap,
          trailing: Icon(
            Iconsax.arrow_right_3,
            size: AppResponsive.iconSize(context, factor: 0.7),
            color: context.onSectionCardColor,
          ),
        ),
        AppSpacing.vertical(context, 0.015),
        SettingsControlTile(
          title: AppTexts.settingsHapticsLabel,
          subtitle: AppTexts.settingsHapticsSubtitle,
          trailing: SettingsToggleRow(
            value: hapticsEnabled,
            onChanged: onHapticsChanged,
          ),
        ),
        AppSpacing.vertical(context, 0.015),
        SettingsControlTile(
          title: AppTexts.settingsNotificationsLabel,
          subtitle: AppTexts.settingsNotificationsSubtitle,
          trailing: SettingsToggleRow(
            value: notificationsEnabled,
            onChanged: onNotificationsChanged,
          ),
        ),
        AppSpacing.vertical(context, 0.015),
        SettingsControlTile(
          title: AppTexts.settingsVacationModeLabel,
          subtitle: AppTexts.settingsVacationModeSubtitle,
          trailing: SettingsToggleRow(
            value: vacationModeEnabled,
            onChanged: onVacationModeChanged,
          ),
        ),
        AppSpacing.vertical(context, 0.015),
        SettingsControlTile(
          title: AppTexts.settingsAccentColorLabel,
          subtitle: AppTexts.settingsAccentColorSubtitle,
          trailing: const SettingsAccentColorRow(),
        ),
        AppSpacing.vertical(context, 0.015),
        GetBuilder<ThemeController>(
          builder: (themeCtrl) {
            final useSystem = themeCtrl.preference == AppThemePreference.system;
            final resolvedDark =
                Theme.of(context).brightness == Brightness.dark;
            return SettingsControlTile(
              title: AppTexts.themeDarkMode,
              subtitle: AppTexts.settingsDarkModeSubtitle,
              trailing: SettingsToggleRow(
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
              ),
            );
          },
        ),
      ],
    );
  }
}
