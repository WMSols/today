class CreateCalendarEventParams {
  const CreateCalendarEventParams({
    required this.title,
    required this.start,
    required this.end,
    this.description,
    this.allDay = false,
    this.location,
    this.isRecurring = false,
    this.repeatWeeks = 8,
  });

  final String title;
  final String? description;
  final DateTime start;
  final DateTime end;
  final bool allDay;
  final String? location;
  final bool isRecurring;
  final int repeatWeeks;
}
