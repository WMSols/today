import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/domain/usecases/send_calendar_chat_message_usecase.dart';
import 'package:today/presentation/controllers/planner/calendar_chat_controller.dart';

class PlannerController extends CalendarChatController {
  PlannerController(this._sendCalendarChatMessageUseCase);

  final SendCalendarChatMessageUseCase _sendCalendarChatMessageUseCase;

  @override
  SendCalendarChatMessageUseCase get sendCalendarChatMessageUseCase =>
      _sendCalendarChatMessageUseCase;

  @override
  String get chatWelcomeMessage => AppTexts.plannerWelcomeMessage;

  @override
  String get chatPromptMessage => AppTexts.plannerNamePrompt;

  @override
  String get chatInputHint => AppTexts.plannerMessageInputHint;

  @override
  String get chatHeaderTitle => AppTexts.plannerWelcomeMessage;
}
