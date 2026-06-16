import 'package:today/data/models/calendar_event_model.dart';
import 'package:today/data/models/calendar_goal_task_model.dart';
import 'package:today/domain/entities/calendar_agenda_entity.dart';

class CalendarAgendaModel extends CalendarAgendaEntity {
  const CalendarAgendaModel({
    required super.events,
    required super.goalTasks,
    required super.timezone,
  });

  factory CalendarAgendaModel.fromJson(Map<String, dynamic> json) {
    final eventsRaw = json['events'] as List<dynamic>? ?? [];
    final goalTasksRaw = json['goal_tasks'] as List<dynamic>? ?? [];
    return CalendarAgendaModel(
      events: eventsRaw
          .whereType<Map<String, dynamic>>()
          .map(CalendarEventModel.fromJson)
          .toList(),
      goalTasks: goalTasksRaw
          .whereType<Map<String, dynamic>>()
          .map(CalendarGoalTaskModel.fromJson)
          .toList(),
      timezone: json['timezone'] as String? ?? '',
    );
  }
}
