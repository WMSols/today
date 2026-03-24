import 'package:flutter/material.dart';

import 'package:today/core/utils/app_styles/app_text_styles.dart';

class PlannerTaskTile extends StatelessWidget {
  const PlannerTaskTile({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: AppTextStyles.bodyText(context)),
    );
  }
}
