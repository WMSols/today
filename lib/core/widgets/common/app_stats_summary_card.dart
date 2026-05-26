import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_helper/app_helper.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/widgets/common/app_progress_ring.dart';
import 'package:today/core/widgets/common/app_section_card.dart';

class AppStatsMetric {
  const AppStatsMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}

/// Progress panel plus stacked metric tiles — same layout as today's tasks stats.
class AppStatsSummaryCard extends StatelessWidget {
  const AppStatsSummaryCard({
    super.key,
    required this.progress,
    required this.progressAnimationFactor,
    required this.progressTitle,
    required this.progressIcon,
    required this.hasProgressActivity,
    required this.metricTop,
    required this.metricBottom,
    this.height,
    this.progressFlex = 3,
    this.metricsFlex = 2,
  });

  final double progress;
  final double progressAnimationFactor;
  final String progressTitle;
  final IconData progressIcon;
  final bool hasProgressActivity;
  final AppStatsMetric metricTop;
  final AppStatsMetric metricBottom;
  final double? height;
  final int progressFlex;
  final int metricsFlex;

  @override
  Widget build(BuildContext context) {
    final rowHeight = height ?? AppResponsive.scaleSize(context, 140);
    final statusColor = hasProgressActivity
        ? AppHelper.activityColorForProgress(progress)
        : AppHelper.activityColor(HomeDailyCalendarActivityLevel.none);
    final onCard = context.onSectionCardColor;
    final trackColor = context.sectionCardRingTrackColor;
    final percentLabel = '${(progress * 100).round()}%';

    return SizedBox(
      height: rowHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: progressFlex,
            child: AppSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSectionCardHeader(
                    icon: progressIcon,
                    title: progressTitle,
                    iconColor: onCard,
                    iconSizeFactor: 0.6,
                    titleFontSize: 12,
                  ),
                  Spacer(),
                  Text(
                    percentLabel,
                    style: AppTextStyles.heading(context).copyWith(
                      color: onCard,
                      fontWeight: FontWeight.w700,
                      fontSize: AppResponsive.scaleSize(context, 28),
                      height: 1,
                    ),
                  ),
                  AppSpacing.vertical(context, 0.01),
                  AppLinearProgressBar(
                    progress: progress,
                    trackColor: trackColor,
                    progressColor: statusColor,
                    animationFactor: progressAnimationFactor,
                    height: AppResponsive.scaleSize(context, 8),
                  ),
                ],
              ),
            ),
          ),
          AppSpacing.horizontal(context, 0.02),
          Expanded(
            flex: metricsFlex,
            child: Column(
              children: [
                Expanded(child: _MetricTile(metric: metricTop)),
                AppSpacing.vertical(context, 0.01),
                Expanded(child: _MetricTile(metric: metricBottom)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.metric});

  final AppStatsMetric metric;

  @override
  Widget build(BuildContext context) {
    final onCard = context.onSectionCardColor;

    return SizedBox.expand(
      child: AppSectionCard(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSectionCardHeader(
                      icon: metric.icon,
                      title: metric.label,
                      iconColor: onCard,
                      iconSizeFactor: 0.6,
                      titleFontSize: 8,
                    ),
                    SizedBox(height: AppResponsive.scaleSize(context, 2)),
                    Text(
                      metric.value,
                      style: AppTextStyles.heading(context).copyWith(
                        color: onCard,
                        fontWeight: FontWeight.w700,
                        fontSize: AppResponsive.scaleSize(context, 20),
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
