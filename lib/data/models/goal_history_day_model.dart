import 'package:today/data/models/active_goal_task_model.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/domain/entities/goal_history_day_entity.dart';

class GoalHistoryDayModel extends GoalHistoryDayEntity {
  const GoalHistoryDayModel({
    required super.planDate,
    required super.planId,
    required super.total,
    required super.completed,
    required super.skipped,
    required super.pending,
    required super.tasks,
  });

  factory GoalHistoryDayModel.fromJson(Map<String, dynamic> json) {
    final rawTasks = json['tasks'] as List<dynamic>? ?? const [];
    return GoalHistoryDayModel(
      planDate: json['plan_date'] as String,
      planId: json['plan_id'] as String,
      total: (json['total'] as num?)?.toInt() ?? 0,
      completed: (json['completed'] as num?)?.toInt() ?? 0,
      skipped: (json['skipped'] as num?)?.toInt() ?? 0,
      pending: (json['pending'] as num?)?.toInt() ?? 0,
      tasks: rawTasks.map((e) {
        final task = e as Map<String, dynamic>;
        return ActiveGoalTaskModel(
          id: task['id'] as String,
          level: (task['difficulty'] as String? ?? 'medium').toUpperCase(),
          title: task['description'] as String? ?? '',
          iconPath: _iconByDifficulty(task['difficulty'] as String?),
          status: task['status'] as String? ?? 'pending',
        );
      }).toList(),
    );
  }

  static String _iconByDifficulty(String? difficulty) {
    switch ((difficulty ?? 'medium').toLowerCase()) {
      case 'easy':
        return AppImages.easyTasks;
      case 'hard':
        return AppImages.hardTasks;
      default:
        return AppImages.mediumTasks;
    }
  }
}
