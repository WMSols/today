import 'package:today/core/utils/app_helper/app_helper.dart';
import 'package:today/domain/entities/home_today_task_entity.dart';
import 'package:today/domain/entities/schedule_display_entity.dart';

/// Pure helpers for linking chat [schedule_display] slots to agenda tasks.
abstract final class ScheduleDisplayEnricher {
  ScheduleDisplayEnricher._();

  static ScheduleDisplayEntity enrich(
    ScheduleDisplayEntity display,
    List<HomeTodayTaskEntity> events,
  ) {
    final calendarEvents =
        events.where((t) => t.isCalendarEvent).toList(growable: false);

    final days = display.days.map((day) {
      final slots = day.slots.map((slot) {
        if (!AppHelper.isCalendarScheduleSlot(slot)) return slot;
        if (slot.eventId?.trim().isNotEmpty == true) return slot;

        final linked = linkSlotToTask(
          dayDate: day.date,
          slot: slot,
          events: calendarEvents,
        );
        if (linked == null) return slot;

        return ScheduleDisplaySlotEntity(
          title: slot.title,
          description: slot.description,
          time: slot.time,
          status: slot.status,
          eventId: linked.id,
        );
      }).toList(growable: false);

      return ScheduleDisplayDayEntity(
        date: day.date,
        weekday: day.weekday,
        slots: slots,
      );
    }).toList(growable: false);

    return ScheduleDisplayEntity(schema: display.schema, days: days);
  }

  static ScheduleDisplayEntity syncTitlesFromTasks(
    ScheduleDisplayEntity display,
    List<HomeTodayTaskEntity> events,
  ) {
    final calendarEvents =
        events.where((t) => t.isCalendarEvent).toList(growable: false);

    final days = display.days.map((day) {
      final slots = day.slots.map((slot) {
        final eventId = slot.eventId?.trim();
        if (eventId != null && eventId.isNotEmpty) {
          HomeTodayTaskEntity? match;
          for (final task in calendarEvents) {
            if (task.id == eventId) {
              match = task;
              break;
            }
          }
          if (match != null && match.title != slot.title) {
            return ScheduleDisplaySlotEntity(
              title: match.title,
              description: slot.description,
              time: slot.time,
              status: slot.status,
              eventId: eventId,
            );
          }
          return slot;
        }

        final linked = linkSlotToTask(
          dayDate: day.date,
          slot: slot,
          events: calendarEvents,
        );
        if (linked != null && linked.title != slot.title) {
          return ScheduleDisplaySlotEntity(
            title: linked.title,
            description: slot.description,
            time: slot.time,
            status: slot.status,
            eventId: linked.id,
          );
        }
        return slot;
      }).toList(growable: false);

      return ScheduleDisplayDayEntity(
        date: day.date,
        weekday: day.weekday,
        slots: slots,
      );
    }).toList(growable: false);

    return ScheduleDisplayEntity(schema: display.schema, days: days);
  }

  static HomeTodayTaskEntity? linkSlotToTask({
    required String dayDate,
    required ScheduleDisplaySlotEntity slot,
    required List<HomeTodayTaskEntity> events,
  }) {
    if (!AppHelper.isCalendarScheduleSlot(slot)) return null;

    final eventId = slot.eventId?.trim();
    if (eventId != null && eventId.isNotEmpty) {
      for (final task in events) {
        if (task.id == eventId) return task;
      }
      return _syntheticEvent(eventId, slot);
    }

    final day = AppHelper.parseDateTimeOrNull(dayDate);
    if (day == null) return null;

    final normalizedTitle = _normalizeTitle(slot.title);
    final sameDayMatches = events.where((task) {
      final start = task.startAt;
      if (start == null || !AppHelper.isSameDay(start, day)) return false;
      return _normalizeTitle(task.title) == normalizedTitle;
    }).toList(growable: false);

    if (sameDayMatches.isEmpty) {
      for (final task in events) {
        if (_normalizeTitle(task.title) == normalizedTitle) return task;
      }
      return null;
    }

    if (sameDayMatches.length == 1) return sameDayMatches.first;

    final slotTime = slot.time?.trim() ?? '';
    if (slotTime.isEmpty) return null;

    final timeMatches = sameDayMatches
        .where((task) => _timesRoughlyMatch(slotTime, task.timeLabel))
        .toList(growable: false);
    return timeMatches.length == 1 ? timeMatches.first : null;
  }

  static ScheduleDisplayEntity updateEventTitle(
    ScheduleDisplayEntity display, {
    required String eventId,
    required String newTitle,
  }) {
    var changed = false;
    final days = display.days.map((day) {
      final slots = day.slots.map((slot) {
        if (slot.eventId != eventId) return slot;
        changed = true;
        return ScheduleDisplaySlotEntity(
          title: newTitle,
          description: slot.description,
          time: slot.time,
          status: slot.status,
          eventId: eventId,
        );
      }).toList(growable: false);
      return ScheduleDisplayDayEntity(
        date: day.date,
        weekday: day.weekday,
        slots: slots,
      );
    }).toList(growable: false);

    if (!changed) return display;
    return ScheduleDisplayEntity(schema: display.schema, days: days);
  }

  static ScheduleDisplayEntity? removeEvent(
    ScheduleDisplayEntity display, {
    required String eventId,
  }) {
    var changed = false;
    final days = display.days
        .map((day) {
          final slots = day.slots
              .where((slot) {
                if (slot.eventId == eventId) {
                  changed = true;
                  return false;
                }
                return true;
              })
              .toList(growable: false);
          return ScheduleDisplayDayEntity(
            date: day.date,
            weekday: day.weekday,
            slots: slots,
          );
        })
        .where((day) => day.slots.isNotEmpty)
        .toList(growable: false);

    if (!changed) return null;
    return ScheduleDisplayEntity(schema: display.schema, days: days);
  }

  static HomeTodayTaskEntity _syntheticEvent(
    String eventId,
    ScheduleDisplaySlotEntity slot,
  ) {
    return HomeTodayTaskEntity(
      id: eventId,
      title: slot.title,
      timeLabel: slot.time ?? '',
      source: HomeTodayTaskSource.calendarEvent,
    );
  }

  static String _normalizeTitle(String value) =>
      value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  static bool _timesRoughlyMatch(String slotTime, String taskTimeLabel) {
    final normalizedSlot = slotTime.toLowerCase().replaceAll(' ', '');
    final normalizedTask = taskTimeLabel.toLowerCase().replaceAll(' ', '');
    return normalizedSlot == normalizedTask ||
        normalizedTask.contains(normalizedSlot) ||
        normalizedSlot.contains(normalizedTask);
  }
}
