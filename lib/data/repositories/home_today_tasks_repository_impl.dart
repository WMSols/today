import 'package:today/data/datasources/remote/home_today_tasks_remote_data_source.dart';
import 'package:today/data/models/home_today_task_model.dart';
import 'package:today/domain/entities/home_today_task_entity.dart';
import 'package:today/domain/repositories/home_today_tasks_repository.dart';

class HomeTodayTasksRepositoryImpl implements HomeTodayTasksRepository {
  const HomeTodayTasksRepositoryImpl(this._remote);

  final HomeTodayTasksRemoteDataSource _remote;

  @override
  Future<List<HomeTodayTaskEntity>> getTodayTasks() async {
    final raw = await _remote.fetchTodayTasks();
    return raw.map(HomeTodayTaskModel.fromJson).toList();
  }

  @override
  Future<void> updateTodayTaskStatus({
    required String taskId,
    required HomeTodayTaskStatus status,
  }) async {
    await _remote.updateTaskStatus(taskId: taskId, status: status.name);
  }
}
