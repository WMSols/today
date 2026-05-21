/// Today's tasks stub payloads until the home tasks API is available.
class HomeTodayTasksRemoteDataSource {
  const HomeTodayTasksRemoteDataSource();

  static const List<Map<String, dynamic>> _stubTasks = <Map<String, dynamic>>[
    <String, dynamic>{
      'id': 'task_1',
      'title': 'Stretch for 10 minutes',
      'time_label': '8:00 AM',
      'status': 'pending',
    },
    <String, dynamic>{
      'id': 'task_2',
      'title': 'Drink 500ml water',
      'time_label': '7:30 AM',
      'status': 'pending',
    },
    <String, dynamic>{
      'id': 'task_3',
      'title': 'Review daily goals',
      'time_label': '9:00 AM',
      'status': 'pending',
    },
    <String, dynamic>{
      'id': 'task_4',
      'title': '10-minute meditation',
      'time_label': '12:00 PM',
      'status': 'pending',
    },
    <String, dynamic>{
      'id': 'task_5',
      'title': 'Walk 2,000 steps',
      'time_label': '2:00 PM',
      'status': 'pending',
    },
    <String, dynamic>{
      'id': 'task_6',
      'title': 'Plan tomorrow tasks',
      'time_label': '8:00 PM',
      'status': 'pending',
    },
  ];

  Future<List<Map<String, dynamic>>> fetchTodayTasks() async {
    return List<Map<String, dynamic>>.from(_stubTasks);
  }
}
