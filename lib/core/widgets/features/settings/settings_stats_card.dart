import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/widgets/features/settings/settings_stats_row.dart';

class SettingsStatsCard extends StatelessWidget {
  const SettingsStatsCard({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: AppSpacing.symmetric(context, h: 0.04, v: 0.04),
        decoration: BoxDecoration(
          color: AppColors.darkGrey,
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
                  AppImages.lifetimeStats,
                  width: AppResponsive.iconSize(context, factor: 0.8),
                  height: AppResponsive.iconSize(context, factor: 0.8),
                ),
                AppSpacing.horizontal(context, 0.02),
                Text(
                  'LIFETIME STATS',
                  style: AppTextStyles.labelText(context).copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: AppResponsive.scaleSize(context, 10),
                  ),
                ),
              ],
            ),
            AppSpacing.vertical(context, 0.04),
            const SettingsStatsRow(
              iconPath: AppImages.goalsCreated,
              label: 'GOALS CREATED',
              value: '0',
            ),
            AppSpacing.vertical(context, 0.03),
            const SettingsStatsRow(
              iconPath: AppImages.tasksCompleted,
              label: 'TASKS COMPLETED',
              value: '0/0',
            ),
            AppSpacing.vertical(context, 0.03),
            const SettingsStatsRow(
              iconPath: AppImages.bestStreak,
              label: 'BEST STREAK',
              value: '0 DAYS',
            ),
          ],
        ),
      ),
    );
  }
}
