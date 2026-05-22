import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';

class GoalProgressBar extends StatelessWidget {
  const GoalProgressBar({
    super.key,
    required this.progress,
    this.trackColor,
    this.valueColor,
  });

  final double progress;
  final Color? trackColor;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0, 1.0).toDouble();
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        AppResponsive.radius(context, factor: 5),
      ),
      child: LinearProgressIndicator(
        value: clamped,
        minHeight: AppResponsive.scaleSize(context, 8),
        backgroundColor:
            trackColor ?? context.mutedOnSurfaceColor.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, factor: 5),
        ),
        valueColor: AlwaysStoppedAnimation<Color>(
          valueColor ?? context.onSurfaceColor,
        ),
      ),
    );
  }
}
