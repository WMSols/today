import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/features/home/todays_tasks/home_today_tasks_timeline.dart';
import 'package:today/domain/entities/home_today_task_entity.dart';

class HomeAgendaSections extends StatelessWidget {
  const HomeAgendaSections({
    super.key,
    required this.calendarEvents,
    required this.goalTasks,
    required this.selectedTaskId,
    required this.onTaskTap,
    required this.onTaskDone,
    required this.onTaskSkip,
    this.onCalendarEventLongPress,
    this.previewLimit,
  });

  final List<HomeTodayTaskEntity> calendarEvents;
  final List<HomeTodayTaskEntity> goalTasks;
  final String selectedTaskId;
  final ValueChanged<String> onTaskTap;
  final ValueChanged<String> onTaskDone;
  final ValueChanged<String> onTaskSkip;
  final ValueChanged<HomeTodayTaskEntity>? onCalendarEventLongPress;
  final int? previewLimit;

  @override
  Widget build(BuildContext context) {
    final events = previewLimit != null
        ? calendarEvents.take(previewLimit!).toList(growable: false)
        : calendarEvents;
    final goals = previewLimit != null
        ? goalTasks.take(previewLimit!).toList(growable: false)
        : goalTasks;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: AppTexts.agendaCalendarSection),
        AppSpacing.vertical(context, 0.008),
        if (events.isEmpty)
          _EmptyHint(text: AppTexts.scheduleDisplayEmptyDay)
        else
          HomeTodayTasksTimeline(
            tasks: events,
            selectedTaskId: selectedTaskId,
            onTaskTap: onTaskTap,
            onTaskDone: onTaskDone,
            onTaskSkip: onTaskSkip,
            onCalendarEventLongPress: onCalendarEventLongPress,
          ),
        AppSpacing.vertical(context, 0.016),
        _SectionHeader(title: AppTexts.agendaGoalTasksSection),
        AppSpacing.vertical(context, 0.008),
        if (goals.isEmpty)
          _EmptyHint(text: AppTexts.scheduleDisplayEmptyDay)
        else
          HomeTodayTasksTimeline(
            tasks: goals,
            selectedTaskId: selectedTaskId,
            onTaskTap: onTaskTap,
            onTaskDone: onTaskDone,
            onTaskSkip: onTaskSkip,
          ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.labelText(context).copyWith(
        color: context.onSurfaceColor,
        fontWeight: FontWeight.w700,
        fontSize: AppResponsive.scaleSize(context, 12),
        letterSpacing: 0.8,
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.hintText(context));
  }
}
