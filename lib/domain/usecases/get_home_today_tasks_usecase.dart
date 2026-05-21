import 'package:today/domain/entities/home_today_task_entity.dart';
import 'package:today/domain/repositories/home_today_tasks_repository.dart';

class GetHomeTodayTasksUseCase {
  const GetHomeTodayTasksUseCase(this._repository);

  final HomeTodayTasksRepository _repository;

  Future<List<HomeTodayTaskEntity>> call() => _repository.getTodayTasks();
}
