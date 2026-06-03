import 'dart:math' as math;

import 'package:today/core/network/demo_stub_data.dart';
import 'package:today/core/utils/app_formatter/app_formatter.dart';
import 'package:today/core/utils/app_helper/app_helper.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';

class AnalyticsRemoteDataSource {
  const AnalyticsRemoteDataSource();

  static const int heatmapWeekColumns = 53;
  static const int heatmapMaxLevel = 4;

  Future<Map<String, dynamic>> fetchDashboard({DateTime? anchor}) async {
    final now = anchor ?? DateTime.now();
    final weekSunday = AppHelper.weekSundayStart(
      DateTime(now.year, now.month, now.day),
    );

    final refreshTick =
        now.millisecondsSinceEpoch ~/
        3000 %
        DemoStubData.analyticsWeeklyProgressByDay.length;
    final weeklyProgress = List<double>.generate(
      DemoStubData.analyticsWeeklyProgressByDay.length,
      (index) =>
          DemoStubData.analyticsWeeklyProgressByDay[(index + refreshTick) %
              DemoStubData.analyticsWeeklyProgressByDay.length],
    );
    final weeklyDayLabels = List<String>.generate(
      weeklyProgress.length,
      (index) => AppHelper.dayLabelFor(weekSunday.add(Duration(days: index))),
    );

    final productivityRatio = AppHelper.averageProgress(weeklyProgress);
    final taskOutcomes = DemoStubData.todayTaskOutcomes;

    return <String, dynamic>{
      'productivity_ratio': productivityRatio,
      'previous_week_productivity': DemoStubData.previousWeekProductivityRatio,
      'goals_count': DemoStubData.countGoalsFullyCompleteForToday(),
      'goals_total': DemoStubData.activeGoalsCount,
      'tasks_count': DemoStubData.todayTasksCompletedCount,
      'tasks_total': DemoStubData.todayTasksCount,
      'weekly_progress': weeklyProgress,
      'weekly_day_labels': weeklyDayLabels,
      'task_outcomes': <String, dynamic>{
        'completed': taskOutcomes.completed,
        'skipped': taskOutcomes.skipped,
        'pending': taskOutcomes.pending,
        'period_label': AppTexts.analyticsTaskOutcomesPeriodLabel,
      },
      'week_at_a_glance': _buildWeekAtAGlance(
        weekSunday: weekSunday,
        weeklyProgress: weeklyProgress,
      ),
      'heatmap_week_columns': heatmapWeekColumns,
      'heatmap_max_level': heatmapMaxLevel,
      'heatmap_levels': _generateHeatmapLevels(now),
    };
  }

  Map<String, dynamic> _buildWeekAtAGlance({
    required DateTime weekSunday,
    required List<double> weeklyProgress,
  }) {
    if (weeklyProgress.isEmpty) {
      return <String, dynamic>{
        'average_percent': 0,
        'best_day_label': '—',
        'worst_day_label': '—',
        'days_on_track': 0,
        'days_total': 0,
        'insight': AppTexts.analyticsWeekAtAGlanceEmptyInsight,
      };
    }

    var bestIndex = 0;
    var worstIndex = 0;
    for (var i = 0; i < weeklyProgress.length; i++) {
      if (weeklyProgress[i] > weeklyProgress[bestIndex]) bestIndex = i;
      if (weeklyProgress[i] < weeklyProgress[worstIndex]) worstIndex = i;
    }

    final daysOnTrack = weeklyProgress
        .where((p) => p >= AppHelper.successThreshold)
        .length;
    final averagePercent = (AppHelper.averageProgress(weeklyProgress) * 100)
        .round();
    final bestDay = _dayName(weekSunday, bestIndex);
    final worstDay = _dayName(weekSunday, worstIndex);
    final worstPercent = (weeklyProgress[worstIndex] * 100).round();

    return <String, dynamic>{
      'average_percent': averagePercent,
      'best_day_label': bestDay,
      'worst_day_label': worstDay,
      'days_on_track': daysOnTrack,
      'days_total': weeklyProgress.length,
      'insight': AppTexts.analyticsWeekAtAGlanceInsight(worstDay, worstPercent),
    };
  }

  String _dayName(DateTime weekSunday, int dayIndex) {
    final date = weekSunday.add(Duration(days: dayIndex));
    return AppFormatter.dayNameShort(date.weekday);
  }

  List<int> _generateHeatmapLevels(DateTime anchor) {
    const rows = 7;
    const cols = heatmapWeekColumns;
    final levels = List<int>.filled(rows * cols, 0);
    final seed = anchor.millisecondsSinceEpoch ~/ 1000;

    for (var col = 0; col < cols; col++) {
      for (var row = 0; row < rows; row++) {
        final index = row * cols + col;
        final noise = ((seed + col * 17 + row * 31) % 100) / 100.0;
        final wave =
            (math.sin((col / cols) * math.pi * 4 + row * 0.9 + noise) + 1) / 2;
        if (wave < 0.12) {
          levels[index] = 0;
        } else if (wave < 0.35) {
          levels[index] = 1;
        } else if (wave < 0.58) {
          levels[index] = 2;
        } else if (wave < 0.78) {
          levels[index] = 3;
        } else {
          levels[index] = heatmapMaxLevel;
        }
      }
    }
    return levels;
  }
}
