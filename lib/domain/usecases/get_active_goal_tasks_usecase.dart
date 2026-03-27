import 'package:today/domain/entities/active_goal_task_entity.dart';
import 'package:today/domain/repositories/active_goal_repository.dart';

class GetActiveGoalTasksUseCase {
  const GetActiveGoalTasksUseCase(this._repository);

  final ActiveGoalRepository _repository;

  Future<List<ActiveGoalTaskEntity>> call() {
    return _repository.getActiveGoalTasks();
  }
}
