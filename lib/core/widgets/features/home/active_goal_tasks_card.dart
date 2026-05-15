import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_helper/app_helper.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/common/app_section_card.dart';
import 'package:today/domain/entities/active_goal_task_entity.dart';

class ActiveGoalTasksCard extends StatelessWidget {
  const ActiveGoalTasksCard({
    super.key,
    required this.tasks,
    this.onCompleteTap,
    this.onSkipTask,
  });

  final List<ActiveGoalTaskEntity> tasks;
  final ValueChanged<String>? onCompleteTap;
  final ValueChanged<String>? onSkipTask;

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      paddingVertical: 0.03,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                AppImages.tasksCompleted,
                width: AppResponsive.scaleSize(context, 10),
                height: AppResponsive.scaleSize(context, 10),
              ),
              AppSpacing.horizontal(context, 0.01),
              Text(
                AppTexts.todaysTasksHeading,
                style: AppTextStyles.labelText(context).copyWith(
                  color: context.onSurfaceColor,
                  fontWeight: FontWeight.w600,
                  fontSize: AppResponsive.scaleSize(context, 10),
                ),
              ),
            ],
          ),
          AppSpacing.vertical(context, 0.02),
          ...List.generate(tasks.length, (index) {
            final task = tasks[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: AppResponsive.scaleSize(context, 16),
              ),
              child: _ActiveGoalTaskRow(
                task: task,
                onCompleteTap: onCompleteTap,
                onSkipTask: onSkipTask,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ActiveGoalTaskRow extends StatelessWidget {
  const _ActiveGoalTaskRow({
    required this.task,
    this.onCompleteTap,
    this.onSkipTask,
  });

  final ActiveGoalTaskEntity task;
  final ValueChanged<String>? onCompleteTap;
  final ValueChanged<String>? onSkipTask;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    task.iconPath,
                    width: AppResponsive.scaleSize(context, 6),
                    height: AppResponsive.scaleSize(context, 6),
                  ),
                  AppSpacing.horizontal(context, 0.006),
                  Text(
                    task.level,
                    style: AppTextStyles.labelText(context).copyWith(
                      color: AppHelper.taskLevelColor(task.level),
                      fontWeight: FontWeight.w600,
                      fontSize: AppResponsive.scaleSize(context, 6),
                    ),
                  ),
                ],
              ),
              AppSpacing.vertical(context, 0.004),
              Text(
                task.title,
                style: AppTextStyles.heading(context).copyWith(
                  color: context.onSurfaceColor,
                  fontWeight: FontWeight.w600,
                  fontSize: AppResponsive.scaleSize(context, 14),
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onCompleteTap == null ? null : () => onCompleteTap!(task.id),
          onLongPress: onSkipTask == null ? null : () => onSkipTask!(task.id),
          child: Container(
            width: AppResponsive.scaleSize(context, 14),
            height: AppResponsive.scaleSize(context, 14),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: context.onSurfaceColor),
              color: task.status == 'completed'
                  ? context.onSurfaceColor
                  : Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }
}
