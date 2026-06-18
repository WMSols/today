import 'package:today/data/models/schedule_display_model.dart';
import 'package:today/domain/entities/schedule_display_entity.dart';

class CalendarChatMessage {
  const CalendarChatMessage({required this.isUser, required this.text});

  final bool isUser;
  final String text;

  Map<String, dynamic> toJson() => {'is_user': isUser, 'text': text};

  factory CalendarChatMessage.fromJson(Map<String, dynamic> json) {
    return CalendarChatMessage(
      isUser: json['is_user'] as bool? ?? false,
      text: json['text'] as String? ?? '',
    );
  }
}

class CalendarChatSession {
  const CalendarChatSession({
    required this.id,
    required this.title,
    required this.preview,
    required this.updatedAt,
    required this.messages,
    this.scheduleDisplay,
    this.scheduleMessageAnchor,
  });

  final String id;
  final String title;
  final String preview;
  final DateTime updatedAt;
  final List<CalendarChatMessage> messages;
  final ScheduleDisplayEntity? scheduleDisplay;
  final int? scheduleMessageAnchor;

  CalendarChatSession copyWith({
    String? id,
    String? title,
    String? preview,
    DateTime? updatedAt,
    List<CalendarChatMessage>? messages,
    ScheduleDisplayEntity? scheduleDisplay,
    int? scheduleMessageAnchor,
  }) {
    return CalendarChatSession(
      id: id ?? this.id,
      title: title ?? this.title,
      preview: preview ?? this.preview,
      updatedAt: updatedAt ?? this.updatedAt,
      messages: messages ?? this.messages,
      scheduleDisplay: scheduleDisplay ?? this.scheduleDisplay,
      scheduleMessageAnchor:
          scheduleMessageAnchor ?? this.scheduleMessageAnchor,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'preview': preview,
      'updated_at': updatedAt.toIso8601String(),
      'messages': messages.map((m) => m.toJson()).toList(),
      if (scheduleMessageAnchor != null)
        'schedule_message_anchor': scheduleMessageAnchor,
      if (scheduleDisplay != null)
        'schedule_display': ScheduleDisplayModel(
          schema: scheduleDisplay!.schema,
          days: scheduleDisplay!.days
              .map(
                (day) => ScheduleDisplayDayModel(
                  date: day.date,
                  weekday: day.weekday,
                  slots: day.slots
                      .map(
                        (slot) => ScheduleDisplaySlotModel(
                          title: slot.title,
                          description: slot.description,
                          time: slot.time,
                          status: slot.status,
                          eventId: slot.eventId,
                        ),
                      )
                      .toList(),
                ),
              )
              .toList(),
        ).toJson(),
    };
  }

  factory CalendarChatSession.fromJson(Map<String, dynamic> json) {
    final messagesRaw = json['messages'] as List<dynamic>? ?? [];
    final scheduleRaw = json['schedule_display'];
    return CalendarChatSession(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      preview: json['preview'] as String? ?? '',
      updatedAt:
          DateTime.tryParse(json['updated_at'] as String? ?? '') ??
          DateTime.now(),
      messages: messagesRaw
          .whereType<Map<String, dynamic>>()
          .map(CalendarChatMessage.fromJson)
          .toList(),
      scheduleDisplay: scheduleRaw is Map<String, dynamic>
          ? ScheduleDisplayModel.fromJson(scheduleRaw)
          : null,
      scheduleMessageAnchor: json['schedule_message_anchor'] as int?,
    );
  }
}
