import 'package:flutter/material.dart';

import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/presentation/features/planner/widgets/planner_task_list.dart';

class PlannerScreen extends StatelessWidget {
  const PlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: AppSpacing.symmetric(context, h: 0.06, v: 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PlannerTaskList(),
            AppSpacing.vertical(context, 0.02),
            Text(
              'Planner UI will be implemented from Figma.',
              style: AppTextStyles.bodyText(context),
            ),
          ],
        ),
      ),
    );
  }
}
