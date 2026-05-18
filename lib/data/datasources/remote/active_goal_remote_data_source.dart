import 'package:dio/dio.dart';

import 'package:today/core/constants/api_constants.dart';
import 'package:today/core/network/api_stubs.dart';

class ActiveGoalRemoteDataSource {
  const ActiveGoalRemoteDataSource(this._dio);

  // ignore: unused_field
  final Dio _dio;

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
    if (!ApiConstants.backendApiEnabled) return const [];
    // final response = await _dio.get<Map<String, dynamic>>('/goals');
    // final raw = response.data?['goals'] as List<dynamic>? ?? const [];
    // return raw.map((e) => e as Map<String, dynamic>).toList();
    return const [];
  }

  Future<Map<String, dynamic>> getToday(String goalId) async {
    if (!ApiConstants.backendApiEnabled) {
      return <String, dynamic>{'tasks': const <dynamic>[]};
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
