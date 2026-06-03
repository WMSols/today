/// Task completion breakdown for a time window (e.g. this week).
class AnalyticsTaskOutcomesEntity {
  const AnalyticsTaskOutcomesEntity({
    required this.completed,
    required this.skipped,
    required this.pending,
    required this.periodLabel,
  });

  final int completed;
  final int skipped;
  final int pending;
  final String periodLabel;

  int get total => completed + skipped + pending;

  bool get hasActivity => total > 0;
}
