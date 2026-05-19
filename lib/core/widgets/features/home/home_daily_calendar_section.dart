import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_formatter/app_formatter.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';

enum HomeDailyCalendarActivityLevel { none, success, warning, error }

enum HomeDailyCalendarDisplayMode {
  /// Date number with circular progress arc (home).
  ring,

  /// Status icon when complete / warning / error (stats).
  statusIcon,
}

class HomeDailyCalendarDayData {
  const HomeDailyCalendarDayData({
    required this.dayLabel,
    required this.date,
    required this.progress,
    this.activity,
    this.isToday = false,
  });

  final String dayLabel;
  final int date;
  final double progress;
  final HomeDailyCalendarActivityLevel? activity;
  final bool isToday;

  HomeDailyCalendarActivityLevel resolvedActivity() {
    return activity ?? activityFromProgress(progress);
  }

  static HomeDailyCalendarActivityLevel activityFromProgress(double progress) {
    final value = progress.clamp(0.0, 1.0);
    if (value >= 0.8) return HomeDailyCalendarActivityLevel.success;
    if (value >= 0.4) return HomeDailyCalendarActivityLevel.warning;
    if (value > 0) return HomeDailyCalendarActivityLevel.error;
    return HomeDailyCalendarActivityLevel.none;
  }
}

/// Horizontal week strip with per-day activity indicators.
class HomeDailyCalendarSection extends StatelessWidget {
  const HomeDailyCalendarSection({
    super.key,
    this.days,
    this.onDayTap,
    this.displayMode = HomeDailyCalendarDisplayMode.ring,
  });

  final List<HomeDailyCalendarDayData>? days;
  final ValueChanged<HomeDailyCalendarDayData>? onDayTap;
  final HomeDailyCalendarDisplayMode displayMode;

  static const double successThreshold = 0.8;
  static const double warningThreshold = 0.4;

  /// Home strip — ring arcs with mixed dummy progress.
  static List<HomeDailyCalendarDayData> dummyDays([DateTime? anchor]) {
    final now = anchor ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sunday = today.subtract(Duration(days: today.weekday % 7));

    const progressByIndex = <double>[0.4, 1.0, 1.0, 0.5, 0.0, 0.0, 0.0];

    return List.generate(7, (index) {
      final date = sunday.add(Duration(days: index));
      return HomeDailyCalendarDayData(
        dayLabel: AppFormatter.dayNameShort(date.weekday)[0],
        date: date.day,
        progress: progressByIndex[index],
        isToday: _isSameDay(date, today),
      );
    });
  }

  /// Stats tab — showcases tick / warning / error states.
  static List<HomeDailyCalendarDayData> dummyDaysForStats([DateTime? anchor]) {
    final now = anchor ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sunday = today.subtract(Duration(days: today.weekday % 7));

    const progressByIndex = <double>[
      0.0,
      0.25,
      0.85,
      0.92,
      0.55,
      0.0,
      0.15,
    ];

    return List.generate(7, (index) {
      final date = sunday.add(Duration(days: index));
      return HomeDailyCalendarDayData(
        dayLabel: AppFormatter.dayNameShort(date.weekday)[0],
        date: date.day,
        progress: progressByIndex[index],
        isToday: _isSameDay(date, today),
      );
    });
  }

  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final items = days ??
        (displayMode == HomeDailyCalendarDisplayMode.statusIcon
            ? dummyDaysForStats()
            : dummyDays());

    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) SizedBox(width: AppResponsive.scaleSize(context, 6)),
          Expanded(
            child: HomeDailyCalendarDayItem(
              data: items[i],
              displayMode: displayMode,
              onTap: onDayTap == null ? null : () => onDayTap!(items[i]),
            ),
          ),
        ],
      ],
    );
  }
}

class HomeDailyCalendarDayItem extends StatelessWidget {
  const HomeDailyCalendarDayItem({
    super.key,
    required this.data,
    required this.displayMode,
    this.onTap,
  });

  final HomeDailyCalendarDayData data;
  final HomeDailyCalendarDisplayMode displayMode;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final activity = data.resolvedActivity();
    final progressColor = HomeDailyCalendarColors.activity(activity);
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
          colors: _capsuleGradient(isDark, progressColor),
        ),
        border: data.isToday
            ? Border.all(
                color: AppColors.white.withValues(alpha: isDark ? 0.35 : 0.5),
                width: AppResponsive.scaleSize(context, 1),
              )
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(data.dayLabel, style: labelStyle),
          AppSpacing.vertical(context, 0.006),
          _HomeDailyCalendarDayIndicator(
            data: data,
            activity: activity,
            displayMode: displayMode,
            isDark: isDark,
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

  List<Color> _capsuleGradient(bool isDark, Color progressColor) {
    if (isDark) {
      return [
        Color.lerp(AppColors.darkGrey, progressColor, 0.8)!,
        Color.lerp(AppColors.black, progressColor, 0.12)!,
      ];
    }
    return [
      Color.lerp(AppColors.black, progressColor, 0.8)!,
      Color.lerp(AppColors.darkGrey, progressColor, 0.1)!,
    ];
  }
}

