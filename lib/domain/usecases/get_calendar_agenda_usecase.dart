import 'package:today/domain/entities/calendar_agenda_entity.dart';
import 'package:today/domain/repositories/calendar_repository.dart';

class GetCalendarAgendaUseCase {
  const GetCalendarAgendaUseCase(this._repository);

  final CalendarRepository _repository;

  Future<CalendarAgendaEntity> call({
    required DateTime from,
    required DateTime to,
  }) {
    return _repository.getAgenda(from: from, to: to);
  }
}
