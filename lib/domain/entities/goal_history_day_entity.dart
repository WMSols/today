import 'package:today/domain/entities/active_goal_task_entity.dart';

class GoalHistoryDayEntity {
  const GoalHistoryDayEntity({
    required this.planDate,
    required this.planId,
    required this.total,
    required this.completed,
    required this.skipped,
    required this.pending,
    required this.tasks,
  });

  final String planDate;
  final String planId;
  final int total;
  final int completed;
  final int skipped;
  final int pending;
  final List<ActiveGoalTaskEntity> tasks;
}

