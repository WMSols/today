import 'package:get/get.dart';

import 'package:today/domain/usecases/send_calendar_chat_message_usecase.dart';
import 'package:today/presentation/controllers/planner/planner_controller.dart';

class PlannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlannerController>(
      () => PlannerController(Get.find<SendCalendarChatMessageUseCase>()),
    );
  }
}
