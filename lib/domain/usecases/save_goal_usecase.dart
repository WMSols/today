import 'package:today/domain/entities/goal_entity.dart';
import 'package:today/domain/repositories/goal_repository.dart';

class SaveGoalUseCase {
  const SaveGoalUseCase(this._repository);

  final GoalRepository _repository;

  Future<void> call(GoalEntity goal) {
    return _repository.saveGoal(goal);
  }
}
