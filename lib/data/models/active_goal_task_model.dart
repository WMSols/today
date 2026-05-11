import 'package:today/domain/entities/active_goal_task_entity.dart';

class ActiveGoalTaskModel extends ActiveGoalTaskEntity {
  const ActiveGoalTaskModel({
    required super.id,
    required super.level,
    required super.title,
    required super.iconPath,
    super.status,
  });

  factory ActiveGoalTaskModel.fromJson(Map<String, dynamic> json) {
    return ActiveGoalTaskModel(
      id: json['id'] as String,
      level: json['level'] as String,
      title: json['title'] as String,
      iconPath: json['iconPath'] as String,
      status: json['status'] as String? ?? 'pending',
    );
  }
}
