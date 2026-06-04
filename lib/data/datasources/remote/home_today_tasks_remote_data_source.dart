import 'package:today/core/network/demo_stub_data.dart';

class HomeTodayTasksRemoteDataSource {
  const HomeTodayTasksRemoteDataSource();

  Future<List<Map<String, dynamic>>> fetchTodayTasks() async {
    return DemoStubData.snapshotTodayTasks();
  }

  Future<Map<String, dynamic>> createTask({
    required String title,
    required String timeLabel,
    required DateTime scheduledDate,
    required DateTime startDateTime,
    required DateTime endDateTime,
    String? notes,
    bool isRecurring = false,
  }) async {
    return DemoStubData.addTodayTask(
      title: title,
      timeLabel: timeLabel,
      scheduledDate: scheduledDate,
      startDateTime: startDateTime,
      endDateTime: endDateTime,
      notes: notes,
      isRecurring: isRecurring,
    );
  }

  Future<void> updateTaskStatus({
    required String taskId,
    required String status,
  }) async {
    DemoStubData.setTodayTaskStatus(taskId, status);
  }
}
