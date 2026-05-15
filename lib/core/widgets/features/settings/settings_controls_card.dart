import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/common/app_section_card.dart';
import 'package:today/core/widgets/features/settings/settings_toggle_row.dart';
import 'package:today/presentation/controllers/settings/theme_controller.dart';

class SettingsControlsCard extends StatelessWidget {
  const SettingsControlsCard({
    super.key,
    required this.hapticsEnabled,
    required this.notificationsEnabled,
    required this.onHapticsChanged,
    required this.onNotificationsChanged,
    this.onNotificationPreferencesTap,
  });

  final bool hapticsEnabled;
  final bool notificationsEnabled;
  final ValueChanged<bool> onHapticsChanged;
  final ValueChanged<bool> onNotificationsChanged;
  final VoidCallback? onNotificationPreferencesTap;

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionCardHeader(
            iconPath: AppImages.settings,
            title: AppTexts.settingsSectionHeading,
          ),
          AppSpacing.vertical(context, 0.03),
          SettingsToggleRow(
            label: AppTexts.settingsHapticsLabel,
            value: hapticsEnabled,
            onChanged: onHapticsChanged,
          ),
          AppSpacing.vertical(context, 0.025),
          SettingsToggleRow(
            label: AppTexts.settingsNotificationsLabel,
            value: notificationsEnabled,
            onChanged: onNotificationsChanged,
          ),
          if (onNotificationPreferencesTap != null) ...[
            AppSpacing.vertical(context, 0.015),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onNotificationPreferencesTap,
                child: Text(
                  AppTexts.notificationPreferencesLink,
                  style: AppTextStyles.labelText(context).copyWith(
                    color: context.onSurfaceColor,
                    fontWeight: FontWeight.w600,
                    fontSize: AppResponsive.scaleSize(context, 10),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
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
