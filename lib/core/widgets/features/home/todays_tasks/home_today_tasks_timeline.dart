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
    this.onCalendarEventLongPress,
    this.onCalendarEventEdit,
    this.onCalendarEventDelete,
    this.onCalendarEventComplete,
    this.onCalendarEventSkip,
    this.onGoalTaskEdit,
    this.onGoalTaskDelete,
  });

  final List<HomeTodayTaskEntity> tasks;
  final String selectedTaskId;
  final ValueChanged<String> onTaskTap;
  final ValueChanged<String> onTaskDone;
  final ValueChanged<String> onTaskSkip;
  final ValueChanged<HomeTodayTaskEntity>? onCalendarEventLongPress;
  final ValueChanged<HomeTodayTaskEntity>? onCalendarEventEdit;
  final ValueChanged<HomeTodayTaskEntity>? onCalendarEventDelete;
  final ValueChanged<HomeTodayTaskEntity>? onCalendarEventComplete;
  final ValueChanged<HomeTodayTaskEntity>? onCalendarEventSkip;
  final ValueChanged<HomeTodayTaskEntity>? onGoalTaskEdit;
  final ValueChanged<HomeTodayTaskEntity>? onGoalTaskDelete;

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
          onDone: task.isCalendarEvent && onCalendarEventComplete != null
              ? () => onCalendarEventComplete!(task)
              : () => onTaskDone(task.id),
          onSkip: task.isCalendarEvent && onCalendarEventSkip != null
              ? () => onCalendarEventSkip!(task)
              : () => onTaskSkip(task.id),
          onEdit: task.isCalendarEvent
              ? onCalendarEventEdit != null
                  ? () => onCalendarEventEdit!(task)
                  : null
              : onGoalTaskEdit != null
              ? () => onGoalTaskEdit!(task)
              : null,
          onDelete: task.isCalendarEvent
              ? onCalendarEventDelete != null
                  ? () => onCalendarEventDelete!(task)
                  : null
              : onGoalTaskDelete != null
              ? () => onGoalTaskDelete!(task)
              : null,
          onLongPress: task.isCalendarEvent && onCalendarEventLongPress != null
              ? () => onCalendarEventLongPress!(task)
              : null,
        );
      }),
    );
  }
}
