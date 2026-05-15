import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/common/app_custom_app_bar.dart';

class AnalyticsTabContent extends StatelessWidget {
  const AnalyticsTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppCustomAppBar.titleOnly(title: AppTexts.analyticsTitle),
          AppSpacing.vertical(context, 0.04),
          Text(
            AppTexts.analyticsTabPlaceholder,
            style: AppTextStyles.bodyText(
              context,
            ).copyWith(color: isDark ? AppColors.lightGrey : AppColors.grey),
          ),
        ],
      ),
    );
  }
}
