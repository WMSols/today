import 'package:today/domain/entities/calendar_event_entity.dart';
import 'package:today/domain/entities/create_calendar_event_params.dart';
import 'package:today/domain/repositories/calendar_repository.dart';

class CreateCalendarEventUseCase {
  const CreateCalendarEventUseCase(this._repository);

  final CalendarRepository _repository;

  Future<CalendarEventEntity> call(CreateCalendarEventParams params) {
    return _repository.createEvent(params);
  }
}
