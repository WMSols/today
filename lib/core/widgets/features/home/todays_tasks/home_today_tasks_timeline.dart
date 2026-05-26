import 'package:flutter/material.dart';

import 'package:today/core/widgets/common/app_timeline/app_vertical_timeline.dart';
import 'package:today/core/widgets/features/home/todays_tasks/home_today_task_item.dart';
import 'package:today/domain/entities/home_today_task_entity.dart';

class HomeTodayTasksTimeline extends StatelessWidget {
  const HomeTodayTasksTimeline({
    super.key,
    required this.tasks,
    required this.selectedTaskId,
    required this.onTaskTap,
    required this.onTaskDone,
    required this.onTaskSkip,
  });

  final List<HomeTodayTaskEntity> tasks;
  final String selectedTaskId;
  final ValueChanged<String> onTaskTap;
  final ValueChanged<String> onTaskDone;
  final ValueChanged<String> onTaskSkip;

  @override
  Widget build(BuildContext context) {
    return AppVerticalTimeline(
      children: List.generate(tasks.length, (index) {
        final task = tasks[index];
        return HomeTodayTaskItem(
          task: task,
          isLast: index == tasks.length - 1,
          isSelected: selectedTaskId == task.id,
          onTap: () => onTaskTap(task.id),
          onDone: () => onTaskDone(task.id),
          onSkip: () => onTaskSkip(task.id),
        );
      }),
    );
  }
}
