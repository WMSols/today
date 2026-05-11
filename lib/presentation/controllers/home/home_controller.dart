import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:today/domain/entities/goal_card_entity.dart';
import 'package:today/domain/entities/active_goal_task_entity.dart';
import 'package:today/domain/entities/goal_history_day_entity.dart';
import 'package:today/core/widgets/feedback/app_toast.dart';
import 'package:today/domain/usecases/create_goal_usecase.dart';
import 'package:today/domain/usecases/complete_task_usecase.dart';
import 'package:today/domain/usecases/delete_goal_usecase.dart';
import 'package:today/domain/usecases/get_active_goal_tasks_usecase.dart';
import 'package:today/domain/usecases/get_goal_cards_usecase.dart';
import 'package:today/domain/usecases/get_goal_history_usecase.dart';
import 'package:today/domain/usecases/skip_task_usecase.dart';

class HomeController extends GetxController {
  HomeController(
    this._getActiveGoalTasksUseCase,
    this._getGoalCardsUseCase,
    this._createGoalUseCase,
    this._completeTaskUseCase,
    this._skipTaskUseCase,
    this._getGoalHistoryUseCase,
    this._deleteGoalUseCase,
  );

  final GetActiveGoalTasksUseCase _getActiveGoalTasksUseCase;
  final GetGoalCardsUseCase _getGoalCardsUseCase;
  final CreateGoalUseCase _createGoalUseCase;
  final CompleteTaskUseCase _completeTaskUseCase;
  final SkipTaskUseCase _skipTaskUseCase;
  final GetGoalHistoryUseCase _getGoalHistoryUseCase;
  final DeleteGoalUseCase _deleteGoalUseCase;
  final RxBool isLoading = false.obs;
  final RxBool isCreatingGoal = false.obs;
  final RxList<ActiveGoalTaskEntity> activeGoalTasks =
      <ActiveGoalTaskEntity>[].obs;
  final RxList<GoalCardEntity> goalCards = <GoalCardEntity>[].obs;
  final RxList<GoalHistoryDayEntity> goalHistoryDays = <GoalHistoryDayEntity>[].obs;

  final TextEditingController goalInputController = TextEditingController();
  final RxString goalDraft = ''.obs;
  final RxString selectedGoalId = ''.obs;

  String get selectedGoalTitle {
    final id = selectedGoalId.value;
    if (id.isEmpty) return 'Goal';
    for (final goal in goalCards) {
      if (goal.goalId == id) return goal.title;
    }
    return 'Goal';
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadGoalCards();
  }

  void setGoalDraft(String value) {
    goalDraft.value = value;
  }

  Future<void> loadGoalCards() async {
    isLoading.value = true;
    try {
      final items = await _getGoalCardsUseCase();
      goalCards.assignAll(items);
      if (goalCards.isNotEmpty) {
        selectedGoalId.value = goalCards.first.goalId;
      }
    } catch (_) {
      _showError('Unable to load goals');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadActiveGoalTasks(String goalId) async {
    isLoading.value = true;
    selectedGoalId.value = goalId;
    try {
      final items = await _getActiveGoalTasksUseCase(goalId);
      activeGoalTasks.assignAll(items);
      await loadGoalHistory(goalId, silent: true);
    } catch (_) {
      _showError('Unable to load today tasks');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadGoalHistory(String goalId, {bool silent = false}) async {
    if (!silent) {
      isLoading.value = true;
    }
    try {
      final days = await _getGoalHistoryUseCase(goalId);
      goalHistoryDays.assignAll(days);
    } catch (_) {
      _showError('Unable to load goal history');
    } finally {
      if (!silent) {
        isLoading.value = false;
      }
    }
  }

  Future<void> completeTask(String taskId) async {
    if (taskId.isEmpty) return;
    try {
      final result = await _completeTaskUseCase(taskId);
      if (!result.already) {
        AppToast.showSuccess('Task completed');
      } else {
        AppToast.showInformation('Task already completed');
      }
      if (selectedGoalId.value.isNotEmpty) {
        await loadActiveGoalTasks(selectedGoalId.value);
      }
    } catch (_) {
      _showError('Unable to complete task');
    }
  }

  Future<void> skipTask(String taskId) async {
    if (taskId.isEmpty) return;
    try {
      final result = await _skipTaskUseCase(taskId);
      if (!result.already) {
        AppToast.showWarning(
          'Task skipped',
          result.balance == null ? null : 'Balance: ${result.balance}',
        );
      } else {
        AppToast.showInformation('Task already skipped');
      }
      if (selectedGoalId.value.isNotEmpty) {
        await loadActiveGoalTasks(selectedGoalId.value);
      }
    } catch (_) {
      _showError('Unable to skip task');
    }
  }

  Future<void> deleteGoal(String goalId) async {
    if (goalId.isEmpty) return;
    try {
      await _deleteGoalUseCase(goalId);
      AppToast.showSuccess('Goal deleted');
      await loadGoalCards();
      if (selectedGoalId.value.isNotEmpty) {
        await loadActiveGoalTasks(selectedGoalId.value);
      } else {
        activeGoalTasks.clear();
      }
    } catch (_) {
      _showError('Unable to delete goal');
    }
  }

  Future<void> createGoalFromDraft() async {
    final text = goalDraft.value.trim();
    if (text.length < 3) return;
    isCreatingGoal.value = true;
    try {
      await _createGoalUseCase(
        goalText: text,
        durationDays: 30,
        resetTimeLocal: '09:00',
        tasksPerDay: 6,
      );
      goalInputController.clear();
      goalDraft.value = '';
      AppToast.showSuccess('Goal created');
      await loadGoalCards();
    } catch (_) {
      _showError('Unable to create goal');
    } finally {
      isCreatingGoal.value = false;
    }
  }

  void _showError(String message) {
    if (Get.context != null) {
      AppToast.showError('Error', message);
    }
  }

  @override
  void onClose() {
    goalInputController.dispose();
    super.onClose();
  }
}
