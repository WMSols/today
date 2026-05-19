import 'package:today/core/utils/app_helper/app_helper.dart';
import 'package:today/data/datasources/remote/home_daily_calendar_remote_data_source.dart';
import 'package:today/data/models/home_daily_calendar_day_model.dart';
import 'package:today/domain/entities/home_daily_calendar_day_entity.dart';
import 'package:today/domain/repositories/home_daily_calendar_repository.dart';

class HomeDailyCalendarRepositoryImpl implements HomeDailyCalendarRepository {
  const HomeDailyCalendarRepositoryImpl(this._remote);

  final HomeDailyCalendarRemoteDataSource _remote;

  @override
  Future<List<HomeDailyCalendarDayEntity>> getWeeklyActivity({
    required HomeWeeklyCalendarVariant variant,
    DateTime? anchor,
  }) async {
    final now = anchor ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekSunday = AppHelper.weekSundayStart(today);

    final raw = await _remote.fetchWeeklyActivity(
      forStatsTab: variant == HomeWeeklyCalendarVariant.stats,
      anchor: today,
    );

    return raw
        .map(
          (json) => HomeDailyCalendarDayModel.fromJson(
            json,
            weekSunday: weekSunday,
            today: today,
          ),
        )
        .toList();
  }
}
