import 'package:today/domain/entities/create_today_task_params.dart';
import 'package:today/domain/entities/home_today_task_entity.dart';

abstract class HomeTodayTasksRepository {
  Future<List<HomeTodayTaskEntity>> getTodayTasks();

  Future<HomeTodayTaskEntity> createTodayTask(CreateTodayTaskParams params);

  Future<void> updateTodayTaskStatus({
    required String taskId,
    required HomeTodayTaskStatus status,
  });
}
