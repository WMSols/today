import 'package:today/domain/entities/goal_card_entity.dart';

class GoalCardModel extends GoalCardEntity {
  const GoalCardModel({
    required super.title,
    required super.dayText,
    required super.tasksText,
    required super.percentText,
    required super.gemsText,
    required super.totalTasksText,
    required super.progress,
    required super.iconPath,
  });

  factory GoalCardModel.fromJson(Map<String, dynamic> json) {
    return GoalCardModel(
      title: json['title'] as String,
      dayText: json['dayText'] as String,
      tasksText: json['tasksText'] as String,
      percentText: json['percentText'] as String,
      gemsText: json['gemsText'] as String,
      totalTasksText: json['totalTasksText'] as String,
      progress: (json['progress'] as num).toDouble(),
      iconPath: json['iconPath'] as String,
    );
  }
}
