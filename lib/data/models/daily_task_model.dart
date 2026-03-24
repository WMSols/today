import 'package:today/domain/entities/daily_task_entity.dart';

class DailyTaskModel extends DailyTaskEntity {
  const DailyTaskModel({
    required super.id,
    required super.title,
    super.isCompleted,
  });

  factory DailyTaskModel.fromJson(Map<String, dynamic> json) {
    return DailyTaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}
