import 'package:get/get.dart';

import 'package:today/domain/usecases/create_today_task_usecase.dart';
import 'package:today/domain/usecases/send_calendar_chat_message_usecase.dart';
import 'package:today/presentation/controllers/planner/create_task_controller.dart';

class CreateTaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateTaskController>(
      () => CreateTaskController(
        Get.find<CreateTodayTaskUseCase>(),
        Get.find<SendCalendarChatMessageUseCase>(),
      ),
    );
  }
}
