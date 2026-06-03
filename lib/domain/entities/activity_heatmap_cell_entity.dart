/// One cell in the activity heatmap (week × weekday).
class ActivityHeatmapCellEntity {
  const ActivityHeatmapCellEntity({
    required this.weekIndex,
    required this.weekdayIndex,
    required this.intensity,
  });

  /// Column index, 0 = oldest week in the range.
  final int weekIndex;

  /// Row index, 0 = Sunday … 6 = Saturday.
  final int weekdayIndex;

  /// Activity level from 0 (none) through [maxIntensity].
  final int intensity;

  static const int maxIntensity = 4;
}
