import 'package:today/core/utils/app_formatter/app_formatter.dart';
import 'package:today/data/models/home_today_task_model.dart';
import 'package:today/domain/entities/calendar_agenda_entity.dart';
import 'package:today/domain/entities/calendar_event_entity.dart';
import 'package:today/domain/entities/calendar_goal_task_entity.dart';
import 'package:today/domain/entities/home_today_task_entity.dart';

abstract class CalendarAgendaMapper {
  CalendarAgendaMapper._();

  static List<HomeTodayTaskEntity> toTodayTasks(CalendarAgendaEntity agenda) {
    return <HomeTodayTaskEntity>[
      ...agenda.events.map(_fromEvent),
      ...agenda.goalTasks.map(_fromGoalTask),
    ];
  }

  static HomeTodayTaskEntity _fromEvent(CalendarEventEntity event) {
    return HomeTodayTaskModel(
      id: event.id,
      title: event.title,
      timeLabel: event.allDay ? 'All day' : AppFormatter.timeOfDay(event.start),
      status: _statusFromRaw(event.status),
      source: HomeTodayTaskSource.calendarEvent,
      startAt: event.start,
      endAt: event.end,
      description: event.description,
    );
  }

  static HomeTodayTaskEntity _fromGoalTask(CalendarGoalTaskEntity task) {
    return HomeTodayTaskModel(
      id: task.id,
      title: task.title,
      timeLabel: task.timeLabel ?? '',
      status: _statusFromRaw(task.status),
      source: HomeTodayTaskSource.goalTask,
      startAt: task.start,
      endAt: task.end,
      description: task.description,
    );
  }

  static HomeTodayTaskStatus _statusFromRaw(String? raw) {
    switch (raw) {
      case 'done':
      case 'completed':
        return HomeTodayTaskStatus.completed;
      case 'skipped':
        return HomeTodayTaskStatus.skipped;
      default:
        return HomeTodayTaskStatus.pending;
    }
  }
}
