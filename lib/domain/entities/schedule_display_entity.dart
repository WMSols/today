class ScheduleDisplaySlotEntity {
  const ScheduleDisplaySlotEntity({
    required this.title,
    this.description,
    this.time,
    this.status,
    this.eventId,
  });

  final String title;
  final String? description;
  final String? time;
  final String? status;
  final String? eventId;
}

class ScheduleDisplayDayEntity {
  const ScheduleDisplayDayEntity({
    required this.date,
    this.weekday,
    this.slots = const [],
  });

  final String date;
  final String? weekday;
  final List<ScheduleDisplaySlotEntity> slots;
}

class ScheduleDisplayEntity {
  const ScheduleDisplayEntity({required this.schema, this.days = const []});

  final String schema;
  final List<ScheduleDisplayDayEntity> days;
}
