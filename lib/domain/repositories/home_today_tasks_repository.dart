import 'package:today/domain/entities/home_today_task_entity.dart';

abstract class HomeTodayTasksRepository {
  Future<List<HomeTodayTaskEntity>> getTodayTasks();
}
