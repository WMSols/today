class TaskActionResultEntity {
  const TaskActionResultEntity({
    required this.ok,
    this.already = false,
    this.earned,
    this.cost,
    this.balance,
  });

  final bool ok;
  final bool already;
  final int? earned;
  final int? cost;
  final int? balance;
}

