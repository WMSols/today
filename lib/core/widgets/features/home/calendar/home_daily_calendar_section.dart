import 'package:flutter/material.dart';

import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/widgets/features/home/calendar/home_daily_calendar_day_item.dart';
import 'package:today/domain/entities/home_daily_calendar_day_entity.dart';

/// Horizontal week strip with per-day activity indicators.
class HomeDailyCalendarSection extends StatelessWidget {
  const HomeDailyCalendarSection({
    super.key,
    required this.days,
    required this.ringAnimationFactor,
    this.onDayTap,
  });

  final List<HomeDailyCalendarDayEntity> days;
  final double ringAnimationFactor;
  final ValueChanged<HomeDailyCalendarDayEntity>? onDayTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < days.length; i++) ...[
          if (i > 0) SizedBox(width: AppResponsive.scaleSize(context, 6)),
          Expanded(
            child: HomeDailyCalendarDayItem(
              day: days[i],
              ringAnimationFactor: ringAnimationFactor,
              onTap: onDayTap == null ? null : () => onDayTap!(days[i]),
            ),
          ),
        ],
      ],
    );
  }
}
