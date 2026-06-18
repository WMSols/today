import 'package:get/get.dart';

import 'package:today/core/storage/today_schedule_store.dart';
import 'package:today/domain/repositories/home_today_tasks_repository.dart';
import 'package:today/domain/usecases/complete_task_usecase.dart';
import 'package:today/domain/usecases/delete_calendar_event_usecase.dart';
import 'package:today/domain/usecases/delete_goal_task_usecase.dart';
import 'package:today/domain/usecases/skip_task_usecase.dart';
import 'package:today/domain/usecases/update_calendar_event_usecase.dart';
import 'package:today/domain/usecases/update_goal_task_usecase.dart';
import 'package:today/presentation/controllers/agenda/agenda_controller.dart';

class AgendaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AgendaController>(
      () => AgendaController(
        Get.find<TodayScheduleStore>(),
        Get.find<HomeTodayTasksRepository>(),
        Get.find<DeleteCalendarEventUseCase>(),
        Get.find<UpdateCalendarEventUseCase>(),
        Get.find<CompleteTaskUseCase>(),
        Get.find<SkipTaskUseCase>(),
        Get.find<UpdateGoalTaskUseCase>(),
        Get.find<DeleteGoalTaskUseCase>(),
      ),
    );
  }
}
