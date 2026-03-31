import 'package:today/domain/entities/subscription_plan_entity.dart';

abstract class SubscriptionRepository {
  Future<List<SubscriptionPlanEntity>> getPlans();
}
