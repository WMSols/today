import 'package:today/core/constants/api_constants.dart';
import 'package:today/core/utils/app_formatter/app_formatter.dart';
import 'package:today/data/datasources/remote/home_today_tasks_remote_data_source.dart';
import 'package:today/data/models/home_today_task_model.dart';
import 'package:today/domain/entities/create_calendar_event_params.dart';
import 'package:today/domain/entities/create_today_task_params.dart';
import 'package:today/domain/entities/home_today_task_entity.dart';
import 'package:today/domain/repositories/calendar_repository.dart';
import 'package:today/domain/repositories/home_today_tasks_repository.dart';

class HomeTodayTasksRepositoryImpl implements HomeTodayTasksRepository {
  const HomeTodayTasksRepositoryImpl(this._remote, this._calendarRepository);

  final HomeTodayTasksRemoteDataSource _remote;
  final CalendarRepository _calendarRepository;

  @override
  Future<List<HomeTodayTaskEntity>> getTodayTasks() async {
    if (ApiConstants.backendApiEnabled) {
      return _calendarRepository.getTodayAgendaTasks();
    }
    final raw = await _remote.fetchTodayTasks();
    return raw.map(HomeTodayTaskModel.fromJson).toList();
  }

  @override
  Future<HomeTodayTaskEntity> createTodayTask(
    CreateTodayTaskParams params,
  ) async {
    if (ApiConstants.backendApiEnabled) {
      final event = await _calendarRepository.createEvent(
        CreateCalendarEventParams(
          title: params.title.trim(),
          description: params.notes?.trim(),
          start: params.startDateTime,
          end: params.endDateTime,
          isRecurring: params.isRecurring,
        ),
      );
      return HomeTodayTaskModel(
        id: event.id,
        title: event.title,
        timeLabel: AppFormatter.timeOfDay(event.start),
        source: HomeTodayTaskSource.calendarEvent,
        startAt: event.start,
        endAt: event.end,
        description: event.description,
      );
    }

    final timeLabel = AppFormatter.timeOfDay(params.startDateTime);
    final raw = await _remote.createTask(
      title: params.title.trim(),
      timeLabel: timeLabel,
      scheduledDate: params.scheduledDate,
      startDateTime: params.startDateTime,
      endDateTime: params.endDateTime,
      notes: params.notes?.trim(),
      isRecurring: params.isRecurring,
    );
    return HomeTodayTaskModel.fromJson(raw);
  }

  @override
  Future<void> updateTodayTaskStatus({
    required String taskId,
    required HomeTodayTaskStatus status,
  }) async {
    if (ApiConstants.backendApiEnabled) {
      return;
    }
    await _remote.updateTaskStatus(
      taskId: taskId,
      status: _statusToRaw(status),
    );
  }

  String _statusToRaw(HomeTodayTaskStatus status) {
    switch (status) {
      case HomeTodayTaskStatus.completed:
        return 'completed';
      case HomeTodayTaskStatus.skipped:
        return 'skipped';
      case HomeTodayTaskStatus.pending:
        return 'pending';
    }
  }
}
