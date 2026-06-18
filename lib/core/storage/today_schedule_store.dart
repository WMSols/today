import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:today/core/constants/api_constants.dart';
import 'package:today/core/constants/storage_keys.dart';
import 'package:today/core/storage/calendar_chat_history_storage.dart';
import 'package:today/core/storage/schedule_display_enricher.dart';
import 'package:today/core/utils/app_helper/app_helper.dart';
import 'package:today/data/mappers/calendar_agenda_mapper.dart';
import 'package:today/data/models/home_today_task_model.dart';
import 'package:today/domain/entities/home_today_task_entity.dart';
import 'package:today/domain/entities/schedule_display_entity.dart';
import 'package:today/domain/repositories/calendar_repository.dart';
import 'package:today/domain/repositories/home_today_tasks_repository.dart';
import 'package:today/presentation/controllers/planner/calendar_chat_session.dart';

/// Single source of truth for today's agenda tasks and pinned chat schedule.
class TodayScheduleStore extends GetxService {
  TodayScheduleStore(
    this._calendarRepository,
    this._homeTodayTasksRepository,
    this._chatHistoryStorage,
    this._prefs,
  );

  static const int futureDays = 90;

  final CalendarRepository _calendarRepository;
  final HomeTodayTasksRepository _homeTodayTasksRepository;
  final CalendarChatHistoryStorage _chatHistoryStorage;
  final SharedPreferences _prefs;

  final RxList<HomeTodayTaskEntity> agendaTasks = <HomeTodayTaskEntity>[].obs;
  final Rxn<ScheduleDisplayEntity> pinnedSchedule =
      Rxn<ScheduleDisplayEntity>();
  final RxBool isRefreshing = false.obs;
  final RxBool hasLoadedAgenda = false.obs;

  bool get usesScheduleDisplay {
    if (!ApiConstants.backendApiEnabled) return false;
    final display = pinnedSchedule.value;
    if (display == null) return false;
    return AppHelper.scheduleDaysWithSlots(display).isNotEmpty;
  }

  bool get hasPinnedSchedule => usesScheduleDisplay;

  /// Tasks scheduled for today (Home section).
  List<HomeTodayTaskEntity> get todayTasks {
    return agendaTasks
        .where((task) {
          final start = task.startAt;
          if (start == null) return true;
          return AppHelper.isSameDay(start, AppHelper.startOfToday());
        })
        .toList(growable: false);
  }

  /// Enriched + title-synced schedule for Agenda / chat UI.
  ScheduleDisplayEntity? get enrichedPinnedSchedule {
    final raw = pinnedSchedule.value;
    if (raw == null) return null;
    final days = AppHelper.scheduleDaysWithSlots(raw);
    if (days.isEmpty) return null;

    final base = ScheduleDisplayEntity(schema: raw.schema, days: days);
    final enriched = ScheduleDisplayEnricher.enrich(base, agendaTasks);
    return ScheduleDisplayEnricher.syncTitlesFromTasks(enriched, agendaTasks);
  }

  ScheduleDisplayEntity? get pinnedScheduleForUi => enrichedPinnedSchedule;

  @override
  void onInit() {
    super.onInit();
    _hydratePinnedFromStorage();
    _restoreAgendaFromDiskCache();
  }

  /// Loads agenda from memory/disk only — no network unless empty.
  Future<void> ensureLoaded() async {
    if (hasLoadedAgenda.value && agendaTasks.isNotEmpty) return;
    if (_restoreAgendaFromDiskCache()) return;

    if (!ApiConstants.backendApiEnabled) {
      await _loadStubAgenda();
      return;
    }

    await refreshFromApi();
  }

  /// Pull-to-refresh: always hits the agenda API.
  Future<void> refreshFromApi() async {
    if (isRefreshing.value) return;
    isRefreshing.value = true;
    try {
      if (!ApiConstants.backendApiEnabled) {
        await _loadStubAgenda();
        return;
      }

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final to = today.add(const Duration(days: futureDays));

      final agenda = await _calendarRepository.getAgenda(from: today, to: to);
      agendaTasks.assignAll(
        CalendarAgendaMapper.toTodayTasks(agenda).where((task) {
          return AppHelper.isTodayOrFuture(task.startAt);
        }),
      );
      hasLoadedAgenda.value = true;
      await _persistAgendaToDiskCache();
      _rebuildEnrichedPinnedInMemory();
    } finally {
      isRefreshing.value = false;
    }
  }

