import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/constants/api_constants.dart';
import 'package:today/core/storage/calendar_chat_history_storage.dart';
import 'package:today/core/storage/schedule_display_resolver.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/feedback/app_toast.dart';
import 'package:today/data/mappers/calendar_agenda_mapper.dart';
import 'package:today/domain/entities/home_today_task_entity.dart';
import 'package:today/domain/entities/schedule_display_entity.dart';
import 'package:today/domain/entities/update_calendar_event_params.dart';
import 'package:today/domain/repositories/home_today_tasks_repository.dart';
import 'package:today/domain/usecases/delete_calendar_event_usecase.dart';
import 'package:today/domain/usecases/get_calendar_agenda_usecase.dart';
import 'package:today/domain/usecases/update_calendar_event_usecase.dart';
import 'package:today/presentation/controllers/home/home_controller.dart';
import 'package:today/presentation/controllers/planner/create_task_controller.dart';
import 'package:today/presentation/controllers/planner/planner_controller.dart';

enum AgendaTaskFilter { all, calendar, goals }

class AgendaDayGroup {
  const AgendaDayGroup({required this.date, required this.tasks});

  final DateTime date;
  final List<HomeTodayTaskEntity> tasks;
}

class AgendaController extends GetxController with GetTickerProviderStateMixin {
  static const Duration _ringAnimationDuration = Duration(seconds: 2);
  static const int _pastDays = 14;
  static const int _futureDays = 90;

  AgendaController(
    this._getCalendarAgendaUseCase,
    this._homeTodayTasksRepository,
    this._deleteCalendarEventUseCase,
    this._updateCalendarEventUseCase,
    this._chatHistoryStorage,
  );

  final GetCalendarAgendaUseCase _getCalendarAgendaUseCase;
  final HomeTodayTasksRepository _homeTodayTasksRepository;
  final DeleteCalendarEventUseCase _deleteCalendarEventUseCase;
  final UpdateCalendarEventUseCase _updateCalendarEventUseCase;
  final CalendarChatHistoryStorage _chatHistoryStorage;

  final RxList<HomeTodayTaskEntity> allTasks = <HomeTodayTaskEntity>[].obs;
  final Rxn<ScheduleDisplayEntity> scheduleDisplay =
      Rxn<ScheduleDisplayEntity>();
  final Rx<AgendaTaskFilter> filter = AgendaTaskFilter.all.obs;
  final RxString selectedTaskId = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;

  late final AnimationController progressRingAnimationController;
  final RxDouble progressRingAnimationFactor = 0.0.obs;

  /// When true, list UI mirrors calendar chat `schedule_display` (not agenda API).
  bool get usesScheduleDisplay =>
      ApiConstants.backendApiEnabled && scheduleDisplay.value != null;

  ScheduleDisplayEntity? get filteredScheduleDisplay {
    final display = scheduleDisplay.value;
    if (display == null) return null;

    final days = display.days
        .map((day) {
          final slots = day.slots
              .where(
                (slot) =>
                    slot.title.trim().isNotEmpty &&
                    _slotMatchesFilter(slot.status, filter.value),
              )
              .toList(growable: false);
          if (slots.isEmpty) return null;
          return ScheduleDisplayDayEntity(
            date: day.date,
            weekday: day.weekday,
            slots: slots,
          );
        })
        .whereType<ScheduleDisplayDayEntity>()
        .toList(growable: false);

    if (days.isEmpty) return null;
    return ScheduleDisplayEntity(schema: display.schema, days: days);
  }

  List<HomeTodayTaskEntity> get filteredTasks {
    switch (filter.value) {
      case AgendaTaskFilter.calendar:
        return allTasks
            .where((t) => t.source == HomeTodayTaskSource.calendarEvent)
            .toList(growable: false);
      case AgendaTaskFilter.goals:
        return allTasks
            .where((t) => t.source == HomeTodayTaskSource.goalTask)
            .toList(growable: false);
      case AgendaTaskFilter.all:
        return allTasks.toList(growable: false);
    }
  }

