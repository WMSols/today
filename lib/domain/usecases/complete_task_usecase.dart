import 'package:today/domain/entities/task_action_result_entity.dart';
import 'package:today/domain/repositories/active_goal_repository.dart';

class CompleteTaskUseCase {
  const CompleteTaskUseCase(this._repository);

  final ActiveGoalRepository _repository;

  Future<TaskActionResultEntity> call(String taskId) {
    return _repository.completeTask(taskId);
  }
}
