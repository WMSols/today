import 'package:flutter/material.dart';

import 'package:today/core/utils/app_styles/app_text_styles.dart';

class DashboardSummaryCard extends StatelessWidget {
  const DashboardSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('Today', style: AppTextStyles.headline(context));
  }
}
