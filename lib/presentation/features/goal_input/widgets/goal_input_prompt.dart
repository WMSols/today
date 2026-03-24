import 'package:flutter/material.dart';

import 'package:today/core/utils/app_styles/app_text_styles.dart';

class GoalInputPrompt extends StatelessWidget {
  const GoalInputPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'What is your main goal right now?',
      style: AppTextStyles.heading(context),
    );
  }
}
