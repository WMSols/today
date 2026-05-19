import 'package:today/domain/entities/home_daily_calendar_day_entity.dart';
import 'package:today/domain/repositories/home_daily_calendar_repository.dart';

class GetWeeklyCalendarUseCase {
  const GetWeeklyCalendarUseCase(this._repository);

  final HomeDailyCalendarRepository _repository;

  Future<List<HomeDailyCalendarDayEntity>> call({
    required HomeWeeklyCalendarVariant variant,
    DateTime? anchor,
  }) {
    return _repository.getWeeklyActivity(variant: variant, anchor: anchor);
  }
}
