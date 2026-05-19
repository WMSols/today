import 'package:flutter/material.dart';

import 'package:today/core/utils/app_helper/app_helper.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/widgets/features/home/calendar/home_daily_calendar_activity_ring_painter.dart';
import 'package:today/core/widgets/features/home/calendar/home_daily_calendar_display_mode.dart';
import 'package:today/domain/entities/home_daily_calendar_day_entity.dart';

class HomeDailyCalendarDayIndicator extends StatelessWidget {
  const HomeDailyCalendarDayIndicator({
    super.key,
    required this.day,
    required this.activity,
    required this.displayMode,
    required this.isDark,
    required this.animatedProgress,
  });

  final HomeDailyCalendarDayEntity day;
  final HomeDailyCalendarActivityLevel activity;
  final HomeDailyCalendarDisplayMode displayMode;
  final bool isDark;
  final double animatedProgress;

  @override
  Widget build(BuildContext context) {
    if (displayMode == HomeDailyCalendarDisplayMode.statusIcon) {
      return _StatusIconIndicator(
        progress: day.progress,
        animatedProgress: animatedProgress,
        activity: activity,
        isDark: isDark,
      );
    }
    return _RingIndicator(
      date: day.date,
      animatedProgress: animatedProgress,
      activity: activity,
      isDark: isDark,
    );
  }
}

class _RingIndicator extends StatelessWidget {
  const _RingIndicator({
    required this.date,
    required this.animatedProgress,
    required this.activity,
    required this.isDark,
  });

  final int date;
  final double animatedProgress;
  final HomeDailyCalendarActivityLevel activity;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final ringSize = AppResponsive.scaleSize(context, 34);
    final strokeWidth = AppResponsive.scaleSize(context, 4);
    final trackColor = AppColors.white.withValues(alpha: isDark ? 0.14 : 0.2);
    final progressColor = AppHelper.activityColor(activity);

    return SizedBox(
      width: ringSize,
      height: ringSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size.square(ringSize),
            painter: HomeDailyCalendarActivityRingPainter(
              progress: animatedProgress,
              trackColor: trackColor,
              progressColor: progressColor,
              strokeWidth: strokeWidth,
            ),
          ),
          Text(
            '$date',
            style: AppTextStyles.labelText(context).copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
              fontSize: AppResponsive.scaleSize(context, 11),
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusIconIndicator extends StatelessWidget {
  const _StatusIconIndicator({
    required this.progress,
    required this.animatedProgress,
    required this.activity,
    required this.isDark,
  });

  final double progress;
  final double animatedProgress;
  final HomeDailyCalendarActivityLevel activity;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final ringSize = AppResponsive.scaleSize(context, 34);
    final strokeWidth = AppResponsive.scaleSize(context, 2.5);
    final trackColor = AppColors.white.withValues(alpha: isDark ? 0.14 : 0.2);
    final clamped = progress.clamp(0.0, 1.0);

    if (clamped >= AppHelper.successThreshold) {
      return Container(
        width: ringSize,
        height: ringSize,
        decoration: BoxDecoration(
          color: AppHelper.activityColor(
            HomeDailyCalendarActivityLevel.success,
          ),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.check,
          size: AppResponsive.scaleSize(context, 18),
          color: AppColors.white,
        ),
      );
    }

    if (clamped <= 0 || activity == HomeDailyCalendarActivityLevel.none) {
      return SizedBox(
        width: ringSize,
        height: ringSize,
        child: CustomPaint(
          size: Size.square(ringSize),
          painter: HomeDailyCalendarActivityRingPainter(
            progress: 0,
            trackColor: trackColor,
            progressColor: Colors.transparent,
            strokeWidth: strokeWidth,
          ),
        ),
      );
    }

    final progressColor = AppHelper.activityColor(activity);
    final centerIcon = activity == HomeDailyCalendarActivityLevel.warning
        ? Icons.warning
        : Icons.close;

    return SizedBox(
      width: ringSize,
      height: ringSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size.square(ringSize),
            painter: HomeDailyCalendarActivityRingPainter(
              progress: animatedProgress,
              trackColor: trackColor,
              progressColor: progressColor,
              strokeWidth: strokeWidth,
            ),
          ),
          Icon(
            centerIcon,
            size: AppResponsive.scaleSize(context, 16),
            color: progressColor,
          ),
        ],
      ),
    );
  }
}
