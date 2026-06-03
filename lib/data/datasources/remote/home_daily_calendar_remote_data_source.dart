import 'package:today/core/network/demo_stub_data.dart';

class HomeDailyCalendarRemoteDataSource {
  const HomeDailyCalendarRemoteDataSource();

  Future<List<Map<String, dynamic>>> fetchWeeklyActivity({
    required bool forStatsTab,
    DateTime? anchor,
  }) async {
    final progressList = forStatsTab
        ? DemoStubData.analyticsWeeklyProgressByDay
        : DemoStubData.homeWeeklyProgressByDay;

    return List<Map<String, dynamic>>.generate(
      progressList.length,
      (index) => <String, dynamic>{
        'day_index': index,
        'progress': progressList[index],
        if (anchor != null) 'anchor': anchor.toIso8601String(),
      },
    );
  }
}
