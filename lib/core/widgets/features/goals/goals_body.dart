import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/widgets/features/goals/goals_prompt.dart';

class GoalsBody extends StatelessWidget {
  const GoalsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const GoalsPrompt(),
        const Spacer(),
        Text(
          'Goals UI will be implemented from Figma.',
          style: AppTextStyles.bodyText(context).copyWith(color: AppColors.white),
        ),
      ],
    );
  }
}

