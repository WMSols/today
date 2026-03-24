import 'package:flutter/material.dart';

import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/presentation/features/goal_input/widgets/goal_input_prompt.dart';

class GoalInputScreen extends StatelessWidget {
  const GoalInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: AppSpacing.symmetric(context, h: 0.06, v: 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const GoalInputPrompt(),
            AppSpacing.vertical(context, 0.02),
            Text(
              'Goal input UI will be implemented from Figma.',
              style: AppTextStyles.bodyText(context),
            ),
          ],
        ),
      ),
    );
  }
}
