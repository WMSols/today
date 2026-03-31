import 'package:today/data/datasources/local/subscription_local_data_source.dart';
import 'package:today/data/models/subscription_plan_model.dart';
import 'package:today/domain/entities/subscription_plan_entity.dart';
import 'package:today/domain/repositories/subscription_repository.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  const SubscriptionRepositoryImpl(this._localDataSource);

  final SubscriptionLocalDataSource _localDataSource;

  @override
  Future<List<SubscriptionPlanEntity>> getPlans() async {
    final raw = await _localDataSource.getPlans();
    return raw.map(SubscriptionPlanModel.fromJson).toList();
  }
}
