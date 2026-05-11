import 'package:today/domain/repositories/active_goal_repository.dart';

class CreateGoalUseCase {
  const CreateGoalUseCase(this._repository);

  final ActiveGoalRepository _repository;

  Future<void> call({
    required String goalText,
    required int durationDays,
    required String resetTimeLocal,
    required int tasksPerDay,
    String? timezone,
  }) {
    return _repository.createGoal(
      goalText: goalText,
      durationDays: durationDays,
      resetTimeLocal: resetTimeLocal,
      tasksPerDay: tasksPerDay,
      timezone: timezone,
    );
  }
}

