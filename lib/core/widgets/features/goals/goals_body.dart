import 'package:flutter/material.dart';

import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/widgets/common/app_custom_app_bar.dart';
import 'package:today/core/widgets/features/goals/goals_card_item.dart';

class GoalsBody extends StatelessWidget {
  const GoalsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppCustomAppBar.titleOnly(title: 'Goals'),
          AppSpacing.vertical(context, 0.02),
          const GoalsCardItem(
            title: 'Get fit in 30 days',
            dayText: 'DAY 07 OF 30',
            tasksText: '2/6 TASKS',
            percentText: '38%',
            gemsText: '20 GEMS',
            totalTasksText: '14 TASKS DONE IN TOTAL',
            progress: 0.38,
            iconPath: AppImages.medal1,
          ),
          AppSpacing.vertical(context, 0.02),
          const GoalsCardItem(
            title: 'Speak French fluently',
            dayText: 'DAY 07 OF 30',
            tasksText: '0/6 TASKS',
            percentText: '0%',
            gemsText: '18 GEMS',
            totalTasksText: '14 TASKS DONE IN TOTAL',
            progress: 0,
            iconPath: AppImages.medal2,
          ),
          AppSpacing.vertical(context, 0.02),
          const GoalsCardItem(
            title: 'Save \$500 in 45 days',
            dayText: 'DAY 07 OF 45',
            tasksText: '0/6 TASKS',
            percentText: '0%',
            gemsText: '18 GEMS',
            totalTasksText: '14 TASKS DONE IN TOTAL',
            progress: 0,
            iconPath: AppImages.medal3,
          ),
          AppSpacing.vertical(context, 0.14),
        ],
      ),
    );
  }
}
