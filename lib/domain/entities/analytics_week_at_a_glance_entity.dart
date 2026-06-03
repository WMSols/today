/// Summary metrics derived from the current week's daily progress.
class AnalyticsWeekAtAGlanceEntity {
  const AnalyticsWeekAtAGlanceEntity({
    required this.averagePercent,
    required this.bestDayLabel,
    required this.worstDayLabel,
    required this.daysOnTrack,
    required this.daysTotal,
    required this.insight,
  });

  final int averagePercent;
  final String bestDayLabel;
  final String worstDayLabel;
  final int daysOnTrack;
  final int daysTotal;
  final String insight;

  bool get hasWeekData => daysTotal > 0;
}
