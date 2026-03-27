import 'package:get/get.dart';
import 'package:today/domain/entities/active_goal_task_entity.dart';
import 'package:today/domain/usecases/get_active_goal_tasks_usecase.dart';

class HomeController extends GetxController {
  HomeController(this._getActiveGoalTasksUseCase);

  final GetActiveGoalTasksUseCase _getActiveGoalTasksUseCase;
  final RxBool isLoading = false.obs;
  final RxList<ActiveGoalTaskEntity> activeGoalTasks =
      <ActiveGoalTaskEntity>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadActiveGoalTasks();
  }

  Future<void> loadActiveGoalTasks() async {
    isLoading.value = true;
    try {
      final items = await _getActiveGoalTasksUseCase();
      activeGoalTasks.assignAll(items);
    } finally {
      isLoading.value = false;
    }
  }
}
