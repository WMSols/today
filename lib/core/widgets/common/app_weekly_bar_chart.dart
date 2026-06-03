import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_helper/app_helper.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';

/// Seven-day vertical bar chart for weekly progress values in `[0, 1]`.
class AppWeeklyBarChart extends StatelessWidget {
  const AppWeeklyBarChart({
    super.key,
    required this.progressValues,
    required this.dayLabels,
    this.chartHeight,
    this.animationFactor = 1,
  });

  final List<double> progressValues;
  final List<String> dayLabels;
  final double? chartHeight;
  final double animationFactor;

  @override
  Widget build(BuildContext context) {
    final height = chartHeight ?? AppResponsive.scaleSize(context, 112);
    final barCount = progressValues.length;
    final labels = dayLabels.length >= barCount
        ? dayLabels
        : List<String>.generate(barCount, (i) => '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < barCount; i++) ...[
                if (i > 0) SizedBox(width: AppResponsive.scaleSize(context, 6)),
                Expanded(
                  child: _Bar(
                    progress: progressValues[i],
                    animationFactor: animationFactor,
                    trackColor: context.sectionCardRingTrackColor,
                    valueColor: AppHelper.activityColorForProgress(
                      progressValues[i],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: AppResponsive.scaleSize(context, 8)),
        Row(
          children: [
            for (var i = 0; i < barCount; i++) ...[
              if (i > 0) SizedBox(width: AppResponsive.scaleSize(context, 6)),
              Expanded(
                child: Text(
                  labels[i],
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelText(context).copyWith(
                    color: context.onSectionCardColor,
                    fontWeight: FontWeight.w600,
                    fontSize: AppResponsive.scaleSize(context, 10),
                    height: 1,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.progress,
    required this.animationFactor,
    required this.trackColor,
    required this.valueColor,
  });

  final double progress;
  final double animationFactor;
  final Color trackColor;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0) * animationFactor.clamp(0.0, 1.0);
    final radius = AppResponsive.radius(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final fillHeight = constraints.maxHeight * clamped;
        return ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: double.infinity,
                height: constraints.maxHeight,
                color: trackColor,
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                width: double.infinity,
                height: fillHeight,
                decoration: BoxDecoration(
                  color: valueColor,
                  borderRadius: BorderRadius.circular(radius),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
