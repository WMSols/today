import 'package:dio/dio.dart';

import 'package:today/core/constants/api_constants.dart';
import 'package:today/core/network/api_stubs.dart';
import 'package:today/core/network/demo_stub_data.dart';

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
  }

  Future<List<Map<String, dynamic>>> getGoals() async {
    if (!ApiConstants.backendApiEnabled) {
      return List<Map<String, dynamic>>.from(DemoStubData.activeGoals);
    }
    return const [];
  }

  Future<Map<String, dynamic>> getToday(String goalId) async {
    if (!ApiConstants.backendApiEnabled) {
      return DemoStubData.todayPlanForGoal(goalId);
    }
    return <String, dynamic>{'tasks': const <dynamic>[]};
  }

  Future<List<Map<String, dynamic>>> getHistory(String goalId) async {
    if (!ApiConstants.backendApiEnabled) return const [];
    return const [];
  }

  Future<void> deleteGoal(String goalId) async {
    if (!ApiConstants.backendApiEnabled) return;
  }

  Future<Map<String, dynamic>> completeTask(String taskId) async {
    if (!ApiConstants.backendApiEnabled) {
      DemoStubData.setGoalTaskStatus(taskId, 'completed');
      return ApiStubs.taskActionResult();
    }
    return ApiStubs.taskActionResult();
  }

  Future<Map<String, dynamic>> skipTask(String taskId) async {
    if (!ApiConstants.backendApiEnabled) {
      DemoStubData.setGoalTaskStatus(taskId, 'skipped');
      return ApiStubs.taskActionResult();
    }
    return ApiStubs.taskActionResult();
  }

  Future<bool> checkHealth() async {
    if (!ApiConstants.backendApiEnabled) return true;
    return true;
  }
}
