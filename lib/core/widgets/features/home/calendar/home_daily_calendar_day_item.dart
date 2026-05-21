import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_helper/app_helper.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/widgets/features/home/calendar/home_daily_calendar_day_indicator.dart';
import 'package:today/core/widgets/features/home/calendar/home_daily_calendar_display_mode.dart';
import 'package:today/domain/entities/home_daily_calendar_day_entity.dart';

class HomeDailyCalendarDayItem extends StatelessWidget {
  const HomeDailyCalendarDayItem({
    super.key,
    required this.day,
    required this.displayMode,
    required this.ringAnimationFactor,
    this.onTap,
  });

  final HomeDailyCalendarDayEntity day;
  final HomeDailyCalendarDisplayMode displayMode;
  final double ringAnimationFactor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final activity = AppHelper.activityFromProgress(day.progress);
    final progressColor = AppHelper.activityColor(activity);
    final capsuleHeight = AppResponsive.scaleSize(context, 76);
    final labelStyle = AppTextStyles.labelText(context).copyWith(
      color: AppColors.white,
      fontWeight: FontWeight.w700,
      fontSize: AppResponsive.scaleSize(context, 11),
      height: 1,
    );

    final capsule = Container(
      height: capsuleHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(capsuleHeight / 2),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: AppHelper.capsuleGradient(
            isDark: isDark,
            progressColor: progressColor,
          ),
        ),
        border: day.isToday
            ? Border.all(
                color: progressColor,
                width: AppResponsive.scaleSize(context, 1),
              )
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(day.dayLabel, style: labelStyle),
          AppSpacing.vertical(context, 0.006),
          HomeDailyCalendarDayIndicator(
            day: day,
            activity: activity,
            displayMode: displayMode,
            isDark: isDark,
            animatedProgress:
                day.progress.clamp(0.0, 1.0) *
                ringAnimationFactor.clamp(0.0, 1.0),
          ),
        ],
      ),
    );

    if (onTap == null) return capsule;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(capsuleHeight / 2),
        child: capsule,
      ),
    );
  }
}
