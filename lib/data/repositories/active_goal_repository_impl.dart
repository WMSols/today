import 'package:today/data/datasources/local/active_goal_local_data_source.dart';
import 'package:today/data/models/active_goal_task_model.dart';
import 'package:today/data/models/goal_card_model.dart';
import 'package:today/domain/entities/active_goal_task_entity.dart';
import 'package:today/domain/entities/goal_card_entity.dart';
import 'package:today/domain/repositories/active_goal_repository.dart';

class ActiveGoalRepositoryImpl implements ActiveGoalRepository {
  const ActiveGoalRepositoryImpl(this._localDataSource);

  final ActiveGoalLocalDataSource _localDataSource;

  @override
  Future<List<GoalCardEntity>> getGoalCards() async {
    final raw = await _localDataSource.getGoalCards();
    return raw.map(GoalCardModel.fromJson).toList();
  }

  @override
  Future<List<ActiveGoalTaskEntity>> getActiveGoalTasks() async {
    final raw = await _localDataSource.getActiveGoalTasks();
    return raw.map(ActiveGoalTaskModel.fromJson).toList();
  }
}
