import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/domain/entities/home_daily_calendar_day_entity.dart';
import 'package:today/domain/repositories/home_daily_calendar_repository.dart';
import 'package:today/domain/usecases/get_weekly_calendar_usecase.dart';

class AnalyticsController extends GetxController with GetTickerProviderStateMixin {
  static const Duration _calendarRingAnimationDuration = Duration(seconds: 2);

  AnalyticsController(this._getWeeklyCalendarUseCase);

  final GetWeeklyCalendarUseCase _getWeeklyCalendarUseCase;

  final RxList<HomeDailyCalendarDayEntity> calendarDays =
      <HomeDailyCalendarDayEntity>[].obs;

  late final AnimationController calendarRingAnimationController;
  final RxDouble calendarRingAnimationFactor = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    calendarRingAnimationController = AnimationController(
      vsync: this,
      duration: _calendarRingAnimationDuration,
    )..addListener(_syncCalendarRingAnimationFactor);
    loadWeeklyCalendar();
  }

  void _syncCalendarRingAnimationFactor() {
    calendarRingAnimationFactor.value = Curves.easeOutCubic.transform(
      calendarRingAnimationController.value,
    );
  }

  void _playCalendarRingAnimation() {
    calendarRingAnimationController.forward(from: 0);
  }

  @override
  void onClose() {
    calendarRingAnimationController.dispose();
    super.onClose();
  }

  Future<void> loadWeeklyCalendar() async {
    final days = await _getWeeklyCalendarUseCase(
      variant: HomeWeeklyCalendarVariant.stats,
    );
    calendarDays.assignAll(days);
    _playCalendarRingAnimation();
  }
}
