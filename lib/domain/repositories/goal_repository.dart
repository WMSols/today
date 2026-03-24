import 'package:today/domain/entities/goal_entity.dart';

abstract class GoalRepository {
  Future<void> saveGoal(GoalEntity goal);
  Future<GoalEntity?> getPrimaryGoal();
}
