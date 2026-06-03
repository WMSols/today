import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/common/app_progress_ring.dart';
import 'package:today/core/widgets/common/app_section_card.dart';
import 'package:today/presentation/controllers/analytics/analytics_controller.dart';

class AnalyticsTaskOutcomesSection extends GetView<AnalyticsController> {
  const AnalyticsTaskOutcomesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final revision = controller.dashboardRevision.value;
      final animation = controller.chartAnimationFactor.value;
      controller.dashboard.value;
      final outcomes = controller.taskOutcomes;
      final onCard = context.onSectionCardColor;
      final muted = onCard.withValues(alpha: 0.7);
      final trackColor = context.sectionCardRingTrackColor;

      return AppSectionCard(
        child: Column(
          key: ValueKey('analytics-outcomes-$revision'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    AppTexts.analyticsTaskOutcomesTitle,
                    style: AppTextStyles.labelText(context).copyWith(
                      color: onCard,
                      fontWeight: FontWeight.w600,
                      fontSize: AppResponsive.scaleSize(context, 12),
                    ),
                  ),
                ),
                if (outcomes.periodLabel.isNotEmpty)
                  Text(
                    outcomes.periodLabel,
                    style: AppTextStyles.labelText(context).copyWith(
                      color: muted,
                      fontWeight: FontWeight.w500,
                      fontSize: AppResponsive.scaleSize(context, 10),
                    ),
                  ),
                AppSpacing.horizontal(context, 0.015),
                Icon(
                  Iconsax.task_square,
                  size: AppResponsive.iconSize(context, factor: 0.7),
                  color: onCard,
                ),
              ],
            ),
            if (!outcomes.hasActivity) ...[
              AppSpacing.vertical(context, 0.015),
              Text(
                AppTexts.analyticsTaskOutcomesEmpty,
                style: AppTextStyles.labelText(context).copyWith(
                  color: muted,
                  fontSize: AppResponsive.scaleSize(context, 11),
                ),
              ),
            ] else ...[
              AppSpacing.vertical(context, 0.008),
              Text(
                AppTexts.analyticsTaskOutcomesPlannedSummary(
                  outcomes.total,
                  outcomes.completed,
                ),
                style: AppTextStyles.labelText(context).copyWith(
                  color: muted,
                  fontSize: AppResponsive.scaleSize(context, 10),
                ),
              ),
              AppSpacing.vertical(context, 0.015),
              _OutcomeRow(
                label: AppTexts.analyticsTaskOutcomesCompleted,
                count: outcomes.completed,
                total: outcomes.total,
                barColor: AppColors.success,
                trackColor: trackColor,
                labelColor: onCard,
                mutedColor: muted,
                animationFactor: animation,
              ),
              AppSpacing.vertical(context, 0.01),
              _OutcomeRow(
                label: AppTexts.analyticsTaskOutcomesSkipped,
                count: outcomes.skipped,
                total: outcomes.total,
                barColor: AppColors.warning,
                trackColor: trackColor,
                labelColor: onCard,
                mutedColor: muted,
                animationFactor: animation,
              ),
              AppSpacing.vertical(context, 0.01),
              _OutcomeRow(
                label: AppTexts.analyticsTaskOutcomesPending,
                count: outcomes.pending,
                total: outcomes.total,
                barColor: onCard.withValues(alpha: 0.45),
                trackColor: trackColor,
                labelColor: onCard,
                mutedColor: muted,
                animationFactor: animation,
              ),
            ],
          ],
        ),
      );
    });
  }
}

class _OutcomeRow extends StatelessWidget {
  const _OutcomeRow({
    required this.label,
    required this.count,
    required this.total,
    required this.barColor,
    required this.trackColor,
    required this.labelColor,
    required this.mutedColor,
    required this.animationFactor,
  });

  final String label;
  final int count;
  final int total;
  final Color barColor;
  final Color trackColor;
  final Color labelColor;
  final Color mutedColor;
  final double animationFactor;

  @override
  Widget build(BuildContext context) {
    final fraction = total > 0 ? count / total : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.labelText(context).copyWith(
                  color: labelColor,
                  fontWeight: FontWeight.w500,
                  fontSize: AppResponsive.scaleSize(context, 11),
                ),
              ),
            ),
            Text(
              '$count',
              style: AppTextStyles.labelText(context).copyWith(
                color: mutedColor,
                fontWeight: FontWeight.w600,
                fontSize: AppResponsive.scaleSize(context, 11),
              ),
            ),
          ],
        ),
        AppSpacing.vertical(context, 0.006),
        AppLinearProgressBar(
          progress: fraction,
          trackColor: trackColor,
          progressColor: barColor,
          animationFactor: animationFactor,
          height: AppResponsive.scaleSize(context, 6),
        ),
      ],
    );
  }
}
