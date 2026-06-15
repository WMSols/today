import 'package:today/domain/entities/schedule_display_entity.dart';

class ScheduleDisplaySlotModel extends ScheduleDisplaySlotEntity {
  const ScheduleDisplaySlotModel({
    required super.title,
    super.description,
    super.time,
    super.status,
  });

  factory ScheduleDisplaySlotModel.fromJson(Map<String, dynamic> json) {
    return ScheduleDisplaySlotModel(
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      time: json['time'] as String?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    if (description != null) 'description': description,
    if (time != null) 'time': time,
    if (status != null) 'status': status,
  };
}

class ScheduleDisplayDayModel extends ScheduleDisplayDayEntity {
  const ScheduleDisplayDayModel({
    required super.date,
    super.weekday,
    super.slots = const [],
  });

  factory ScheduleDisplayDayModel.fromJson(Map<String, dynamic> json) {
    final slotsRaw = json['slots'] as List<dynamic>? ?? [];
    return ScheduleDisplayDayModel(
      date: json['date'] as String? ?? '',
      weekday: json['weekday'] as String?,
      slots: slotsRaw
          .whereType<Map<String, dynamic>>()
          .map(ScheduleDisplaySlotModel.fromJson)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date,
    if (weekday != null) 'weekday': weekday,
    'slots': slots
        .map((slot) => (slot as ScheduleDisplaySlotModel).toJson())
        .toList(),
  };
}

class ScheduleDisplayModel extends ScheduleDisplayEntity {
  const ScheduleDisplayModel({required super.schema, super.days = const []});

  factory ScheduleDisplayModel.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return const ScheduleDisplayModel(schema: '');
    }
    final daysRaw = json['days'] as List<dynamic>? ?? [];
    return ScheduleDisplayModel(
      schema: json['schema'] as String? ?? '',
      days: daysRaw
          .whereType<Map<String, dynamic>>()
          .map(ScheduleDisplayDayModel.fromJson)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'schema': schema,
    'days': days
        .map((day) => (day as ScheduleDisplayDayModel).toJson())
        .toList(),
  };
}
