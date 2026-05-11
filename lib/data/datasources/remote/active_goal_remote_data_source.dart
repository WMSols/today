import 'package:dio/dio.dart';

class ActiveGoalRemoteDataSource {
  const ActiveGoalRemoteDataSource(this._dio);

  final Dio _dio;

  Future<void> createGoal({
    required String goalText,
    required int durationDays,
    required String resetTimeLocal,
    required int tasksPerDay,
    String? timezone,
  }) async {
    await _dio.post<void>(
      '/goals',
      data: {
        'goal_text': goalText,
        'duration_days': durationDays,
        'reset_time_local': resetTimeLocal,
        'tasks_per_day': tasksPerDay,
        if (timezone != null && timezone.isNotEmpty) 'timezone': timezone,
      },
    );
  }

  Future<List<Map<String, dynamic>>> getGoals() async {
    final response = await _dio.get<Map<String, dynamic>>('/goals');
    final raw = response.data?['goals'] as List<dynamic>? ?? const [];
    return raw.map((e) => e as Map<String, dynamic>).toList();
  }

  Future<Map<String, dynamic>> getToday(String goalId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/goals/$goalId/today',
    );
    return response.data ?? <String, dynamic>{};
  }

  Future<List<Map<String, dynamic>>> getHistory(String goalId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/goals/$goalId/history',
    );
    final raw = response.data?['days'] as List<dynamic>? ?? const [];
    return raw.map((e) => e as Map<String, dynamic>).toList();
  }

  Future<void> deleteGoal(String goalId) async {
    await _dio.delete<void>('/goals/$goalId');
  }

  Future<Map<String, dynamic>> completeTask(String taskId) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/tasks/$taskId/complete',
    );
    return response.data ?? <String, dynamic>{};
  }

  Future<Map<String, dynamic>> skipTask(String taskId) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/tasks/$taskId/skip',
    );
    return response.data ?? <String, dynamic>{};
  }

  Future<bool> checkHealth() async {
    final response = await _dio.get<Map<String, dynamic>>('/health');
    return response.data?['ok'] == true;
  }
}
