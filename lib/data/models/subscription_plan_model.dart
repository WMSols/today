import 'package:today/domain/entities/subscription_plan_entity.dart';

class SubscriptionPlanModel extends SubscriptionPlanEntity {
  const SubscriptionPlanModel({
    required super.name,
    required super.subtitle,
    required super.price,
    required super.perks,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      name: json['name'] as String,
      subtitle: json['subtitle'] as String,
      price: json['price'] as String,
      perks: (json['perks'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }
}
