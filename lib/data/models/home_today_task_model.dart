import 'package:today/domain/entities/home_today_task_entity.dart';

class HomeTodayTaskModel extends HomeTodayTaskEntity {
  const HomeTodayTaskModel({
    required super.id,
    required super.title,
    required super.timeLabel,
    super.status = HomeTodayTaskStatus.pending,
  });

  factory HomeTodayTaskModel.fromJson(Map<String, dynamic> json) {
    return HomeTodayTaskModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      timeLabel: json['time_label'] as String? ?? '',
      status: _statusFromRaw(json['status'] as String?),
    );
  }

  static HomeTodayTaskStatus _statusFromRaw(String? raw) {
    switch (raw) {
      case 'completed':
        return HomeTodayTaskStatus.completed;
      case 'skipped':
        return HomeTodayTaskStatus.skipped;
      default:
        return HomeTodayTaskStatus.pending;
    }
  }
}
