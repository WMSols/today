import 'package:today/domain/entities/subscription_plan_entity.dart';
import 'package:today/domain/repositories/subscription_repository.dart';

class GetSubscriptionPlansUseCase {
  const GetSubscriptionPlansUseCase(this._repository);

  final SubscriptionRepository _repository;

  Future<List<SubscriptionPlanEntity>> call() {
    return _repository.getPlans();
  }
}
