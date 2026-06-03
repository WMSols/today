import 'package:today/core/network/demo_stub_data.dart';

class HomeTodayTasksRemoteDataSource {
  const HomeTodayTasksRemoteDataSource();

  Future<List<Map<String, dynamic>>> fetchTodayTasks() async {
    return DemoStubData.snapshotTodayTasks();
  }

  Future<void> updateTaskStatus({
    required String taskId,
    required String status,
  }) async {
    DemoStubData.setTodayTaskStatus(taskId, status);
  }
}
