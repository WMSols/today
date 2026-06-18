import 'package:today/domain/entities/calendar_agenda_entity.dart';
import 'package:today/domain/entities/calendar_chat_response_entity.dart';
import 'package:today/domain/entities/calendar_event_entity.dart';
import 'package:today/domain/entities/create_calendar_event_params.dart';
import 'package:today/domain/entities/home_today_task_entity.dart';
import 'package:today/domain/entities/update_calendar_event_params.dart';

abstract class CalendarRepository {
  Future<CalendarChatResponseEntity> sendChatMessage({required String message});

  Future<CalendarAgendaEntity> getAgenda({
    required DateTime from,
    required DateTime to,
  });

  Future<List<HomeTodayTaskEntity>> getTodayAgendaTasks();

  Future<List<double>> getWeeklyProgress({DateTime? anchor});

  Future<CalendarEventEntity> createEvent(CreateCalendarEventParams params);

  Future<CalendarEventEntity> updateEvent({
    required String eventId,
    required UpdateCalendarEventParams params,
    bool updateSeries = false,
  });

  Future<int> deleteEvent({required String eventId, bool deleteSeries = false});

  Future<bool> applyScheduleVersion(int scheduleVersion);
}
