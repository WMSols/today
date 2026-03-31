import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:today/domain/entities/active_goal_task_entity.dart';
import 'package:today/domain/usecases/get_active_goal_tasks_usecase.dart';

class HomeController extends GetxController {
  HomeController(this._getActiveGoalTasksUseCase);

  final GetActiveGoalTasksUseCase _getActiveGoalTasksUseCase;
  final RxBool isLoading = false.obs;
  final RxList<ActiveGoalTaskEntity> activeGoalTasks =
      <ActiveGoalTaskEntity>[].obs;

  final TextEditingController goalInputController = TextEditingController();
  final RxString goalDraft = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadActiveGoalTasks();
  }

  void setGoalDraft(String value) {
    goalDraft.value = value;
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

  @override
  void onClose() {
    goalInputController.dispose();
    super.onClose();
  }
}
