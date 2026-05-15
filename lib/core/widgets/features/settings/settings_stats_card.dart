import 'package:flutter/material.dart';

import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/common/app_section_card.dart';
import 'package:today/core/widgets/features/settings/settings_stats_row.dart';

class SettingsStatsCard extends StatelessWidget {
  const SettingsStatsCard({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionCardHeader(
            iconPath: AppImages.lifetimeStats,
            title: AppTexts.lifetimeStatsHeading,
          ),
          AppSpacing.vertical(context, 0.04),
          const SettingsStatsRow(
            iconPath: AppImages.goalsCreated,
            label: AppTexts.statsGoalsCreatedLabel,
            value: AppTexts.statsPlaceholderZero,
          ),
          AppSpacing.vertical(context, 0.03),
          const SettingsStatsRow(
            iconPath: AppImages.tasksCompleted,
            label: AppTexts.statsTasksCompletedLabel,
            value: AppTexts.statsPlaceholderZeroSlashZero,
          ),
          AppSpacing.vertical(context, 0.03),
          const SettingsStatsRow(
            iconPath: AppImages.lifetimeStats,
            label: AppTexts.statsProductivityScoreLabel,
            value: AppTexts.statsPlaceholderDash,
          ),
        ],
      ),
    );
  }
}
