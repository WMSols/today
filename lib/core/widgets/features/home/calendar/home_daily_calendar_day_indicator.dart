import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/widgets/common/app_progress_ring.dart';
import 'package:today/domain/entities/home_daily_calendar_day_entity.dart';

class HomeDailyCalendarDayIndicator extends StatelessWidget {
  const HomeDailyCalendarDayIndicator({
    super.key,
    required this.day,
    required this.animatedProgress,
  });

  final HomeDailyCalendarDayEntity day;
  final double animatedProgress;

  static const Color _ringProgressColor = AppColors.white;

  static Color _ringTrackColor(BuildContext context) =>
      AppColors.white.withValues(alpha: 0.2);

  @override
  Widget build(BuildContext context) {
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
