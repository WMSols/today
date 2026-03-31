class SubscriptionPlanEntity {
  const SubscriptionPlanEntity({
    required this.name,
    required this.subtitle,
    required this.price,
    required this.perks,
  });

  final String name;
  final String subtitle;
  final String price;
  final List<String> perks;
}
