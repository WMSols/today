import 'package:today/domain/entities/create_today_task_params.dart';
import 'package:today/domain/entities/home_today_task_entity.dart';
import 'package:today/domain/repositories/home_today_tasks_repository.dart';

class CreateTodayTaskUseCase {
  const CreateTodayTaskUseCase(this._repository);

  final HomeTodayTasksRepository _repository;

  Future<HomeTodayTaskEntity> call(CreateTodayTaskParams params) {
    return _repository.createTodayTask(params);
  }
}
