import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/constants/api_constants.dart';
import 'package:today/core/storage/today_schedule_store.dart';
import 'package:today/core/utils/app_helper/app_helper.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/common/app_action_dialog.dart';
import 'package:today/core/widgets/feedback/app_toast.dart';
import 'package:today/domain/entities/home_today_task_entity.dart';
import 'package:today/domain/entities/schedule_display_entity.dart';
import 'package:today/domain/entities/update_calendar_event_params.dart';
import 'package:today/domain/repositories/home_today_tasks_repository.dart';
import 'package:today/domain/usecases/complete_task_usecase.dart';
import 'package:today/domain/usecases/delete_calendar_event_usecase.dart';
import 'package:today/domain/usecases/delete_goal_task_usecase.dart';
import 'package:today/domain/usecases/skip_task_usecase.dart';
import 'package:today/domain/usecases/update_calendar_event_usecase.dart';
import 'package:today/domain/usecases/update_goal_task_usecase.dart';

class AgendaScheduleSlotRef {
  const AgendaScheduleSlotRef({
    required this.index,
    required this.dayDate,
    required this.slot,
  });

  final int index;
  final String dayDate;
  final ScheduleDisplaySlotEntity slot;
}

enum AgendaTaskFilter { all, calendar, goals }

class AgendaDayGroup {
  const AgendaDayGroup({required this.date, required this.tasks});

  final DateTime date;
  final List<HomeTodayTaskEntity> tasks;
}

class AgendaController extends GetxController with GetTickerProviderStateMixin {
  static const Duration _ringAnimationDuration = Duration(seconds: 2);

  AgendaController(
    this._scheduleStore,
    this._homeTodayTasksRepository,
    this._deleteCalendarEventUseCase,
    this._updateCalendarEventUseCase,
    this._completeTaskUseCase,
    this._skipTaskUseCase,
    this._updateGoalTaskUseCase,
    this._deleteGoalTaskUseCase,
  );

  final TodayScheduleStore _scheduleStore;
  final HomeTodayTasksRepository _homeTodayTasksRepository;
  final DeleteCalendarEventUseCase _deleteCalendarEventUseCase;
  final UpdateCalendarEventUseCase _updateCalendarEventUseCase;
  final CompleteTaskUseCase _completeTaskUseCase;
  final SkipTaskUseCase _skipTaskUseCase;
  final UpdateGoalTaskUseCase _updateGoalTaskUseCase;
  final DeleteGoalTaskUseCase _deleteGoalTaskUseCase;

  final Rx<AgendaTaskFilter> filter = AgendaTaskFilter.all.obs;
  final RxString selectedTaskId = ''.obs;
  final RxString selectedSlotKey = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;

  late final AnimationController progressRingAnimationController;
  final RxDouble progressRingAnimationFactor = 0.0.obs;

  bool get usesScheduleDisplay => _scheduleStore.usesScheduleDisplay;

