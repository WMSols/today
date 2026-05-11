import 'package:today/domain/entities/active_goal_task_entity.dart';
import 'package:today/domain/entities/goal_card_entity.dart';
import 'package:today/domain/entities/goal_history_day_entity.dart';
import 'package:today/domain/entities/task_action_result_entity.dart';

abstract class ActiveGoalRepository {
  Future<void> createGoal({
    required String goalText,
    required int durationDays,
    required String resetTimeLocal,
    required int tasksPerDay,
    String? timezone,
  });

  Future<List<GoalCardEntity>> getGoalCards();
  Future<List<ActiveGoalTaskEntity>> getActiveGoalTasks(String goalId);
  Future<List<GoalHistoryDayEntity>> getGoalHistory(String goalId);
  Future<void> deleteGoal(String goalId);
  Future<TaskActionResultEntity> completeTask(String taskId);
  Future<TaskActionResultEntity> skipTask(String taskId);
}
