import 'package:today/domain/entities/goal_entity.dart';

class GoalModel extends GoalEntity {
  const GoalModel({required super.id, required super.title, super.createdAt});

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'] as String,
      title: json['title'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
