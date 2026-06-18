class CalendarEventRecurrenceEntity {
  const CalendarEventRecurrenceEntity({
    required this.enabled,
    this.weeklyMode,
    this.skipDays = const [],
    this.repeatWeeks,
  });

  final bool enabled;
  final String? weeklyMode;
  final List<String> skipDays;
  final int? repeatWeeks;
}

class CalendarEventEntity {
  const CalendarEventEntity({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    this.description,
    this.allDay = false,
    this.location,
    this.status,
    this.recurrence,
    this.recurrenceId,
  });

  final String id;
  final String title;
  final DateTime start;
  final DateTime end;
  final String? description;
  final bool allDay;
  final String? location;
  final String? status;
  final CalendarEventRecurrenceEntity? recurrence;
  final String? recurrenceId;
}
