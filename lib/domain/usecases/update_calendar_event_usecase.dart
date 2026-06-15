import 'package:today/domain/entities/calendar_event_entity.dart';
import 'package:today/domain/entities/update_calendar_event_params.dart';
import 'package:today/domain/repositories/calendar_repository.dart';

class UpdateCalendarEventUseCase {
  const UpdateCalendarEventUseCase(this._repository);

  final CalendarRepository _repository;

  Future<CalendarEventEntity> call({
    required String eventId,
    required UpdateCalendarEventParams params,
  }) {
    return _repository.updateEvent(eventId: eventId, params: params);
  }
}
