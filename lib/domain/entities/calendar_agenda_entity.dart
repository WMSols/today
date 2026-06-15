import 'package:today/domain/entities/calendar_event_entity.dart';
import 'package:today/domain/entities/calendar_goal_task_entity.dart';

class CalendarAgendaEntity {
  const CalendarAgendaEntity({
    required this.events,
    required this.goalTasks,
    required this.timezone,
  });

  final List<CalendarEventEntity> events;
  final List<CalendarGoalTaskEntity> goalTasks;
  final String timezone;
}
