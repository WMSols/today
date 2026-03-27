import 'package:today/domain/entities/active_goal_task_entity.dart';
import 'package:today/domain/entities/goal_card_entity.dart';

abstract class ActiveGoalRepository {
  Future<List<GoalCardEntity>> getGoalCards();
  Future<List<ActiveGoalTaskEntity>> getActiveGoalTasks();
}
