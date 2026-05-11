import 'package:today/domain/repositories/active_goal_repository.dart';

class DeleteGoalUseCase {
  const DeleteGoalUseCase(this._repository);

  final ActiveGoalRepository _repository;

  Future<void> call(String goalId) {
    return _repository.deleteGoal(goalId);
  }
}

