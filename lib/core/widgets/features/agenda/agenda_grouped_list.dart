import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_formatter/app_formatter.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/features/calendar/schedule_display_section.dart';
import 'package:today/core/widgets/features/home/todays_tasks/home_today_tasks_timeline.dart';
import 'package:today/presentation/controllers/agenda/agenda_controller.dart';

class AgendaGroupedList extends GetView<AgendaController> {
  const AgendaGroupedList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.usesScheduleDisplay) {
        final display = controller.filteredScheduleDisplay;
        if (display == null) {
          return _emptyHint(context);
        }
        return ScheduleDisplaySection(display: display);
      }

      final groups = controller.groupedTasks;
      if (groups.isEmpty) {
        return _emptyHint(context);
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(groups.length, (index) {
          final group = groups[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == groups.length - 1
                  ? 0
                  : AppSpacing.verticalValue(context, 0.02),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppFormatter.agendaDayHeading(group.date),
                  style: AppTextStyles.bodyText(context).copyWith(
                    color: context.onSurfaceColor,
                    fontWeight: FontWeight.w600,
                    fontSize: AppResponsive.scaleSize(context, 13),
                  ),
                ),
                AppSpacing.vertical(context, 0.01),
                HomeTodayTasksTimeline(
                  tasks: group.tasks,
                  selectedTaskId: controller.selectedTaskId.value,
                  onTaskTap: controller.selectTask,
                  onTaskDone: controller.completeTask,
                  onTaskSkip: controller.skipTask,
                  onCalendarEventLongPress: controller.onCalendarEventLongPress,
                ),
              ],
            ),
          );
        }),
      );
    });
  }

  Widget _emptyHint(BuildContext context) {
    return Padding(
      padding: AppSpacing.symmetric(context, v: 0.04),
      child: Center(
        child: Text(
          AppTexts.agendaEmpty,
          style: AppTextStyles.hintText(
            context,
          ).copyWith(color: context.mutedOnSurfaceColor),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