  List<AgendaDayGroup> get groupedTasks {
    final byDay = <DateTime, List<HomeTodayTaskEntity>>{};
    for (final task in filteredTasks) {
      final start = task.startAt ?? DateTime.now();
      final day = DateTime(start.year, start.month, start.day);
      byDay.putIfAbsent(day, () => <HomeTodayTaskEntity>[]).add(task);
    }

    final days = byDay.keys.toList()..sort();
    return days
        .map((day) => AgendaDayGroup(date: day, tasks: _sortTasks(byDay[day]!)))
        .toList(growable: false);
  }

  int get totalCount {
    if (usesScheduleDisplay) {
      return _scheduleSlots(filteredScheduleDisplay).length;
    }
    return filteredTasks.length;
  }

  int get completedCount {
    if (usesScheduleDisplay) {
      return _scheduleSlots(
        filteredScheduleDisplay,
      ).where((slot) => _isCompletedSlotStatus(slot.status)).length;
    }
    return filteredTasks
        .where((t) => t.status == HomeTodayTaskStatus.completed)
        .length;
  }

  double get completionProgress {
    if (totalCount == 0) return 0;
    return (completedCount / totalCount).clamp(0.0, 1.0);
  }

  @override
  void onInit() {
    super.onInit();
    progressRingAnimationController = AnimationController(
      vsync: this,
      duration: _ringAnimationDuration,
    )..addListener(_syncProgressRingAnimationFactor);
    loadAgenda();
  }

  @override
  void onClose() {
    progressRingAnimationController.dispose();
    super.onClose();
  }

  void setFilter(AgendaTaskFilter value) {
    if (filter.value == value) return;
    filter.value = value;
    selectedTaskId.value = '';
    _playProgressRingAnimation();
  }

  Future<void> loadAgenda() async {
    isLoading.value = true;
    try {
      if (ApiConstants.backendApiEnabled) {
        final resolved = _resolveScheduleDisplay();
        if (resolved != null) {
          scheduleDisplay.value = resolved;
          allTasks.clear();
          _playProgressRingAnimation();
          return;
        }
        scheduleDisplay.value = null;
      }

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final from = today.subtract(const Duration(days: _pastDays));
      final to = today.add(const Duration(days: _futureDays));

      if (ApiConstants.backendApiEnabled) {
        final agenda = await _getCalendarAgendaUseCase(from: from, to: to);
        allTasks.assignAll(CalendarAgendaMapper.toTodayTasks(agenda));
      } else {
        allTasks.assignAll(await _homeTodayTasksRepository.getTodayTasks());
      }

      allTasks.assignAll(_sortTasks(allTasks));
      _playProgressRingAnimation();
    } catch (_) {
      AppToast.showError(AppTexts.homeUnableLoadAgenda);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshAgenda() async {
    isRefreshing.value = true;
    try {
      await loadAgenda();
      if (!usesScheduleDisplay && Get.isRegistered<HomeController>()) {
        await Get.find<HomeController>().refreshAgendaFromCalendar();
      }
    } finally {
      isRefreshing.value = false;
    }
  }

  ScheduleDisplayEntity? _resolveScheduleDisplay() {
    if (Get.isRegistered<CreateTaskController>()) {
      final live = Get.find<CreateTaskController>().pinnedScheduleDisplay;
      if (live != null) return live;
    }
    if (Get.isRegistered<PlannerController>()) {
      final live = Get.find<PlannerController>().pinnedScheduleDisplay;
      if (live != null) return live;
    }
    return ScheduleDisplayResolver(_chatHistoryStorage).resolve();
  }

  void selectTask(String taskId) {
    if (taskId.isEmpty) return;
    final task = allTasks.firstWhereOrNull((t) => t.id == taskId);
    if (task == null || !task.isPending) return;
    selectedTaskId.value = selectedTaskId.value == taskId ? '' : taskId;
  }

  Future<void> completeTask(String taskId) async {
    if (ApiConstants.backendApiEnabled) return;
    await _homeTodayTasksRepository.updateTodayTaskStatus(
      taskId: taskId,
      status: HomeTodayTaskStatus.completed,
    );
    _setTaskStatus(taskId, HomeTodayTaskStatus.completed);
    selectedTaskId.value = '';
    AppToast.showSuccess(AppTexts.toastTaskCompleted);
    _syncHomeTodayTasks();
  }

  Future<void> skipTask(String taskId) async {
    if (ApiConstants.backendApiEnabled) return;
    await _homeTodayTasksRepository.updateTodayTaskStatus(
      taskId: taskId,
      status: HomeTodayTaskStatus.skipped,
    );
    _setTaskStatus(taskId, HomeTodayTaskStatus.skipped);
    selectedTaskId.value = '';
    AppToast.showError(AppTexts.toastTaskSkippedTitle);
    _syncHomeTodayTasks();
  }

  Future<void> onCalendarEventLongPress(HomeTodayTaskEntity task) async {
    if (!task.isCalendarEvent) return;
    final context = Get.context;
    if (context == null) return;

    final delete = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppTexts.deleteEventTitle),
        content: Text(AppTexts.deleteEventBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(AppTexts.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(AppTexts.delete),
          ),
        ],
      ),
    );
    if (delete != true) return;

