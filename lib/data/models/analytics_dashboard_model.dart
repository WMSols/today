import 'package:today/data/datasources/remote/analytics_remote_data_source.dart';
import 'package:today/domain/entities/analytics_dashboard_entity.dart';
import 'package:today/domain/entities/analytics_task_outcomes_entity.dart';
import 'package:today/domain/entities/analytics_week_at_a_glance_entity.dart';

class AnalyticsDashboardModel extends AnalyticsDashboardEntity {
  const AnalyticsDashboardModel({
    required super.productivityRatio,
    required super.previousWeekProductivityRatio,
    required super.goalsCount,
    required super.goalsTotal,
    required super.tasksCount,
    required super.tasksTotal,
    required super.weeklyProgress,
    required super.weeklyDayLabels,
    required super.taskOutcomes,
    required super.weekAtAGlance,
    required super.heatmapLevels,
    required super.heatmapWeekColumns,
    super.heatmapMaxLevel,
  });

  factory AnalyticsDashboardModel.fromJson(Map<String, dynamic> json) {
    final columns =
        json['heatmap_week_columns'] as int? ??
        AnalyticsRemoteDataSource.heatmapWeekColumns;
    final maxLevel =
        json['heatmap_max_level'] as int? ??
        AnalyticsRemoteDataSource.heatmapMaxLevel;

    final rawLevels = json['heatmap_levels'];
    final levels = rawLevels is List
        ? rawLevels.map((e) => (e as num).toInt()).toList(growable: false)
        : List<int>.filled(7 * columns, 0);

    final rawProgress = json['weekly_progress'];
    final weeklyProgress = rawProgress is List
        ? rawProgress.map((e) => (e as num).toDouble()).toList(growable: false)
        : const <double>[];

    final rawLabels = json['weekly_day_labels'];
    final weeklyDayLabels = rawLabels is List
        ? rawLabels.map((e) => e.toString()).toList(growable: false)
        : const <String>[];

    return AnalyticsDashboardModel(
      productivityRatio: (json['productivity_ratio'] as num?)?.toDouble() ?? 0,
      previousWeekProductivityRatio:
          (json['previous_week_productivity'] as num?)?.toDouble() ?? 0,
      goalsCount: (json['goals_count'] as num?)?.toInt() ?? 0,
      goalsTotal: (json['goals_total'] as num?)?.toInt() ?? 1,
      tasksCount: (json['tasks_count'] as num?)?.toInt() ?? 0,
      tasksTotal: (json['tasks_total'] as num?)?.toInt() ?? 1,
      weeklyProgress: weeklyProgress,
      weeklyDayLabels: weeklyDayLabels,
      taskOutcomes: _parseTaskOutcomes(json['task_outcomes']),
      weekAtAGlance: _parseWeekAtAGlance(json['week_at_a_glance']),
      heatmapLevels: levels,
      heatmapWeekColumns: columns,
      heatmapMaxLevel: maxLevel,
    );
  }

  static AnalyticsTaskOutcomesEntity _parseTaskOutcomes(dynamic raw) {
    if (raw is! Map) {
      return const AnalyticsTaskOutcomesEntity(
        completed: 0,
        skipped: 0,
        pending: 0,
        periodLabel: '',
      );
    }
    final map = raw;
    return AnalyticsTaskOutcomesEntity(
      completed: (map['completed'] as num?)?.toInt() ?? 0,
      skipped: (map['skipped'] as num?)?.toInt() ?? 0,
      pending: (map['pending'] as num?)?.toInt() ?? 0,
      periodLabel: map['period_label']?.toString() ?? '',
    );
  }

  static AnalyticsWeekAtAGlanceEntity _parseWeekAtAGlance(dynamic raw) {
    if (raw is! Map) {
      return const AnalyticsWeekAtAGlanceEntity(
        averagePercent: 0,
        bestDayLabel: '—',
        worstDayLabel: '—',
        daysOnTrack: 0,
        daysTotal: 0,
        insight: '',
      );
    }
    final map = raw;
    return AnalyticsWeekAtAGlanceEntity(
      averagePercent: (map['average_percent'] as num?)?.toInt() ?? 0,
      bestDayLabel: map['best_day_label']?.toString() ?? '—',
      worstDayLabel: map['worst_day_label']?.toString() ?? '—',
      daysOnTrack: (map['days_on_track'] as num?)?.toInt() ?? 0,
      daysTotal: (map['days_total'] as num?)?.toInt() ?? 0,
      insight: map['insight']?.toString() ?? '',
    );
  }
}