class _HomeDailyCalendarDayIndicator extends StatelessWidget {
  const _HomeDailyCalendarDayIndicator({
    required this.data,
    required this.activity,
    required this.displayMode,
    required this.isDark,
  });

  final HomeDailyCalendarDayData data;
  final HomeDailyCalendarActivityLevel activity;
  final HomeDailyCalendarDisplayMode displayMode;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    if (displayMode == HomeDailyCalendarDisplayMode.statusIcon) {
      return _StatusIconIndicator(
        progress: data.progress,
        activity: activity,
        isDark: isDark,
      );
    }
    return _RingIndicator(
      date: data.date,
      progress: data.progress,
      activity: activity,
      isDark: isDark,
    );
  }
}

class _RingIndicator extends StatelessWidget {
  const _RingIndicator({
    required this.date,
    required this.progress,
    required this.activity,
    required this.isDark,
  });

  final int date;
  final double progress;
  final HomeDailyCalendarActivityLevel activity;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final ringSize = AppResponsive.scaleSize(context, 34);
    final strokeWidth = AppResponsive.scaleSize(context, 4);
    final trackColor = AppColors.white.withValues(alpha: isDark ? 0.14 : 0.2);
    final progressColor = HomeDailyCalendarColors.activity(activity);

    return SizedBox(
      width: ringSize,
      height: ringSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size.square(ringSize),
            painter: _ActivityRingPainter(
              progress: progress,
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
    required this.activity,
    required this.isDark,
  });

  final double progress;
  final HomeDailyCalendarActivityLevel activity;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final ringSize = AppResponsive.scaleSize(context, 34);
    final strokeWidth = AppResponsive.scaleSize(context, 2.5);
    final trackColor = AppColors.white.withValues(alpha: isDark ? 0.14 : 0.2);
    final clamped = progress.clamp(0.0, 1.0);

    if (clamped >= HomeDailyCalendarSection.successThreshold) {
      return Container(
        width: ringSize,
        height: ringSize,
        decoration: BoxDecoration(
          color: HomeDailyCalendarColors.activity(
            HomeDailyCalendarActivityLevel.success,
          ),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(
          Iconsax.tick_circle,
          size: AppResponsive.scaleSize(context, 18),
          color: AppColors.black,
        ),
      );
    }

    if (clamped <= 0 || activity == HomeDailyCalendarActivityLevel.none) {
      return SizedBox(
        width: ringSize,
        height: ringSize,
        child: CustomPaint(
          size: Size.square(ringSize),
          painter: _ActivityRingPainter(
            progress: 0,
            trackColor: trackColor,
            progressColor: Colors.transparent,
            strokeWidth: strokeWidth,
          ),
        ),
      );
    }

    final progressColor = HomeDailyCalendarColors.activity(activity);
    final centerIcon = activity == HomeDailyCalendarActivityLevel.warning
        ? Iconsax.warning_2
        : Iconsax.close_circle;

    return SizedBox(
      width: ringSize,
      height: ringSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size.square(ringSize),
            painter: _ActivityRingPainter(
              progress: progress,
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

abstract final class HomeDailyCalendarColors {
  static Color activity(HomeDailyCalendarActivityLevel level) {
    final Color base;
    switch (level) {
      case HomeDailyCalendarActivityLevel.success:
        base = AppColors.success;
      case HomeDailyCalendarActivityLevel.warning:
        base = AppColors.warning;
      case HomeDailyCalendarActivityLevel.error:
        base = AppColors.error;
      case HomeDailyCalendarActivityLevel.none:
        return AppColors.grey;
    }
    return Color.lerp(base, AppColors.white, 0.18)!;
  }
}

class _ActivityRingPainter extends CustomPainter {
  const _ActivityRingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  final double progress;
  final Color trackColor;
  final Color progressColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - strokeWidth) / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, trackPaint);

    final clamped = progress.clamp(0.0, 1.0);
    if (clamped <= 0 || progressColor.a == 0) return;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: center, radius: radius);
    if (clamped >= 1) {
      canvas.drawCircle(center, radius, progressPaint);
      return;
    }

    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * clamped,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ActivityRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
