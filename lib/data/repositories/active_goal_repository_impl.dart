import 'package:today/data/datasources/remote/active_goal_remote_data_source.dart';
import 'package:today/data/models/active_goal_task_model.dart';
import 'package:today/data/models/goal_card_model.dart';
import 'package:today/data/models/goal_history_day_model.dart';
import 'package:today/data/models/task_action_result_model.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/domain/entities/active_goal_task_entity.dart';
import 'package:today/domain/entities/goal_card_entity.dart';
import 'package:today/domain/entities/goal_history_day_entity.dart';
import 'package:today/domain/entities/task_action_result_entity.dart';
import 'package:today/domain/repositories/active_goal_repository.dart';

class ActiveGoalRepositoryImpl implements ActiveGoalRepository {
  const ActiveGoalRepositoryImpl(this._remoteDataSource);

  final ActiveGoalRemoteDataSource _remoteDataSource;

  @override
  Future<void> createGoal({
    required String goalText,
    required int durationDays,
    required String resetTimeLocal,
    required int tasksPerDay,
    String? timezone,
  }) async {
    await _remoteDataSource.createGoal(
      goalText: goalText,
      durationDays: durationDays,
      resetTimeLocal: resetTimeLocal,
      tasksPerDay: tasksPerDay,
      timezone: timezone,
    );
  }

  @override
  Future<List<GoalCardEntity>> getGoalCards() async {
    final goals = await _remoteDataSource.getGoals();
    final cards = await Future.wait(
      goals.asMap().entries.map((entry) async {
        final index = entry.key;
        final item = entry.value;
        final goalId = item['id'] as String? ?? 'goal-$index';
        final duration = (item['duration_days'] as num?)?.toInt() ?? 30;
        final today = await _remoteDataSource.getToday(goalId);
        final tasks = (today['tasks'] as List<dynamic>? ?? const [])
            .cast<Map<String, dynamic>>();
        final completed = tasks.where((e) => e['status'] == 'completed').length;
        final target =
            (today['plan']?['tasks_target'] as num?)?.toInt() ??
            (item['tasks_per_day'] as num?)?.toInt() ??
            tasks.length;
        final progress = target == 0
            ? 0.0
            : (completed / target).clamp(0, 1).toDouble();
        return GoalCardModel(
          goalId: goalId,
          title: item['goal_text'] as String? ?? 'Goal',
          dayText: 'DAY 01 OF $duration',
          tasksText: '$completed/$target TASKS',
          percentText: '${(progress * 100).round()}%',
          totalTasksText: '$completed TASKS DONE IN TOTAL',
          progress: progress,
          iconPath: switch (index % 3) {
            0 => AppImages.medal1,
            1 => AppImages.medal2,
            _ => AppImages.medal3,
          },
        );
      }),
    );
    return cards;
  }

  @override
  Future<List<ActiveGoalTaskEntity>> getActiveGoalTasks(String goalId) async {
    final raw = await _remoteDataSource.getToday(goalId);
    final tasks = raw['tasks'] as List<dynamic>? ?? const [];
    return tasks.map((e) {
      final json = e as Map<String, dynamic>;
      final difficulty = (json['difficulty'] as String? ?? 'medium')
          .toLowerCase();
      final iconPath = switch (difficulty) {
        'easy' => AppImages.easyTasks,
        'hard' => AppImages.hardTasks,
        _ => AppImages.mediumTasks,
      };
      return ActiveGoalTaskModel(
        id: json['id'] as String? ?? '',
        level: difficulty.toUpperCase(),
        title: json['description'] as String? ?? '',
        iconPath: iconPath,
        status: json['status'] as String? ?? 'pending',
      );
    }).toList();
  }

  @override
  Future<List<GoalHistoryDayEntity>> getGoalHistory(String goalId) async {
    final raw = await _remoteDataSource.getHistory(goalId);
    return raw.map(GoalHistoryDayModel.fromJson).toList();
  }

  @override
  Future<void> deleteGoal(String goalId) async {
    await _remoteDataSource.deleteGoal(goalId);
  }

  @override
  Future<TaskActionResultEntity> completeTask(String taskId) async {
    final raw = await _remoteDataSource.completeTask(taskId);
    return TaskActionResultModel.fromJson(raw);
  }

  @override
  Future<TaskActionResultEntity> skipTask(String taskId) async {
    final raw = await _remoteDataSource.skipTask(taskId);
    return TaskActionResultModel.fromJson(raw);
  }
}
