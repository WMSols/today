import 'package:today/domain/entities/analytics_task_outcomes_entity.dart';
import 'package:today/domain/entities/analytics_week_at_a_glance_entity.dart';

/// Analytics tab payload synced from [AnalyticsRepository].
class AnalyticsDashboardEntity {
  const AnalyticsDashboardEntity({
    required this.productivityRatio,
    required this.previousWeekProductivityRatio,
    required this.goalsCount,
    required this.goalsTotal,
    required this.tasksCount,
    required this.tasksTotal,
    required this.weeklyProgress,
    required this.weeklyDayLabels,
    required this.taskOutcomes,
    required this.weekAtAGlance,
    required this.heatmapLevels,
    required this.heatmapWeekColumns,
    this.heatmapMaxLevel = 4,
  });

  final double productivityRatio;
  final double previousWeekProductivityRatio;
  final int goalsCount;
  final int goalsTotal;
  final int tasksCount;
  final int tasksTotal;
  final List<double> weeklyProgress;
  final List<String> weeklyDayLabels;
  final AnalyticsTaskOutcomesEntity taskOutcomes;
  final AnalyticsWeekAtAGlanceEntity weekAtAGlance;
  final List<int> heatmapLevels;
  final int heatmapWeekColumns;
  final int heatmapMaxLevel;

  int get heatmapRowCount => 7;
}
