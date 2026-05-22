import 'package:dio/dio.dart';

import 'package:today/core/constants/api_constants.dart';
import 'package:today/core/network/api_stubs.dart';

/// Active goals stub payloads until the goals API is available.
class ActiveGoalRemoteDataSource {
  const ActiveGoalRemoteDataSource(this._dio);

  // ignore: unused_field
  final Dio _dio;

  static const List<Map<String, dynamic>> _stubGoals = <Map<String, dynamic>>[
    <String, dynamic>{
      'id': 'goal_1',
      'goal_text': 'Morning Cardio',
      'duration_days': 30,
      'tasks_per_day': 5,
    },
    <String, dynamic>{
      'id': 'goal_2',
      'goal_text': 'Read 20 pages',
      'duration_days': 14,
      'tasks_per_day': 5,
    },
    <String, dynamic>{
      'id': 'goal_3',
      'goal_text': 'Daily meditation',
      'duration_days': 21,
      'tasks_per_day': 4,
    },
  ];

  static Map<String, dynamic> _stubTodayForGoal(String goalId) {
    switch (goalId) {
      case 'goal_1':
        return _stubToday(
          tasksTarget: 5,
          tasks: const <Map<String, dynamic>>[
            <String, dynamic>{
              'id': 'goal_1_t1',
              'status': 'completed',
              'description': '5-minute warm-up',
              'difficulty': 'easy',
            },
            <String, dynamic>{
              'id': 'goal_1_t2',
              'status': 'completed',
              'description': '15-minute jog',
              'difficulty': 'medium',
            },
            <String, dynamic>{
              'id': 'goal_1_t3',
              'status': 'completed',
              'description': '5-minute cool-down',
              'difficulty': 'easy',
            },
            <String, dynamic>{
              'id': 'goal_1_t4',
              'status': 'pending',
              'description': 'Stretch routine',
              'difficulty': 'easy',
            },
            <String, dynamic>{
              'id': 'goal_1_t5',
              'status': 'pending',
              'description': 'Log workout',
              'difficulty': 'easy',
            },
          ],
        );
      case 'goal_2':
        return _stubToday(
          tasksTarget: 5,
          tasks: const <Map<String, dynamic>>[
            <String, dynamic>{
              'id': 'goal_2_t1',
              'status': 'completed',
              'description': 'Read chapter 1',
              'difficulty': 'easy',
            },
            <String, dynamic>{
              'id': 'goal_2_t2',
              'status': 'completed',
              'description': 'Read chapter 2',
              'difficulty': 'medium',
            },
            <String, dynamic>{
              'id': 'goal_2_t3',
              'status': 'completed',
              'description': 'Read chapter 3',
              'difficulty': 'medium',
            },
            <String, dynamic>{
              'id': 'goal_2_t4',
              'status': 'completed',
              'description': 'Read chapter 4',
              'difficulty': 'medium',
            },
            <String, dynamic>{
              'id': 'goal_2_t5',
              'status': 'pending',
              'description': 'Summarize notes',
              'difficulty': 'hard',
            },
          ],
        );
      case 'goal_3':
        return _stubToday(
          tasksTarget: 4,
          tasks: const <Map<String, dynamic>>[
            <String, dynamic>{
              'id': 'goal_3_t1',
              'status': 'completed',
              'description': 'Breathing exercise',
              'difficulty': 'easy',
            },
            <String, dynamic>{
              'id': 'goal_3_t2',
              'status': 'pending',
              'description': '10-minute session',
              'difficulty': 'medium',
            },
            <String, dynamic>{
              'id': 'goal_3_t3',
              'status': 'pending',
              'description': 'Gratitude journal',
              'difficulty': 'easy',
            },
            <String, dynamic>{
              'id': 'goal_3_t4',
              'status': 'pending',
              'description': 'Evening reflection',
              'difficulty': 'easy',
            },
          ],
        );
      default:
        return _stubToday(
          tasksTarget: 0,
          tasks: const <Map<String, dynamic>>[],
        );
    }
  }

  static Map<String, dynamic> _stubToday({
    required int tasksTarget,
    required List<Map<String, dynamic>> tasks,
  }) => <String, dynamic>{
    'plan': <String, dynamic>{'tasks_target': tasksTarget},
    'tasks': tasks,
  };

  Future<void> createGoal({
    required String goalText,
    required int durationDays,
    required String resetTimeLocal,
    required int tasksPerDay,
    String? timezone,
  }) async {
    if (!ApiConstants.backendApiEnabled) return;
    // await _dio.post<void>(
    //   '/goals',
    //   data: {
    //     'goal_text': goalText,
    //     'duration_days': durationDays,
    //     'reset_time_local': resetTimeLocal,
    //     'tasks_per_day': tasksPerDay,
    //     if (timezone != null && timezone.isNotEmpty) 'timezone': timezone,
    //   },
    // );
  }

  Future<List<Map<String, dynamic>>> getGoals() async {
    if (!ApiConstants.backendApiEnabled) {
      return List<Map<String, dynamic>>.from(_stubGoals);
    }
    // final response = await _dio.get<Map<String, dynamic>>('/goals');
    // final raw = response.data?['goals'] as List<dynamic>? ?? const [];
    // return raw.map((e) => e as Map<String, dynamic>).toList();
    return const [];
  }

  Future<Map<String, dynamic>> getToday(String goalId) async {
    if (!ApiConstants.backendApiEnabled) {
      return _stubTodayForGoal(goalId);
    }
    // final response = await _dio.get<Map<String, dynamic>>(
    //   '/goals/$goalId/today',
    // );
    // return response.data ?? <String, dynamic>{};
    return <String, dynamic>{'tasks': const <dynamic>[]};
  }

  Future<List<Map<String, dynamic>>> getHistory(String goalId) async {
    if (!ApiConstants.backendApiEnabled) return const [];
    // final response = await _dio.get<Map<String, dynamic>>(
    //   '/goals/$goalId/history',
    // );
    // final raw = response.data?['days'] as List<dynamic>? ?? const [];
    // return raw.map((e) => e as Map<String, dynamic>).toList();
    return const [];
  }

  Future<void> deleteGoal(String goalId) async {
    if (!ApiConstants.backendApiEnabled) return;
    // await _dio.delete<void>('/goals/$goalId');
  }

  Future<Map<String, dynamic>> completeTask(String taskId) async {
    if (!ApiConstants.backendApiEnabled) return ApiStubs.taskActionResult();
    // final response = await _dio.post<Map<String, dynamic>>(
    //   '/tasks/$taskId/complete',
    // );
    // return response.data ?? <String, dynamic>{};
    return ApiStubs.taskActionResult();
  }

  Future<Map<String, dynamic>> skipTask(String taskId) async {
    if (!ApiConstants.backendApiEnabled) return ApiStubs.taskActionResult();
    // final response = await _dio.post<Map<String, dynamic>>(
    //   '/tasks/$taskId/skip',
    // );
    // return response.data ?? <String, dynamic>{};
    return ApiStubs.taskActionResult();
  }

  Future<bool> checkHealth() async {
    if (!ApiConstants.backendApiEnabled) return true;
    // final response = await _dio.get<Map<String, dynamic>>('/health');
    // return response.data?['ok'] == true;
    return true;
  }
}
