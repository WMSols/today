import 'package:today/domain/entities/daily_task_entity.dart';

abstract class PlannerRepository {
  Future<List<DailyTaskEntity>> getTodayPlan();
}