    try {
      await _deleteCalendarEventUseCase(eventId: task.id);
      selectedTaskId.value = '';
      await refreshAgenda();
      AppToast.showSuccess(AppTexts.calendarEventDeleted);
    } catch (_) {
      AppToast.showError(AppTexts.calendarEventDeleteFailed);
    }
  }

  Future<void> updateCalendarEventTitle({
    required HomeTodayTaskEntity task,
    required String title,
  }) async {
    try {
      await _updateCalendarEventUseCase(
        eventId: task.id,
        params: UpdateCalendarEventParams(title: title),
      );
      await refreshAgenda();
      AppToast.showSuccess(AppTexts.calendarEventUpdated);
    } catch (_) {
      AppToast.showError(AppTexts.calendarEventUpdateFailed);
    }
  }

  bool _slotMatchesFilter(String? status, AgendaTaskFilter value) {
    final normalized = (status ?? 'calendar').toLowerCase();
    switch (value) {
      case AgendaTaskFilter.calendar:
        return normalized == 'calendar' || normalized.isEmpty;
      case AgendaTaskFilter.goals:
        return normalized.contains('goal');
      case AgendaTaskFilter.all:
        return true;
    }
  }

  bool _isCompletedSlotStatus(String? status) {
    final normalized = (status ?? '').toLowerCase();
    return normalized == 'done' || normalized == 'completed';
  }

  List<ScheduleDisplaySlotEntity> _scheduleSlots(
    ScheduleDisplayEntity? display,
  ) {
    if (display == null) return const [];
    return display.days
        .expand((day) => day.slots)
        .where((slot) => slot.title.trim().isNotEmpty)
        .toList(growable: false);
  }

  void _setTaskStatus(String taskId, HomeTodayTaskStatus status) {
    final index = allTasks.indexWhere((t) => t.id == taskId);
    if (index < 0) return;
    allTasks[index] = allTasks[index].copyWith(status: status);
    allTasks.refresh();
    _playProgressRingAnimation();
  }

  void _syncHomeTodayTasks() {
    if (!Get.isRegistered<HomeController>()) return;
    Get.find<HomeController>().loadTodayTasks();
  }

  void _syncProgressRingAnimationFactor() {
    progressRingAnimationFactor.value = Curves.easeOutCubic.transform(
      progressRingAnimationController.value,
    );
  }

  void _playProgressRingAnimation() {
    progressRingAnimationController.forward(from: 0);
  }

  List<HomeTodayTaskEntity> _sortTasks(List<HomeTodayTaskEntity> tasks) {
    final sorted = List<HomeTodayTaskEntity>.from(tasks);
    sorted.sort((a, b) {
      final aStart = a.startAt;
      final bStart = b.startAt;
      if (aStart == null && bStart == null) return a.title.compareTo(b.title);
      if (aStart == null) return 1;
      if (bStart == null) return -1;
      final cmp = aStart.compareTo(bStart);
      if (cmp != 0) return cmp;
      return a.title.compareTo(b.title);
    });
    return sorted;
  }
}
