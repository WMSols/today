import 'package:today/data/datasources/local/goal_local_data_source.dart';
import 'package:today/data/models/goal_model.dart';
import 'package:today/domain/entities/goal_entity.dart';
import 'package:today/domain/repositories/goal_repository.dart';

class GoalRepositoryImpl implements GoalRepository {
  const GoalRepositoryImpl(this._localDataSource);

  final GoalLocalDataSource _localDataSource;

  @override
  Future<GoalEntity?> getPrimaryGoal() async {
    final raw = await _localDataSource.getPrimaryGoal();
    if (raw == null) return null;
    return GoalModel.fromJson(raw);
  }

  @override
  Future<void> saveGoal(GoalEntity goal) async {
    final model = GoalModel(
      id: goal.id,
      title: goal.title,
      createdAt: goal.createdAt,
    );
    await _localDataSource.saveGoal(model.toJson());
  }
}
