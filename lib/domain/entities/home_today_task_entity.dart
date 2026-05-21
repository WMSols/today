enum HomeTodayTaskStatus { pending, completed, skipped }

class HomeTodayTaskEntity {
  const HomeTodayTaskEntity({
    required this.id,
    required this.title,
    required this.timeLabel,
    this.status = HomeTodayTaskStatus.pending,
  });

  final String id;
  final String title;
  final String timeLabel;
  final HomeTodayTaskStatus status;

  bool get isPending => status == HomeTodayTaskStatus.pending;

  HomeTodayTaskEntity copyWith({
    String? id,
    String? title,
    String? timeLabel,
    HomeTodayTaskStatus? status,
  }) {
    return HomeTodayTaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      timeLabel: timeLabel ?? this.timeLabel,
      status: status ?? this.status,
    );
  }
}
