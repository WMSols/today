class HomeDailyCalendarDayEntity {
  const HomeDailyCalendarDayEntity({
    required this.dayLabel,
    required this.date,
    required this.progress,
    this.isToday = false,
  });

  final String dayLabel;
  final int date;
  final double progress;
  final bool isToday;
}
