import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/common/app_section_card.dart';
import 'package:today/presentation/controllers/analytics/analytics_controller.dart';

class AnalyticsWeekAtAGlanceSection extends GetView<AnalyticsController> {
  const AnalyticsWeekAtAGlanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final revision = controller.dashboardRevision.value;
      controller.dashboard.value;
      final glance = controller.weekAtAGlance;
      final onCard = context.onSectionCardColor;
      final muted = onCard.withValues(alpha: 0.7);
      final tileBg = context.sectionCardRingTrackColor;

      return AppSectionCard(
        child: Column(
          key: ValueKey('analytics-glance-$revision'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    AppTexts.analyticsWeekAtAGlanceTitle,
                    style: AppTextStyles.labelText(context).copyWith(
                      color: onCard,
                      fontWeight: FontWeight.w600,
                      fontSize: AppResponsive.scaleSize(context, 12),
                    ),
                  ),
                ),
                Icon(
                  Iconsax.calendar_1,
                  size: AppResponsive.iconSize(context, factor: 0.7),
                  color: onCard,
                ),
              ],
            ),
            AppSpacing.vertical(context, 0.01),
            Row(
              children: [
                Expanded(
                  child: _GlanceTile(
                    backgroundColor: tileBg,
                    label: AppTexts.analyticsWeekAtAGlanceAverage,
                    value: glance.hasWeekData
                        ? '${glance.averagePercent}%'
                        : '—',
                    labelColor: muted,
                    valueColor: onCard,
                  ),
                ),
                AppSpacing.horizontal(context, 0.01),
                Expanded(
                  child: _GlanceTile(
                    backgroundColor: tileBg,
                    label: AppTexts.analyticsWeekAtAGlanceBestDay,
                    value: glance.bestDayLabel,
                    labelColor: muted,
                    valueColor: onCard,
                  ),
                ),
                AppSpacing.horizontal(context, 0.01),
                Expanded(
                  child: _GlanceTile(
                    backgroundColor: tileBg,
                    label: AppTexts.analyticsWeekAtAGlanceOnTrack,
                    value: glance.hasWeekData
                        ? '${glance.daysOnTrack}/${glance.daysTotal}'
                        : '—',
                    labelColor: muted,
                    valueColor: onCard,
                  ),
                ),
              ],
            ),
            if (glance.insight.isNotEmpty) ...[
              AppSpacing.vertical(context, 0.01),
              Text(
                glance.insight,
                style: AppTextStyles.labelText(context).copyWith(
                  color: muted,
                  fontSize: AppResponsive.scaleSize(context, 11),
                  height: 1.35,
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}

class _GlanceTile extends StatelessWidget {
  const _GlanceTile({
    required this.backgroundColor,
    required this.label,
    required this.value,
    required this.labelColor,
    required this.valueColor,
  });

  final Color backgroundColor;
  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.symmetric(context, h: 0.02, v: 0.01),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.labelText(context).copyWith(
              color: labelColor,
              fontWeight: FontWeight.w500,
              fontSize: AppResponsive.scaleSize(context, 9),
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppTextStyles.heading(context).copyWith(
                color: valueColor,
                fontWeight: FontWeight.w700,
                fontSize: AppResponsive.scaleSize(context, 18),
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
