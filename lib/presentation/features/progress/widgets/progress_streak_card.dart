import 'package:flutter/material.dart';

import 'package:today/core/utils/app_styles/app_text_styles.dart';

class ProgressStreakCard extends StatelessWidget {
  const ProgressStreakCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('Your progress', style: AppTextStyles.headline(context));
  }
}
