import 'package:flutter/material.dart';

import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/presentation/features/dashboard/widgets/dashboard_summary_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: AppSpacing.symmetric(context, h: 0.06, v: 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DashboardSummaryCard(),
            AppSpacing.vertical(context, 0.02),
            Text(
              'Dashboard UI will be implemented from Figma.',
              style: AppTextStyles.bodyText(context),
            ),
          ],
        ),
      ),
    );
  }
}
