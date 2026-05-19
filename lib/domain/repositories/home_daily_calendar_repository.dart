import 'package:today/domain/entities/home_daily_calendar_day_entity.dart';

enum HomeWeeklyCalendarVariant { home, stats }

abstract class HomeDailyCalendarRepository {
  Future<List<HomeDailyCalendarDayEntity>> getWeeklyActivity({
    required HomeWeeklyCalendarVariant variant,
    DateTime? anchor,
  });
}
