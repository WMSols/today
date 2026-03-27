import 'package:flutter/material.dart';

import 'package:today/core/utils/app_helper/app_helper.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/domain/entities/active_goal_task_entity.dart';

class ActiveGoalTasksCard extends StatelessWidget {
  const ActiveGoalTasksCard({super.key, required this.tasks});

  final List<ActiveGoalTaskEntity> tasks;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.symmetric(context, h: 0.04, v: 0.03),
      decoration: BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, factor: 5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                AppImages.streak,
                width: AppResponsive.scaleSize(context, 10),
                height: AppResponsive.scaleSize(context, 10),
              ),
              AppSpacing.horizontal(context, 0.01),
              Text(
                'TODAYS TASKS',
                style: AppTextStyles.labelText(context).copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
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
              child: _ActiveGoalTaskRow(task: task),
            );
          }),
        ],
      ),
    );
  }
}

class _ActiveGoalTaskRow extends StatelessWidget {
  const _ActiveGoalTaskRow({required this.task});

  final ActiveGoalTaskEntity task;

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
                      color: AppHelpers.taskLevelColor(task.level),
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
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: AppResponsive.scaleSize(context, 14),
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: AppResponsive.scaleSize(context, 14),
          height: AppResponsive.scaleSize(context, 14),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.white),
          ),
        ),
      ],
    );
  }
}
