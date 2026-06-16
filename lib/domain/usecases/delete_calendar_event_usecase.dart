import 'package:today/domain/repositories/calendar_repository.dart';

class DeleteCalendarEventUseCase {
  const DeleteCalendarEventUseCase(this._repository);

  final CalendarRepository _repository;

  Future<int> call({required String eventId, bool deleteSeries = false}) {
    return _repository.deleteEvent(
      eventId: eventId,
      deleteSeries: deleteSeries,
    );
  }
}
