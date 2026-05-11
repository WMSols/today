import 'package:today/domain/entities/task_action_result_entity.dart';
import 'package:today/domain/repositories/active_goal_repository.dart';

class SkipTaskUseCase {
  const SkipTaskUseCase(this._repository);

  final ActiveGoalRepository _repository;

  Future<TaskActionResultEntity> call(String taskId) {
    return _repository.skipTask(taskId);
  }
}