  Future<void> applyChatSchedule({
    required ScheduleDisplayEntity? display,
    int scheduleVersion = 0,
  }) async {
    final scheduleProvided = display != null;

    if (scheduleProvided) {
      final days = AppHelper.scheduleDaysWithSlots(display);
      if (days.isEmpty) {
        await _clearPinnedSchedule(persist: true);
      } else {
        pinnedSchedule.value = ScheduleDisplayEntity(
          schema: display.schema,
          days: days,
        );
        _rebuildEnrichedPinnedInMemory();
        await _persistPinnedToChatHistory();
      }
    }

    if (scheduleVersion > 0) {
      await _calendarRepository.applyScheduleVersion(scheduleVersion);
    }

    if (ApiConstants.backendApiEnabled &&
        (scheduleProvided || scheduleVersion > 0)) {
      await refreshFromApi();
    }
  }

  Future<void> setPinnedSchedule(
    ScheduleDisplayEntity display, {
    bool persist = true,
  }) async {
    pinnedSchedule.value = display;
    _rebuildEnrichedPinnedInMemory();
    if (persist) {
      await _persistPinnedToChatHistory();
    }
  }

  void clearPinnedSchedule() {
    pinnedSchedule.value = null;
  }

  Future<void> _clearPinnedSchedule({bool persist = true}) async {
    pinnedSchedule.value = null;
    if (!persist) return;

    final createTask = _chatHistoryStorage.loadCreateTaskChat();
    if (createTask?.scheduleDisplay != null) {
      await _chatHistoryStorage.saveCreateTaskChat(
        createTask!.copyWith(
          scheduleDisplay: null,
          updatedAt: DateTime.now(),
        ),
      );
    }

    final sessions = _chatHistoryStorage.loadSessions();
    if (sessions.isEmpty) return;

    var bestIndex = -1;
    DateTime? bestAt;
    for (var i = 0; i < sessions.length; i++) {
      final session = sessions[i];
      if (session.scheduleDisplay == null) continue;
      if (bestAt == null || session.updatedAt.isAfter(bestAt)) {
        bestAt = session.updatedAt;
        bestIndex = i;
      }
    }
    if (bestIndex < 0) return;

    final updated = List<CalendarChatSession>.from(sessions);
    updated[bestIndex] = updated[bestIndex].copyWith(
      scheduleDisplay: null,
      updatedAt: DateTime.now(),
    );
    await _chatHistoryStorage.saveSessions(updated);
  }

  Future<void> applyCalendarEventEdited({
    required String eventId,
    required String newTitle,
  }) async {
    _updateTaskInList(eventId, (task) => task.copyWith(title: newTitle));
    await _patchPinnedSchedule(
      (display) => ScheduleDisplayEnricher.updateEventTitle(
        display,
        eventId: eventId,
        newTitle: newTitle,
      ),
    );
    await _persistAgendaToDiskCache();
  }

  Future<void> applyCalendarEventDeleted({required String eventId}) async {
    agendaTasks.removeWhere((task) => task.id == eventId);
    agendaTasks.refresh();
    await _patchPinnedSchedule(
      (display) =>
          ScheduleDisplayEnricher.removeEvent(display, eventId: eventId) ??
          display,
    );
    await _persistAgendaToDiskCache();
  }

  Future<void> applyGoalTaskStatus({
    required String taskId,
    required HomeTodayTaskStatus status,
  }) async {
    _updateTaskInList(
      taskId,
      (task) => task.copyWith(status: status),
    );
    await _persistAgendaToDiskCache();
  }

  Future<void> applyGoalTaskTitle({
    required String taskId,
    required String title,
  }) async {
    _updateTaskInList(taskId, (task) => task.copyWith(title: title));
    await _persistAgendaToDiskCache();
  }

  Future<void> applyGoalTaskDeleted({required String taskId}) async {
    agendaTasks.removeWhere((task) => task.id == taskId);
    agendaTasks.refresh();
    await _persistAgendaToDiskCache();
  }

  Future<void> upsertCalendarTask(HomeTodayTaskEntity task) async {
    final index = agendaTasks.indexWhere((t) => t.id == task.id);
    if (index >= 0) {
      agendaTasks[index] = task;
    } else {
      agendaTasks.add(task);
    }
    agendaTasks.refresh();
    await _persistAgendaToDiskCache();
  }

  HomeTodayTaskEntity? linkedCalendarTaskForSlot({
    required String dayDate,
    required ScheduleDisplaySlotEntity slot,
  }) {
    return ScheduleDisplayEnricher.linkSlotToTask(
      dayDate: dayDate,
      slot: slot,
      events: agendaTasks.where((t) => t.isCalendarEvent).toList(),
    );
  }

  HomeTodayTaskEntity? taskById(String id) {
    for (final task in agendaTasks) {
      if (task.id == id) return task;
    }
    return null;
  }

  void _updateTaskInList(
    String taskId,
    HomeTodayTaskEntity Function(HomeTodayTaskEntity task) transform,
  ) {
    final index = agendaTasks.indexWhere((t) => t.id == taskId);
    if (index < 0) return;
    agendaTasks[index] = transform(agendaTasks[index]);
    agendaTasks.refresh();
  }

