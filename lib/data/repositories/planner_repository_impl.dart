import 'package:today/data/datasources/remote/planner_remote_data_source.dart';
import 'package:today/data/models/daily_task_model.dart';
import 'package:today/domain/entities/daily_task_entity.dart';
import 'package:today/domain/repositories/planner_repository.dart';

class PlannerRepositoryImpl implements PlannerRepository {
  const PlannerRepositoryImpl(this._remoteDataSource);

  final PlannerRemoteDataSource _remoteDataSource;

  @override
  Future<List<DailyTaskEntity>> getTodayPlan() async {
    final raw = await _remoteDataSource.fetchTodayPlan();
    return raw.map(DailyTaskModel.fromJson).toList();
  }
}
