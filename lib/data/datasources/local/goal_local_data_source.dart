class GoalLocalDataSource {
  const GoalLocalDataSource();

  Future<Map<String, dynamic>?> getPrimaryGoal() async {
    // Wire local persistence in milestone implementation.
    return null;
  }

  Future<void> saveGoal(Map<String, dynamic> goal) async {
    final _ = goal;
  }
}
