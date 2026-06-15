/// Offline stub payloads used while [ApiConstants.backendApiEnabled] is false.
abstract class ApiStubs {
  ApiStubs._();

  static int _scheduleVersion = 1;

  static Map<String, dynamic> health() => <String, dynamic>{
    'ok': true,
    'firebase_configured': true,
    'auth_required': true,
  };

  static Map<String, dynamic> authConfig() => <String, dynamic>{
    'auth_required': true,
    'providers': <String, dynamic>{'firebase': true, 'local': false},
    'firebase_project_id': 'offline',
  };

  static Map<String, dynamic> bootstrap({
    String userId = 'local-user',
    String displayName = 'Guest',
    String? email,
  }) => <String, dynamic>{
    'ok': true,
    'user_id': userId,
    'display_name': displayName,
    'email': ?email,
  };

  static Map<String, dynamic> calendarChat({required String message}) {
    _scheduleVersion++;
    return <String, dynamic>{
      'assistant_text':
          'Got it — I noted "$message" on your calendar. (offline stub)',
      'state': 'idle',
      'schedule_version': _scheduleVersion,
      'schedule_display': calendarScheduleDisplay(),
      'pending_proposal_id': null,
    };
  }

  static Map<String, dynamic> calendarAgenda() => <String, dynamic>{
    'events': <Map<String, dynamic>>[
      <String, dynamic>{
        'id': 'evt_stub_1',
        'title': 'Team standup',
        'start': DateTime.now()
            .copyWith(hour: 9, minute: 0, second: 0, millisecond: 0)
            .toIso8601String(),
        'end': DateTime.now()
            .copyWith(hour: 9, minute: 30, second: 0, millisecond: 0)
            .toIso8601String(),
        'all_day': false,
        'status': 'pending',
      },
    ],
    'goal_tasks': <Map<String, dynamic>>[
      <String, dynamic>{
        'id': 'gt_stub_1',
        'title': 'Review daily goals',
        'time': '10:00 AM',
        'status': 'pending',
      },
    ],
    'timezone': 'UTC',
  };

  static Map<String, dynamic> calendarScheduleDisplay() {
    final today = DateTime.now();
    final date =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    return <String, dynamic>{
      'schema': 'todai.schedule.v1',
      'days': <Map<String, dynamic>>[
        <String, dynamic>{
          'date': date,
          'weekday': 'Today',
          'slots': <Map<String, dynamic>>[
            <String, dynamic>{
              'title': 'Sample block',
              'description': 'From offline stub',
              'time': '9:00 AM',
              'status': 'calendar',
            },
          ],
        },
      ],
    };
  }

  static Map<String, dynamic> createCalendarEvent({required String title}) {
    _scheduleVersion++;
    return <String, dynamic>{
      'events': <Map<String, dynamic>>[
        <String, dynamic>{
          'id': 'evt_stub_${DateTime.now().millisecondsSinceEpoch}',
        },
      ],
      'schedule_version': _scheduleVersion,
    };
  }

  static Map<String, dynamic> updateCalendarEvent({required String eventId}) {
    _scheduleVersion++;
    return <String, dynamic>{
      'event': <String, dynamic>{'id': eventId},
      'schedule_version': _scheduleVersion,
    };
  }

  static Map<String, dynamic> deleteCalendarEvent() {
    _scheduleVersion++;
    return <String, dynamic>{
      'deleted': 1,
      'schedule_version': _scheduleVersion,
    };
  }

  static Map<String, dynamic> taskActionResult() => <String, dynamic>{
    'ok': true,
  };
}
