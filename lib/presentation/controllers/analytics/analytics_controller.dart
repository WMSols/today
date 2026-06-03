import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/domain/entities/analytics_dashboard_entity.dart';
import 'package:today/domain/entities/analytics_task_outcomes_entity.dart';
import 'package:today/domain/entities/analytics_week_at_a_glance_entity.dart';
import 'package:today/domain/usecases/get_analytics_dashboard_usecase.dart';

class AnalyticsController extends GetxController
    with GetTickerProviderStateMixin {
  static const Duration _chartAnimationDuration = Duration(seconds: 2);

  AnalyticsController(this._getAnalyticsDashboardUseCase);

  final GetAnalyticsDashboardUseCase _getAnalyticsDashboardUseCase;

  final Rxn<AnalyticsDashboardEntity> dashboard =
      Rxn<AnalyticsDashboardEntity>();
  final RxBool isLoading = false.obs;

  /// Bumped after each successful fetch so child charts rebuild on refresh.
  final RxInt dashboardRevision = 0.obs;

  late final AnimationController chartAnimationController;
  final RxDouble chartAnimationFactor = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    chartAnimationController = AnimationController(
      vsync: this,
      duration: _chartAnimationDuration,
    )..addListener(_syncChartAnimationFactor);
    loadDashboard();
  }

  void _syncChartAnimationFactor() {
    chartAnimationFactor.value = Curves.easeOutCubic.transform(
      chartAnimationController.value,
    );
  }

  void _playChartAnimation() {
    chartAnimationController.forward(from: 0);
  }

  @override
  void onClose() {
    chartAnimationController.dispose();
    super.onClose();
  }

  Future<void> refreshAnalytics() => loadDashboard();

  Future<void> loadDashboard() async {
    isLoading.value = true;
    try {
      dashboard.value = await _getAnalyticsDashboardUseCase(
        anchor: DateTime.now(),
      );
      dashboardRevision.value++;
      _playChartAnimation();
    } finally {
      isLoading.value = false;
    }
  }

  AnalyticsDashboardEntity? get _data => dashboard.value;

  double get productivityRatio => _data?.productivityRatio ?? 0;

  int get productivityPercent => (productivityRatio * 100).round();

  String get productivityPercentLabel => '$productivityPercent%';

  double get _previousWeekProductivityRatio =>
      _data?.previousWeekProductivityRatio ?? 0;

  double get productivityChangePoints =>
      (productivityRatio - _previousWeekProductivityRatio) * 100;

  bool get isProductivityTrendUp => productivityChangePoints > 0.05;

  bool get isProductivityTrendDown => productivityChangePoints < -0.05;

  String get productivityTrendLabel {
    final points = productivityChangePoints;
    final abs = points.abs().round();
    final sign = points >= 0 ? '+' : '-';
    return '$sign$abs%';
  }

  int get productivityGoalsCount => _data?.goalsCount ?? 0;

  int get productivityGoalsTotal => (_data?.goalsTotal ?? 1).clamp(1, 999);

  int get productivityTasksCount => _data?.tasksCount ?? 0;

  int get productivityTasksTotal => (_data?.tasksTotal ?? 1).clamp(1, 999);

  List<double> get weeklyProgress => _data?.weeklyProgress ?? const <double>[];

  List<String> get weeklyDayLabels =>
      _data?.weeklyDayLabels ?? const <String>[];

  List<int> get heatmapLevels => _data?.heatmapLevels ?? const <int>[];

  int get heatmapWeekColumns => _data?.heatmapWeekColumns ?? 53;

  int get heatmapMaxLevel => _data?.heatmapMaxLevel ?? 4;

  AnalyticsTaskOutcomesEntity get taskOutcomes =>
      _data?.taskOutcomes ??
      const AnalyticsTaskOutcomesEntity(
        completed: 0,
        skipped: 0,
        pending: 0,
        periodLabel: '',
      );

  AnalyticsWeekAtAGlanceEntity get weekAtAGlance =>
      _data?.weekAtAGlance ??
      const AnalyticsWeekAtAGlanceEntity(
        averagePercent: 0,
        bestDayLabel: '—',
        worstDayLabel: '—',
        daysOnTrack: 0,
        daysTotal: 0,
        insight: '',
      );
}
