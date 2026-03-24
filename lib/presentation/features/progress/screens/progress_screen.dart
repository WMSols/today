import 'package:flutter/material.dart';

import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/presentation/features/progress/widgets/progress_streak_card.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: AppSpacing.symmetric(context, h: 0.06, v: 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProgressStreakCard(),
            AppSpacing.vertical(context, 0.02),
            Text(
              'Progress UI will be implemented from Figma.',
              style: AppTextStyles.bodyText(context),
            ),
          ],
        ),
      ),
    );
  }
}