  void _rebuildEnrichedPinnedInMemory() {
    final enriched = enrichedPinnedSchedule;
    if (enriched != null) {
      pinnedSchedule.value = enriched;
    }
  }

  Future<void> _patchPinnedSchedule(
    ScheduleDisplayEntity Function(ScheduleDisplayEntity display) transform,
  ) async {
    final raw = pinnedSchedule.value;
    if (raw == null) return;
    final next = transform(raw);
    if (next == raw) return;
    pinnedSchedule.value = next;
    await _persistPinnedToChatHistory();
  }

  Future<void> _loadStubAgenda() async {
    final items = await _homeTodayTasksRepository.getTodayTasks();
    agendaTasks.assignAll(items);
    hasLoadedAgenda.value = true;
  }

  void _hydratePinnedFromStorage() {
    final createTask = _chatHistoryStorage.loadCreateTaskChat();
    final createDisplay = createTask?.scheduleDisplay;
    if (createDisplay != null &&
        AppHelper.scheduleDaysWithSlots(createDisplay).isNotEmpty) {
      pinnedSchedule.value = ScheduleDisplayEntity(
        schema: createDisplay.schema,
        days: AppHelper.scheduleDaysWithSlots(createDisplay),
      );
      return;
    }

    ScheduleDisplayEntity? best;
    DateTime? bestAt;
    for (final session in _chatHistoryStorage.loadSessions()) {
      final display = session.scheduleDisplay;
      if (display == null) continue;
      final days = AppHelper.scheduleDaysWithSlots(display);
      if (days.isEmpty) continue;
      if (bestAt == null || session.updatedAt.isAfter(bestAt)) {
        best = ScheduleDisplayEntity(schema: display.schema, days: days);
        bestAt = session.updatedAt;
      }
    }
    pinnedSchedule.value = best;
  }

  Future<void> _persistPinnedToChatHistory() async {
    final display = pinnedSchedule.value;
    if (display == null) return;

    final createTask = _chatHistoryStorage.loadCreateTaskChat();
    if (createTask?.scheduleDisplay != null) {
      await _chatHistoryStorage.saveCreateTaskChat(
        createTask!.copyWith(
          scheduleDisplay: display,
          updatedAt: DateTime.now(),
        ),
      );
    }

    final sessions = _chatHistoryStorage.loadSessions();
    if (sessions.isEmpty) return;

    var bestIndex = -1;
    DateTime? bestAt;
    for (var i = 0; i < sessions.length; i++) {
      final session = sessions[i];
      if (session.scheduleDisplay == null) continue;
      if (bestAt == null || session.updatedAt.isAfter(bestAt)) {
        bestAt = session.updatedAt;
        bestIndex = i;
      }
    }
    if (bestIndex < 0) return;

    final updated = List<CalendarChatSession>.from(sessions);
    updated[bestIndex] = updated[bestIndex].copyWith(
      scheduleDisplay: display,
      updatedAt: DateTime.now(),
    );
    await _chatHistoryStorage.saveSessions(updated);
  }

  bool _restoreAgendaFromDiskCache() {
    if (!ApiConstants.backendApiEnabled) return false;
    final raw = _prefs.getString(StorageKeys.agendaTasksCache);
    if (raw == null || raw.isEmpty) return false;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List<dynamic>) return false;
      final tasks = decoded
          .whereType<Map<String, dynamic>>()
          .map(HomeTodayTaskModel.fromJson)
          .toList(growable: false);
      if (tasks.isEmpty) return false;
      agendaTasks.assignAll(
        tasks.where((task) => AppHelper.isTodayOrFuture(task.startAt)),
      );
      hasLoadedAgenda.value = true;
      _rebuildEnrichedPinnedInMemory();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _persistAgendaToDiskCache() async {
    if (!ApiConstants.backendApiEnabled) return;
    final encoded = jsonEncode(
      agendaTasks
          .map(
            (task) => <String, dynamic>{
              'id': task.id,
              'title': task.title,
              'time_label': task.timeLabel,
              'status': _statusToRaw(task.status),
              'source': task.source == HomeTodayTaskSource.goalTask
                  ? 'goal_task'
                  : 'calendar_event',
              if (task.startAt != null)
                'start_at': task.startAt!.toIso8601String(),
              if (task.endAt != null) 'end_at': task.endAt!.toIso8601String(),
              if (task.description != null) 'description': task.description,
              'is_recurring': task.isRecurring,
            },
          )
          .toList(growable: false),
    );
    await _prefs.setString(StorageKeys.agendaTasksCache, encoded);
  }

  String _statusToRaw(HomeTodayTaskStatus status) {
    switch (status) {
      case HomeTodayTaskStatus.completed:
        return 'done';
      case HomeTodayTaskStatus.skipped:
        return 'skipped';
      case HomeTodayTaskStatus.pending:
        return 'pending';
    }
  }
}
