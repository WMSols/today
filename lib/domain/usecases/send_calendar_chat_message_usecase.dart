import 'package:today/domain/entities/calendar_chat_response_entity.dart';
import 'package:today/domain/repositories/calendar_repository.dart';

class SendCalendarChatMessageUseCase {
  const SendCalendarChatMessageUseCase(this._repository);

  final CalendarRepository _repository;

  Future<CalendarChatResponseEntity> call({required String message}) {
    return _repository.sendChatMessage(message: message);
  }
}
