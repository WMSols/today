/// Weekly activity stub payloads until the calendar API is available.
class HomeDailyCalendarRemoteDataSource {
  const HomeDailyCalendarRemoteDataSource();

  static const List<double> _homeProgressByDay = <double>[
    0.4,
    1.0,
    1.0,
    0.5,
    0.0,
    0.0,
    0.0,
  ];

  static const List<double> _statsProgressByDay = <double>[
    0.0,
    0.25,
    0.85,
    0.92,
    0.55,
    0.0,
    0.15,
  ];

  /// Returns seven maps (Sun–Sat) with a `progress` field in `[0, 1]`.
  Future<List<Map<String, dynamic>>> fetchWeeklyActivity({
    required bool forStatsTab,
    DateTime? anchor,
  }) async {
    final progressList = forStatsTab ? _statsProgressByDay : _homeProgressByDay;

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
