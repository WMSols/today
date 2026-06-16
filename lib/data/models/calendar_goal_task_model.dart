import 'package:today/core/utils/app_formatter/app_formatter.dart';
import 'package:today/domain/entities/calendar_goal_task_entity.dart';

class CalendarGoalTaskModel extends CalendarGoalTaskEntity {
  const CalendarGoalTaskModel({
    required super.id,
    required super.title,
    super.timeLabel,
    super.status,
    super.start,
    super.end,
    super.description,
  });

  factory CalendarGoalTaskModel.fromJson(Map<String, dynamic> json) {
    final start = AppFormatter.parseApiDateTime(
      json['start'] ?? json['start_at'],
    );
    final end = AppFormatter.parseApiDateTime(json['end'] ?? json['end_at']);
    final timeLabel =
        json['time_label'] as String? ??
        json['time'] as String? ??
        (start != null ? AppFormatter.timeOfDay(start) : null);

    return CalendarGoalTaskModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      timeLabel: timeLabel,
      status: json['status'] as String?,
      start: start,
      end: end,
      description: json['description'] as String?,
    );
  }
}
