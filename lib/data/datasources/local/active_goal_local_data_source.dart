import 'package:today/core/utils/app_images/app_images.dart';

class ActiveGoalLocalDataSource {
  const ActiveGoalLocalDataSource();

  Future<List<Map<String, dynamic>>> getGoalCards() async {
    return const [
      {
        'title': 'Get fit in 30 days',
        'dayText': 'DAY 07 OF 30',
        'tasksText': '2/6 TASKS',
        'percentText': '38%',
        'gemsText': '20 GEMS',
        'totalTasksText': '14 TASKS DONE IN TOTAL',
        'progress': 0.38,
        'iconPath': AppImages.medal1,
      },
      {
        'title': 'Speak French fluently',
        'dayText': 'DAY 07 OF 30',
        'tasksText': '0/6 TASKS',
        'percentText': '0%',
        'gemsText': '18 GEMS',
        'totalTasksText': '14 TASKS DONE IN TOTAL',
        'progress': 0.0,
        'iconPath': AppImages.medal2,
      },
      {
        'title': 'Save \$500 in 45 days',
        'dayText': 'DAY 07 OF 45',
        'tasksText': '0/6 TASKS',
        'percentText': '0%',
        'gemsText': '18 GEMS',
        'totalTasksText': '14 TASKS DONE IN TOTAL',
        'progress': 0.0,
        'iconPath': AppImages.medal3,
      },
    ];
  }

  Future<List<Map<String, dynamic>>> getActiveGoalTasks() async {
    return const [
      {
        'level': 'HARD',
        'title':
            'Drink at least eight glasses (2 litres) of\nwater throughout the day',
        'iconPath': AppImages.hardTasks,
      },
      {
        'level': 'EASY',
        'title': 'Take a 20-minute brisk walk outside or on\na treadmill',
        'iconPath': AppImages.easyTasks,
      },
      {
        'level': 'MEDIUM',
        'title': 'Log every mean and snack in a food\ntracking app today',
        'iconPath': AppImages.mediumTasks,
      },
      {
        'level': 'EASY',
        'title': 'Replace one sugary drink or snack with a\npiece of fruit',
        'iconPath': AppImages.easyTasks,
      },
      {
        'level': 'HARD',
        'title':
            'Do a 10-minute bodyweight workout\n(squats, push-ups, planks - no equipment\nneeded)',
        'iconPath': AppImages.hardTasks,
      },
      {
        'level': 'MEDIUM',
        'title': 'Log every mean and snack in a food\ntracking app today',
        'iconPath': AppImages.mediumTasks,
      },
    ];
  }
}
