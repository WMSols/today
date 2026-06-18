import 'package:today/core/utils/app_formatter/app_formatter.dart';
import 'package:today/domain/entities/calendar_event_entity.dart';

class CalendarEventRecurrenceModel extends CalendarEventRecurrenceEntity {
  const CalendarEventRecurrenceModel({
    required super.enabled,
    super.weeklyMode,
    super.skipDays = const [],
    super.repeatWeeks,
  });

  factory CalendarEventRecurrenceModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const CalendarEventRecurrenceModel(enabled: false);
    }
    final skipRaw = json['skip_days'] as List<dynamic>? ?? [];
    return CalendarEventRecurrenceModel(
      enabled: json['enabled'] as bool? ?? false,
      weeklyMode: json['weekly_mode'] as String?,
      skipDays: skipRaw.map((e) => e.toString()).toList(),
      repeatWeeks: (json['repeat_weeks'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson({required bool enabled, int repeatWeeks = 8}) {
    if (!enabled) {
      return <String, dynamic>{'enabled': false};
    }
    return <String, dynamic>{
      'enabled': true,
      'weekly_mode': weeklyMode ?? 'same_day',
      'skip_days': skipDays,
      'repeat_weeks': repeatWeeks,
    };
  }
}

class CalendarEventModel extends CalendarEventEntity {
  const CalendarEventModel({
    required super.id,
    required super.title,
    required super.start,
    required super.end,
    super.description,
    super.allDay = false,
    super.location,
    super.status,
    super.recurrence,
    super.recurrenceId,
  });

  factory CalendarEventModel.fromJson(Map<String, dynamic> json) {
    final recurrenceRaw = json['recurrence'];
    final recurrenceId = json['recurrence_id'] as String?;
    return CalendarEventModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      start: AppFormatter.parseApiDateTime(json['start']) ?? DateTime.now(),
      end: AppFormatter.parseApiDateTime(json['end']) ?? DateTime.now(),
      description: json['description'] as String?,
      allDay: json['all_day'] as bool? ?? false,
      location: json['location'] as String?,
      status: json['status'] as String?,
      recurrence: recurrenceRaw is Map<String, dynamic>
          ? CalendarEventRecurrenceModel.fromJson(recurrenceRaw)
          : null,
      recurrenceId: recurrenceId,
    );
  }
}
