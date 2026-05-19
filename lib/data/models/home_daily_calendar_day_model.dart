import 'package:today/core/utils/app_helper/app_helper.dart';
import 'package:today/domain/entities/home_daily_calendar_day_entity.dart';

class HomeDailyCalendarDayModel extends HomeDailyCalendarDayEntity {
  const HomeDailyCalendarDayModel({
    required super.dayLabel,
    required super.date,
    required super.progress,
    super.isToday,
  });

  factory HomeDailyCalendarDayModel.fromStub({
    required int dayIndex,
    required double progress,
    required DateTime weekSunday,
    required DateTime today,
  }) {
    final date = weekSunday.add(Duration(days: dayIndex));
    return HomeDailyCalendarDayModel(
      dayLabel: AppHelper.dayLabelFor(date),
      date: date.day,
      progress: progress,
      isToday: AppHelper.isSameDay(date, today),
    );
  }

  factory HomeDailyCalendarDayModel.fromJson(
    Map<String, dynamic> json, {
    required DateTime weekSunday,
    required DateTime today,
  }) {
    final dayIndex = json['day_index'] as int? ?? 0;
    final progress = (json['progress'] as num?)?.toDouble() ?? 0.0;
    return HomeDailyCalendarDayModel.fromStub(
      dayIndex: dayIndex,
      progress: progress,
      weekSunday: weekSunday,
      today: today,
    );
  }
}
