class GoalCardEntity {
  const GoalCardEntity({
    required this.title,
    required this.dayText,
    required this.tasksText,
    required this.percentText,
    required this.gemsText,
    required this.totalTasksText,
    required this.progress,
    required this.iconPath,
  });

  final String title;
  final String dayText;
  final String tasksText;
  final String percentText;
  final String gemsText;
  final String totalTasksText;
  final double progress;
  final String iconPath;
}
