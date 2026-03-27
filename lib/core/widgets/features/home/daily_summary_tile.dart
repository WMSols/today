import 'package:flutter/material.dart';

import 'package:today/core/utils/app_styles/app_text_styles.dart';

/// Reusable stat tile for Home screen summaries.
class DailySummaryTile extends StatelessWidget {
  const DailySummaryTile({super.key, required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.hintText(context)),
        Text(value, style: AppTextStyles.heading(context)),
      ],
    );
  }
}
