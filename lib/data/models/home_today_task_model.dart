import 'package:today/domain/entities/home_today_task_entity.dart';

class HomeTodayTaskModel extends HomeTodayTaskEntity {
  const HomeTodayTaskModel({
    required super.id,
    required super.title,
    required super.timeLabel,
    super.status = HomeTodayTaskStatus.pending,
    super.source = HomeTodayTaskSource.calendarEvent,
    super.startAt,
    super.endAt,
    super.description,
    super.isRecurring = false,
  });

  factory HomeTodayTaskModel.fromJson(Map<String, dynamic> json) {
    return HomeTodayTaskModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      timeLabel: json['time_label'] as String? ?? '',
      status: _statusFromRaw(json['status'] as String?),
      source: _sourceFromRaw(json['source'] as String?),
      startAt: DateTime.tryParse(json['start_at'] as String? ?? ''),
      endAt: DateTime.tryParse(json['end_at'] as String? ?? ''),
      description: json['description'] as String?,
      isRecurring: json['is_recurring'] as bool? ?? false,
    );
  }

  static HomeTodayTaskSource _sourceFromRaw(String? raw) {
    if (raw == 'goal_task') return HomeTodayTaskSource.goalTask;
    return HomeTodayTaskSource.calendarEvent;
  }

  static HomeTodayTaskStatus _statusFromRaw(String? raw) {
    switch (raw) {
      case 'completed':
      case 'done':
        return HomeTodayTaskStatus.completed;
      case 'skipped':
        return HomeTodayTaskStatus.skipped;
      default:
        return HomeTodayTaskStatus.pending;
    }
  }
}
