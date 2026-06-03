import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/common/app_custom_app_bar.dart';
import 'package:today/core/widgets/common/app_page_scaffold.dart';
import 'package:today/core/widgets/common/app_pull_to_refresh.dart';
import 'package:today/core/widgets/features/analytics/analytics_activity_heatmap_section.dart';
import 'package:today/core/widgets/features/analytics/analytics_productivity_percentage_section.dart';
import 'package:today/core/widgets/features/analytics/analytics_task_outcomes_section.dart';
import 'package:today/core/widgets/features/analytics/analytics_week_at_a_glance_section.dart';
import 'package:today/core/widgets/features/analytics/analytics_weekly_consistency_section.dart';
import 'package:today/presentation/controllers/analytics/analytics_controller.dart';

class AnalyticsScreen extends GetView<AnalyticsController> {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.surfaceColor,
      child: AppPullToRefresh(
        onRefresh: controller.refreshAnalytics,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: AppPageScaffold.defaultBodyPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppCustomAppBar.titleOnly(title: AppTexts.analyticsTitle),
              AppSpacing.vertical(context, 0.02),
              const AnalyticsWeekAtAGlanceSection(),
              AppSpacing.vertical(context, 0.01),
              const AnalyticsProductivityPercentageSection(),
              AppSpacing.vertical(context, 0.01),
              const AnalyticsWeeklyConsistencySection(),
              AppSpacing.vertical(context, 0.01),
              const AnalyticsTaskOutcomesSection(),
              AppSpacing.vertical(context, 0.01),
              const AnalyticsActivityHeatmapSection(),
              AppSpacing.vertical(context, 0.1),
            ],
          ),
        ),
      ),
    );
  }
}
