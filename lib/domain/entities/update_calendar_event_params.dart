class UpdateCalendarEventParams {
  const UpdateCalendarEventParams({
    this.title,
    this.description,
    this.start,
    this.end,
    this.allDay,
    this.location,
  });

  final String? title;
  final String? description;
  final DateTime? start;
  final DateTime? end;
  final bool? allDay;
  final String? location;
}
