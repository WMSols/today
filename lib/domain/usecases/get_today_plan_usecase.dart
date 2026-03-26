import 'package:today/domain/entities/daily_task_entity.dart';
import 'package:today/domain/repositories/planner_repository.dart';

class GetTodayPlanUseCase {
  const GetTodayPlanUseCase(this._repository);

  final PlannerRepository _repository;

  Future<List<DailyTaskEntity>> call() {
    return _repository.getTodayPlan();
  }
}
