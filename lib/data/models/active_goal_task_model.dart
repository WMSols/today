import 'package:today/domain/entities/active_goal_task_entity.dart';

class ActiveGoalTaskModel extends ActiveGoalTaskEntity {
  const ActiveGoalTaskModel({
    required super.level,
    required super.title,
    required super.iconPath,
  });

  factory ActiveGoalTaskModel.fromJson(Map<String, dynamic> json) {
    return ActiveGoalTaskModel(
      level: json['level'] as String,
      title: json['title'] as String,
      iconPath: json['iconPath'] as String,
    );
  }
}
