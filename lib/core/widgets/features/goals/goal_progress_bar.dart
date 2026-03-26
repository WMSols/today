import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';

class GoalProgressBar extends StatelessWidget {
  const GoalProgressBar({
    super.key,
    required this.progress,
  });

  final double progress;

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0, 1.0).toDouble();
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppResponsive.scaleSize(context, 10)),
      child: LinearProgressIndicator(
        value: clamped,
        minHeight: AppResponsive.scaleSize(context, 8),
        backgroundColor: AppColors.grey.withValues(alpha: 0.22),
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.white),
      ),
    );
  }
}

