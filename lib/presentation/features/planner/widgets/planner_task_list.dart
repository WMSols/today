import 'package:flutter/material.dart';

import 'package:today/core/utils/app_styles/app_text_styles.dart';

class PlannerTaskList extends StatelessWidget {
  const PlannerTaskList({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('Today plan', style: AppTextStyles.headline(context));
  }
}
