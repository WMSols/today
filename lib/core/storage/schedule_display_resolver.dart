import 'package:today/core/storage/calendar_chat_history_storage.dart';
import 'package:today/core/utils/app_helper/app_helper.dart';
import 'package:today/domain/entities/schedule_display_entity.dart';

/// Resolves the most recent [ScheduleDisplayEntity] persisted from calendar chat.
class ScheduleDisplayResolver {
  const ScheduleDisplayResolver(this._storage);

  final CalendarChatHistoryStorage _storage;

  ScheduleDisplayEntity? resolve() {
    ScheduleDisplayEntity? best;
    DateTime? bestAt;

    void consider(ScheduleDisplayEntity? raw, DateTime updatedAt) {
      if (raw == null) return;
      final days = AppHelper.scheduleDaysWithSlots(raw);
      if (days.isEmpty) return;
      final candidate = ScheduleDisplayEntity(schema: raw.schema, days: days);
      if (bestAt == null || updatedAt.isAfter(bestAt!)) {
        best = candidate;
        bestAt = updatedAt;
      }
    }

    final createTask = _storage.loadCreateTaskChat();
    if (createTask != null) {
      consider(createTask.scheduleDisplay, createTask.updatedAt);
    }

    for (final session in _storage.loadSessions()) {
      consider(session.scheduleDisplay, session.updatedAt);
    }

    return best;
  }
}
