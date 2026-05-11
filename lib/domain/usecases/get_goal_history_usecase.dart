import 'package:today/domain/entities/goal_history_day_entity.dart';
import 'package:today/domain/repositories/active_goal_repository.dart';

class GetGoalHistoryUseCase {
  const GetGoalHistoryUseCase(this._repository);

  final ActiveGoalRepository _repository;

  Future<List<GoalHistoryDayEntity>> call(String goalId) {
    return _repository.getGoalHistory(goalId);
  }
}