  ScheduleDisplayEntity? get filteredScheduleDisplay {
    _scheduleStore.pinnedSchedule.value;
    final display = _scheduleStore.pinnedScheduleForUi;
    if (display == null) return null;

    final days = display.days
        .where((day) => AppHelper.isTodayOrFutureApiDate(day.date))
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
    _scheduleStore.agendaTasks.length;
    Iterable<HomeTodayTaskEntity> tasks = _scheduleStore.agendaTasks.where(
      (task) => AppHelper.isTodayOrFuture(task.startAt),
    );
    switch (filter.value) {
      case AgendaTaskFilter.calendar:
        return tasks
            .where((t) => t.source == HomeTodayTaskSource.calendarEvent)
            .toList(growable: false);
      case AgendaTaskFilter.goals:
        return tasks
            .where((t) => t.source == HomeTodayTaskSource.goalTask)
            .toList(growable: false);
      case AgendaTaskFilter.all:
        return _sortTasks(tasks.toList(growable: false));
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
    _initialLoad();
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
    selectedSlotKey.value = '';
    _playProgressRingAnimation();
  }

  List<AgendaScheduleSlotRef> get flatScheduleSlots {
    final display = filteredScheduleDisplay;
    if (display == null) return const [];

    final refs = <AgendaScheduleSlotRef>[];
    var index = 0;
    for (final day in AppHelper.scheduleDaysWithSlots(display)) {
      for (final slot in day.slots) {
        if (slot.title.trim().isEmpty) continue;
        refs.add(
          AgendaScheduleSlotRef(
            index: index,
            dayDate: day.date,
            slot: slot,
          ),
        );
        index++;
      }
    }
    return refs;
  }

  void selectScheduleSlot(int index) {
    final key = '$index';
    if (selectedSlotKey.value == key) {
      selectedSlotKey.value = '';
      return;
    }
    selectedSlotKey.value = key;
  }

  Future<void> onScheduleSlotEdit(int index) async {
    final task = linkedTaskForScheduleSlot(index);
    if (task == null || !task.isCalendarEvent) {
      AppToast.showError(AppTexts.calendarEventNotFound);
      return;
    }
    await onCalendarEventEdit(task);
  }

  Future<void> onScheduleSlotDelete(int index) async {
    final task = linkedTaskForScheduleSlot(index);
    if (task == null || !task.isCalendarEvent) {
      AppToast.showError(AppTexts.calendarEventNotFound);
      return;
    }
    final deleted = await deleteCalendarEvent(task);
    if (deleted) {
      await _removeScheduleSlotAt(index);
    }
  }

  void onScheduleSlotComplete(int index) {
    final ref = flatScheduleSlots.elementAtOrNull(index);
    if (ref == null) return;
    if (AppHelper.isCalendarScheduleSlot(ref.slot)) {
      final task = linkedTaskForScheduleSlot(index);
      if (task == null) {
        AppToast.showError(AppTexts.calendarEventNotFound);
        return;
      }
      onCalendarEventCompletePlaceholder(task);
      return;
    }
    onCalendarEventCompletePlaceholder(
      HomeTodayTaskEntity(
        id: '$index',
        title: ref.slot.title,
        timeLabel: ref.slot.time ?? '',
      ),
    );
  }

  void onScheduleSlotSkip(int index) {
    final ref = flatScheduleSlots.elementAtOrNull(index);
    if (ref == null) return;
    if (AppHelper.isCalendarScheduleSlot(ref.slot)) {
      final task = linkedTaskForScheduleSlot(index);
      if (task == null) {
        AppToast.showError(AppTexts.calendarEventNotFound);
        return;
      }
      onCalendarEventSkipPlaceholder(task);
      return;
    }
    onCalendarEventSkipPlaceholder(
      HomeTodayTaskEntity(
        id: '$index',
        title: ref.slot.title,
        timeLabel: ref.slot.time ?? '',
      ),
    );
  }

  HomeTodayTaskEntity? linkedTaskForScheduleSlot(int index) {
    final ref = flatScheduleSlots.elementAtOrNull(index);
    if (ref == null) return null;
    return _scheduleStore.linkedCalendarTaskForSlot(
      dayDate: ref.dayDate,
      slot: ref.slot,
    );
  }

  Future<void> _initialLoad() async {
    isLoading.value = true;
    try {
      await _scheduleStore.ensureLoaded();
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
      await _scheduleStore.refreshFromApi();
      _playProgressRingAnimation();
    } catch (_) {
      AppToast.showError(AppTexts.homeUnableLoadAgenda);
    } finally {
      isRefreshing.value = false;
    }
  }

  void selectTask(String taskId) {
    if (taskId.isEmpty) return;
    final task = _scheduleStore.taskById(taskId);
    if (task == null || !task.isPending) return;
    selectedTaskId.value = selectedTaskId.value == taskId ? '' : taskId;
  }

  Future<void> completeTask(String taskId) async {
    final task = _scheduleStore.taskById(taskId);
    if (task == null || !task.isGoalTask) return;

    if (ApiConstants.backendApiEnabled) {
      try {
        await _completeTaskUseCase(taskId);
        selectedTaskId.value = '';
        await _scheduleStore.applyGoalTaskStatus(
          taskId: taskId,
          status: HomeTodayTaskStatus.completed,
        );
        AppToast.showSuccess(AppTexts.toastTaskCompleted);
        _playProgressRingAnimation();
      } catch (_) {
        AppToast.showError(AppTexts.homeUnableCompleteTask);
      }
      return;
    }

    await _homeTodayTasksRepository.updateTodayTaskStatus(
      taskId: taskId,
      status: HomeTodayTaskStatus.completed,
    );
    await _scheduleStore.applyGoalTaskStatus(
      taskId: taskId,
      status: HomeTodayTaskStatus.completed,
    );
    selectedTaskId.value = '';
    AppToast.showSuccess(AppTexts.toastTaskCompleted);
    _playProgressRingAnimation();
  }

  Future<void> skipTask(String taskId) async {
    final task = _scheduleStore.taskById(taskId);
    if (task == null || !task.isGoalTask) return;

    if (ApiConstants.backendApiEnabled) {
      try {
        await _skipTaskUseCase(taskId);
        selectedTaskId.value = '';
        await _scheduleStore.applyGoalTaskStatus(
          taskId: taskId,
          status: HomeTodayTaskStatus.skipped,
        );
        AppToast.showError(AppTexts.toastTaskSkippedTitle);
        _playProgressRingAnimation();
      } catch (_) {
        AppToast.showError(AppTexts.homeUnableSkipTask);
      }
      return;
    }

    await _homeTodayTasksRepository.updateTodayTaskStatus(
      taskId: taskId,
      status: HomeTodayTaskStatus.skipped,
    );
    await _scheduleStore.applyGoalTaskStatus(
      taskId: taskId,
      status: HomeTodayTaskStatus.skipped,
    );
    selectedTaskId.value = '';
    AppToast.showError(AppTexts.toastTaskSkippedTitle);
    _playProgressRingAnimation();
  }

  Future<void> onCalendarEventLongPress(HomeTodayTaskEntity task) async {
    if (!task.isCalendarEvent) return;
    await deleteCalendarEvent(task);
  }

  Future<void> onCalendarEventEdit(HomeTodayTaskEntity task) async {
    if (!task.isCalendarEvent) return;
    final context = Get.context;
    if (context == null) return;

    var updateSeries = false;
    if (task.isRecurring) {
      final scope = await AppActionDialog.showRecurringScope(
        context,
        title: AppTexts.recurringEventTitle,
        subtitle: AppTexts.recurringEventEditSubtitle,
        seriesLabel: AppTexts.updateSeriesLabel,
      );
      if (scope == null) return;
      updateSeries = scope;
    }

    await AppActionDialog.showTextInput(
      context,
      title: AppTexts.editEventTitle,
      initialValue: task.title,
      onSubmit: (title) => updateCalendarEventTitle(
        task: task,
        title: title,
        updateSeries: updateSeries,
      ),
    );
  }

  Future<void> onGoalTaskEdit(HomeTodayTaskEntity task) async {
    if (!task.isGoalTask) return;
    final context = Get.context;
    if (context == null) return;
    await AppActionDialog.showTextInput(
      context,
      title: AppTexts.editGoalTaskTitle,
      subtitle: AppTexts.editGoalTaskSubtitle,
      initialValue: task.title,
      onSubmit: (title) => updateGoalTaskTitle(task: task, title: title),
    );
  }

  Future<void> onGoalTaskDelete(HomeTodayTaskEntity task) async {
    if (!task.isGoalTask) return;
    final context = Get.context;
    if (context == null) return;
    await AppActionDialog.showConfirm(
      context,
      title: AppTexts.deleteGoalTaskTitle,
      subtitle: AppTexts.deleteGoalTaskBody,
      confirmLabel: AppTexts.delete,
      onConfirm: () async {
        try {
          await _deleteGoalTaskUseCase(task.id);
          selectedTaskId.value = '';
          await _scheduleStore.applyGoalTaskDeleted(taskId: task.id);
          AppToast.showSuccess(AppTexts.goalTaskDeleted);
          _playProgressRingAnimation();
          return true;
        } catch (_) {
          AppToast.showError(AppTexts.goalTaskDeleteFailed);
          return false;
        }
      },
    );
  }

  Future<bool> deleteCalendarEvent(
    HomeTodayTaskEntity task, {
    bool? deleteSeries,
  }) async {
    if (!task.isCalendarEvent) return false;
    final context = Get.context;
    if (context == null) return false;

    var applyToSeries = deleteSeries ?? false;
    if (deleteSeries == null && task.isRecurring) {
      final scope = await AppActionDialog.showRecurringScope(
        context,
        title: AppTexts.recurringEventTitle,
        subtitle: AppTexts.recurringEventDeleteSubtitle,
        seriesLabel: AppTexts.deleteSeriesLabel,
      );
      if (scope == null) return false;
      applyToSeries = scope;
    }

    return AppActionDialog.showConfirm(
      context,
      title: AppTexts.deleteEventTitle,
      subtitle: AppTexts.deleteEventBody,
      confirmLabel: AppTexts.delete,
      onConfirm: () async {
        try {
          await _deleteCalendarEventUseCase(
            eventId: task.id,
            deleteSeries: applyToSeries,
          );
          selectedTaskId.value = '';
          selectedSlotKey.value = '';
          await _scheduleStore.applyCalendarEventDeleted(eventId: task.id);
          AppToast.showSuccess(AppTexts.calendarEventDeleted);
          _playProgressRingAnimation();
          return true;
        } catch (_) {
          AppToast.showError(AppTexts.calendarEventDeleteFailed);
          return false;
        }
      },
    );
  }

  void onCalendarEventCompletePlaceholder(HomeTodayTaskEntity task) {
    if (!task.isCalendarEvent) return;
    AppToast.showInformation(AppTexts.calendarEventCompleteNotImplemented);
  }

  void onCalendarEventSkipPlaceholder(HomeTodayTaskEntity task) {
    if (!task.isCalendarEvent) return;
    AppToast.showInformation(AppTexts.calendarEventSkipNotImplemented);
  }

  Future<bool> updateCalendarEventTitle({
    required HomeTodayTaskEntity task,
    required String title,
    bool updateSeries = false,
  }) async {
    try {
      await _updateCalendarEventUseCase(
        eventId: task.id,
        params: UpdateCalendarEventParams(title: title),
        updateSeries: updateSeries,
      );
      selectedSlotKey.value = '';
      await _scheduleStore.applyCalendarEventEdited(
        eventId: task.id,
        newTitle: title,
      );
      AppToast.showSuccess(AppTexts.calendarEventUpdated);
      _playProgressRingAnimation();
      return true;
    } catch (_) {
      AppToast.showError(AppTexts.calendarEventUpdateFailed);
      return false;
    }
  }

  Future<bool> updateGoalTaskTitle({
    required HomeTodayTaskEntity task,
    required String title,
  }) async {
    try {
      await _updateGoalTaskUseCase(taskId: task.id, title: title);
      selectedTaskId.value = '';
      await _scheduleStore.applyGoalTaskTitle(taskId: task.id, title: title);
      AppToast.showSuccess(AppTexts.goalTaskUpdated);
      _playProgressRingAnimation();
      return true;
    } catch (_) {
      AppToast.showError(AppTexts.goalTaskUpdateFailed);
      return false;
    }
  }

  Future<void> _removeScheduleSlotAt(int index) async {
    final ref = flatScheduleSlots.elementAtOrNull(index);
    final display = _scheduleStore.pinnedSchedule.value;
    if (ref == null || display == null) return;

    final updatedDays = display.days
        .map((day) {
          if (day.date != ref.dayDate) return day;
          final slots = day.slots
              .where(
                (slot) =>
                    slot.title != ref.slot.title || slot.time != ref.slot.time,
              )
              .toList(growable: false);
          return ScheduleDisplayDayEntity(
            date: day.date,
            weekday: day.weekday,
            slots: slots,
          );
        })
        .where((day) => day.slots.isNotEmpty)
        .toList(growable: false);

    final updated = ScheduleDisplayEntity(
      schema: display.schema,
      days: updatedDays,
    );
    selectedSlotKey.value = '';
    await _scheduleStore.setPinnedSchedule(updated);
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
