import 'package:get/get.dart';

import 'package:today/core/storage/calendar_chat_history_storage.dart';
import 'package:today/domain/repositories/home_today_tasks_repository.dart';
import 'package:today/domain/usecases/delete_calendar_event_usecase.dart';
import 'package:today/domain/usecases/get_calendar_agenda_usecase.dart';
import 'package:today/domain/usecases/update_calendar_event_usecase.dart';
import 'package:today/presentation/controllers/agenda/agenda_controller.dart';

class AgendaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AgendaController>(
      () => AgendaController(
        Get.find<GetCalendarAgendaUseCase>(),
        Get.find<HomeTodayTasksRepository>(),
        Get.find<DeleteCalendarEventUseCase>(),
        Get.find<UpdateCalendarEventUseCase>(),
        Get.find<CalendarChatHistoryStorage>(),
      ),
    );
  }
}
