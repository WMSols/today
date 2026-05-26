import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_helper/app_helper.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/widgets/common/app_progress_ring.dart';
import 'package:today/core/widgets/features/home/calendar/home_daily_calendar_display_mode.dart';
import 'package:today/domain/entities/home_daily_calendar_day_entity.dart';

class HomeDailyCalendarDayIndicator extends StatelessWidget {
  const HomeDailyCalendarDayIndicator({
    super.key,
    required this.day,
    required this.activity,
    required this.displayMode,
    required this.animatedProgress,
  });

  final HomeDailyCalendarDayEntity day;
  final HomeDailyCalendarActivityLevel activity;
  final HomeDailyCalendarDisplayMode displayMode;
  final double animatedProgress;

  static const Color _ringProgressColor = AppColors.white;

  static Color _ringTrackColor(BuildContext context) =>
      AppColors.white.withValues(alpha: 0.2);

  @override
  Widget build(BuildContext context) {
    if (displayMode == HomeDailyCalendarDisplayMode.statusIcon) {
      return _StatusIconIndicator(
        progress: day.progress,
        animatedProgress: animatedProgress,
        activity: activity,
        trackColor: _ringTrackColor(context),
      );
    }
    return _RingIndicator(
      date: day.date,
      animatedProgress: animatedProgress,
      trackColor: _ringTrackColor(context),
    );
  }
}

class _RingIndicator extends StatelessWidget {
  const _RingIndicator({
    required this.date,
    required this.animatedProgress,
    required this.trackColor,
  });

  final int date;
  final double animatedProgress;
  final Color trackColor;

  @override
  Widget build(BuildContext context) {
    final ringSize = AppResponsive.scaleSize(context, 34);
    final strokeWidth = AppResponsive.scaleSize(context, 4);

    return AppProgressRing(
      progress: animatedProgress,
      size: ringSize,
      strokeWidth: strokeWidth,
      trackColor: trackColor,
      progressColor: HomeDailyCalendarDayIndicator._ringProgressColor,
      animationFactor: 1,
      center: Text(
        '$date',
        style: AppTextStyles.labelText(context).copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w700,
          fontSize: AppResponsive.scaleSize(context, 11),
          height: 1,
        ),
      ),
    );
  }
}

class _StatusIconIndicator extends StatelessWidget {
  const _StatusIconIndicator({
    required this.progress,
    required this.animatedProgress,
    required this.activity,
    required this.trackColor,
  });

  final double progress;
  final double animatedProgress;
  final HomeDailyCalendarActivityLevel activity;
  final Color trackColor;

  @override
  Widget build(BuildContext context) {
    final ringSize = AppResponsive.scaleSize(context, 34);
    final strokeWidth = AppResponsive.scaleSize(context, 2.5);
    final clamped = progress.clamp(0.0, 1.0);

    if (clamped >= AppHelper.successThreshold) {
      return AppProgressRing(
        progress: 1,
        size: ringSize,
        strokeWidth: strokeWidth,
        trackColor: trackColor,
        progressColor: HomeDailyCalendarDayIndicator._ringProgressColor,
        center: Icon(
          Icons.check,
          size: AppResponsive.scaleSize(context, 18),
          color: HomeDailyCalendarDayIndicator._ringProgressColor,
        ),
      );
    }

    if (clamped <= 0 || activity == HomeDailyCalendarActivityLevel.none) {
      return AppProgressRing(
        progress: 0,
        size: ringSize,
        strokeWidth: strokeWidth,
        trackColor: trackColor,
        progressColor: Colors.transparent,
      );
    }

    final centerIcon = activity == HomeDailyCalendarActivityLevel.warning
        ? Icons.warning
        : Icons.close;

    return AppProgressRing(
      progress: animatedProgress,
      size: ringSize,
      strokeWidth: strokeWidth,
      trackColor: trackColor,
      progressColor: HomeDailyCalendarDayIndicator._ringProgressColor,
      center: Icon(
        centerIcon,
        size: AppResponsive.scaleSize(context, 16),
        color: HomeDailyCalendarDayIndicator._ringProgressColor,
      ),
    );
  }
}
