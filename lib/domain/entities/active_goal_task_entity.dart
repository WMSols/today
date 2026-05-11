class ActiveGoalTaskEntity {
  const ActiveGoalTaskEntity({
    required this.id,
    required this.level,
    required this.title,
    required this.iconPath,
    this.status = 'pending',
  });

  final String id;
  final String level;
  final String title;
  final String iconPath;
  final String status;
}
