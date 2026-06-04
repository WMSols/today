/// Input for manually creating a today task from [CreateTaskScreen].
class CreateTodayTaskParams {
  const CreateTodayTaskParams({
    required this.title,
    required this.scheduledDate,
    required this.startDateTime,
    required this.endDateTime,
    this.notes,
    this.isRecurring = false,
  });

  final String title;
  final String? notes;
  final DateTime scheduledDate;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final bool isRecurring;
}
