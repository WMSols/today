/// Canonical offline demo payloads shared by home, goals, and analytics stubs.
abstract final class DemoStubData {
  DemoStubData._();

  /// In-memory task list for the current app session (updated from Home).
  static final List<Map<String, dynamic>> _todayTasksSession = _seedTodayTasks
      .map((task) => Map<String, dynamic>.from(task))
      .toList(growable: true);

  /// Goal task status overrides for the current session.
  static final Map<String, String> _goalTaskStatuses = <String, String>{};

  static const List<Map<String, dynamic>> _seedTodayTasks =
      <Map<String, dynamic>>[
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

  static List<Map<String, dynamic>> snapshotTodayTasks() => _todayTasksSession
      .map((task) => Map<String, dynamic>.from(task))
      .toList(growable: false);

  static void setTodayTaskStatus(String taskId, String status) {
    final index = _todayTasksSession.indexWhere((t) => t['id'] == taskId);
    if (index < 0) return;
    _todayTasksSession[index] = <String, dynamic>{
      ..._todayTasksSession[index],
      'status': status,
    };
  }

  /// Appends a manually created task for the current session.
  static Map<String, dynamic> addTodayTask({
    required String title,
    required String timeLabel,
    required DateTime scheduledDate,
    required DateTime startDateTime,
    required DateTime endDateTime,
    String? notes,
    bool isRecurring = false,
  }) {
    final id = 'task_${DateTime.now().millisecondsSinceEpoch}';
    final task = <String, dynamic>{
      'id': id,
      'title': title,
      'time_label': timeLabel,
      'status': 'pending',
      'scheduled_date': scheduledDate.toIso8601String(),
      'start_at': startDateTime.toIso8601String(),
      'end_at': endDateTime.toIso8601String(),
      'is_recurring': isRecurring,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    };
    _todayTasksSession.add(task);
    return Map<String, dynamic>.from(task);
  }

  static void setGoalTaskStatus(String taskId, String status) {
    _goalTaskStatuses[taskId] = status;
  }

  static const List<Map<String, dynamic>> activeGoals = <Map<String, dynamic>>[
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

  static const List<double> homeWeeklyProgressByDay = <double>[
    0.4,
    1.0,
    1.0,
    0.5,
    0.0,
    0.0,
    0.0,
  ];

  static const List<double> analyticsWeeklyProgressByDay = <double>[
    0.0,
    0.25,
    0.85,
    0.92,
    0.55,
    0.0,
    0.15,
  ];

  static const double previousWeekProductivityRatio = 0.31;

  static Map<String, dynamic> todayPlanForGoal(String goalId) {
    final Map<String, dynamic> plan;
    switch (goalId) {
      case 'goal_1':
        plan = _todayPlan(
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
              'status': 'completed',
              'description': 'Stretch routine',
              'difficulty': 'easy',
            },
            <String, dynamic>{
              'id': 'goal_1_t5',
              'status': 'completed',
              'description': 'Log workout',
              'difficulty': 'easy',
            },
          ],
        );
        break;
      case 'goal_2':
        plan = _todayPlan(
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
              'status': 'completed',
              'description': 'Summarize notes',
              'difficulty': 'hard',
            },
          ],
        );
        break;
      case 'goal_3':
        plan = _todayPlan(
          tasksTarget: 4,
          tasks: const <Map<String, dynamic>>[
            <String, dynamic>{
              'id': 'goal_3_t1',
              'status': 'pending',
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
        break;
      default:
        plan = _todayPlan(
          tasksTarget: 0,
          tasks: const <Map<String, dynamic>>[],
        );
    }
    final tasks = (plan['tasks'] as List<dynamic>? ?? const [])
        .cast<Map<String, dynamic>>();
    return <String, dynamic>{...plan, 'tasks': _applyGoalTaskStatuses(tasks)};
  }

  static List<Map<String, dynamic>> _applyGoalTaskStatuses(
    List<Map<String, dynamic>> tasks,
  ) {
    return tasks
        .map((task) {
          final copy = Map<String, dynamic>.from(task);
          final id = copy['id'] as String?;
          final override = id == null ? null : _goalTaskStatuses[id];
          if (override != null) {
            copy['status'] = override;
          }
          return copy;
        })
        .toList(growable: false);
  }

  static Map<String, dynamic> _todayPlan({
    required int tasksTarget,
    required List<Map<String, dynamic>> tasks,
  }) => <String, dynamic>{
    'plan': <String, dynamic>{'tasks_target': tasksTarget},
    'tasks': tasks,
  };

  static int countTodayTasksWithStatus(String status) {
    return _todayTasksSession
        .where((t) => (t['status'] as String? ?? '') == status)
        .length;
  }

  static ({int completed, int skipped, int pending}) get todayTaskOutcomes {
    return (
      completed: countTodayTasksWithStatus('completed'),
      skipped: countTodayTasksWithStatus('skipped'),
      pending: countTodayTasksWithStatus('pending'),
    );
  }

  static int countGoalsFullyCompleteForToday() {
    var count = 0;
    for (final goal in activeGoals) {
      final goalId = goal['id'] as String? ?? '';
      final today = todayPlanForGoal(goalId);
      final tasks = (today['tasks'] as List<dynamic>? ?? const [])
          .cast<Map<String, dynamic>>();
      final completed = tasks.where((e) => e['status'] == 'completed').length;
      final target =
          (today['plan']?['tasks_target'] as num?)?.toInt() ??
          (goal['tasks_per_day'] as num?)?.toInt() ??
          tasks.length;
      if (target > 0 && completed >= target) {
        count++;
      }
    }
    return count;
  }

  static int get activeGoalsCount => activeGoals.length;

  static int get todayTasksCount => _todayTasksSession.length;

  static int get todayTasksCompletedCount =>
      countTodayTasksWithStatus('completed');
}
