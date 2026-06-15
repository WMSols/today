class CalendarGoalTaskEntity {
  const CalendarGoalTaskEntity({
    required this.id,
    required this.title,
    this.timeLabel,
    this.status,
    this.start,
    this.end,
    this.description,
  });

  final String id;
  final String title;
  final String? timeLabel;
  final String? status;
  final DateTime? start;
  final DateTime? end;
  final String? description;
}
