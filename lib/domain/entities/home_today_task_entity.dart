enum HomeTodayTaskSource { calendarEvent, goalTask }

enum HomeTodayTaskStatus { pending, completed, skipped }

class HomeTodayTaskEntity {
  const HomeTodayTaskEntity({
    required this.id,
    required this.title,
    required this.timeLabel,
    this.status = HomeTodayTaskStatus.pending,
    this.source = HomeTodayTaskSource.calendarEvent,
    this.startAt,
    this.endAt,
    this.description,
  });

  final String id;
  final String title;
  final String timeLabel;
  final HomeTodayTaskStatus status;
  final HomeTodayTaskSource source;
  final DateTime? startAt;
  final DateTime? endAt;
  final String? description;

  bool get isPending => status == HomeTodayTaskStatus.pending;

  bool get isCalendarEvent => source == HomeTodayTaskSource.calendarEvent;

  HomeTodayTaskEntity copyWith({
    String? id,
    String? title,
    String? timeLabel,
    HomeTodayTaskStatus? status,
    HomeTodayTaskSource? source,
    DateTime? startAt,
    DateTime? endAt,
    String? description,
  }) {
    return HomeTodayTaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      timeLabel: timeLabel ?? this.timeLabel,
      status: status ?? this.status,
      source: source ?? this.source,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      description: description ?? this.description,
    );
  }
}
