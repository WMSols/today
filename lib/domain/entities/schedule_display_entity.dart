class ScheduleDisplaySlotEntity {
  const ScheduleDisplaySlotEntity({
    required this.title,
    this.description,
    this.time,
    this.status,
  });

  final String title;
  final String? description;
  final String? time;
  final String? status;
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
