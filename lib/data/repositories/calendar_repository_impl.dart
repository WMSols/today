import 'package:today/core/storage/calendar_cache_storage.dart';
import 'package:today/core/utils/app_helper/app_helper.dart';
import 'package:today/data/datasources/remote/calendar_remote_data_source.dart';
import 'package:today/data/mappers/calendar_agenda_mapper.dart';
import 'package:today/data/models/calendar_agenda_model.dart';
import 'package:today/data/models/calendar_chat_response_model.dart';
import 'package:today/data/models/calendar_event_model.dart';
import 'package:today/domain/entities/calendar_agenda_entity.dart';
import 'package:today/domain/entities/calendar_chat_response_entity.dart';
import 'package:today/domain/entities/calendar_event_entity.dart';
import 'package:today/domain/entities/create_calendar_event_params.dart';
import 'package:today/domain/entities/home_today_task_entity.dart';
import 'package:today/domain/entities/update_calendar_event_params.dart';
import 'package:today/domain/repositories/calendar_repository.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  const CalendarRepositoryImpl(this._remote, this._cache);

  final CalendarRemoteDataSource _remote;
  final CalendarCacheStorage _cache;

  @override
  Future<CalendarChatResponseEntity> sendChatMessage({
    required String message,
  }) async {
    final raw = await _remote.sendChatMessage(message: message);
    final response = CalendarChatResponseModel.fromJson(raw);
    await applyScheduleVersion(response.scheduleVersion);
    return response;
  }

  @override
  Future<CalendarAgendaEntity> getAgenda({
    required DateTime from,
    required DateTime to,
  }) async {
    final raw = await _remote.getAgenda(from: from, to: to);
    return CalendarAgendaModel.fromJson(raw);
  }

  @override
  Future<List<HomeTodayTaskEntity>> getTodayAgendaTasks() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final agenda = await getAgenda(from: today, to: today);
    return CalendarAgendaMapper.toTodayTasks(agenda);
  }

  @override
  Future<List<double>> getWeeklyProgress({DateTime? anchor}) async {
    final now = anchor ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekSunday = AppHelper.weekSundayStart(today);
    final weekSaturday = weekSunday.add(const Duration(days: 6));
    final agenda = await getAgenda(from: weekSunday, to: weekSaturday);

    final progress = List<double>.filled(7, 0);
    for (var i = 0; i < 7; i++) {
      final day = weekSunday.add(Duration(days: i));
      final dayKey = DateTime(day.year, day.month, day.day);
      final dayAgenda = CalendarAgendaModel(
        events: agenda.events
            .where((event) => _isSameDay(event.start, dayKey))
            .toList(),
        goalTasks: agenda.goalTasks.where((task) {
          final start = task.start;
          if (start == null) return false;
          return _isSameDay(start, dayKey);
        }).toList(),
        timezone: agenda.timezone,
      );
      final all = CalendarAgendaMapper.toTodayTasks(dayAgenda);
      if (all.isEmpty) {
        progress[i] = 0;
        continue;
      }
      final done = all
          .where((t) => t.status == HomeTodayTaskStatus.completed)
          .length;
      progress[i] = (done / all.length).clamp(0.0, 1.0);
    }
    return progress;
  }

  @override
  Future<CalendarEventEntity> createEvent(
    CreateCalendarEventParams params,
  ) async {
    final raw = await _remote.createEvent(params);
    final version = (raw['schedule_version'] as num?)?.toInt() ?? 0;
    if (version > 0) await applyScheduleVersion(version);

    final events = raw['events'] as List<dynamic>? ?? [];
    if (events.isNotEmpty && events.first is Map<String, dynamic>) {
      return CalendarEventModel.fromJson(<String, dynamic>{
        ...(events.first as Map<String, dynamic>),
        'title': params.title,
        'start': params.start.toIso8601String(),
        'end': params.end.toIso8601String(),
        'description': params.description,
      });
    }

    return CalendarEventModel(
      id: 'evt_local_${DateTime.now().millisecondsSinceEpoch}',
      title: params.title,
      start: params.start,
      end: params.end,
      description: params.description,
    );
  }

  @override
  Future<CalendarEventEntity> updateEvent({
    required String eventId,
    required UpdateCalendarEventParams params,
    bool updateSeries = false,
  }) async {
    final raw = await _remote.updateEvent(
      eventId: eventId,
      params: params,
      updateSeries: updateSeries,
    );
    final version = (raw['schedule_version'] as num?)?.toInt() ?? 0;
    if (version > 0) await applyScheduleVersion(version);

    final eventRaw = raw['event'];
    if (eventRaw is Map<String, dynamic>) {
      return CalendarEventModel.fromJson(eventRaw);
    }
    return CalendarEventModel(
      id: eventId,
      title: params.title ?? '',
      start: params.start ?? DateTime.now(),
      end: params.end ?? DateTime.now(),
      description: params.description,
    );
  }

  @override
  Future<int> deleteEvent({
    required String eventId,
    bool deleteSeries = false,
  }) async {
    final raw = await _remote.deleteEvent(
      eventId: eventId,
      deleteSeries: deleteSeries,
    );
    final version = (raw['schedule_version'] as num?)?.toInt() ?? 0;
    if (version > 0) await applyScheduleVersion(version);
    return (raw['deleted'] as num?)?.toInt() ?? 0;
  }

  @override
  Future<bool> applyScheduleVersion(int scheduleVersion) async {
    if (scheduleVersion <= 0) return false;
    final previous = await _cache.getScheduleVersion();
    if (previous != null && previous == scheduleVersion) return false;
    await _cache.saveScheduleVersion(scheduleVersion);
    return true;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
