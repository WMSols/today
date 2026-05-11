import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';

import 'package:today/core/utils/app_responsive/app_responsive.dart';

class GoalProgressBar extends StatelessWidget {
  const GoalProgressBar({super.key, required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final clamped = progress.clamp(0, 1.0).toDouble();
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        AppResponsive.radius(context, factor: 5),
      ),
      child: LinearProgressIndicator(
        value: clamped,
        minHeight: AppResponsive.scaleSize(context, 8),
        backgroundColor: isDark ? AppColors.lightGrey : AppColors.grey,
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, factor: 5),
        ),
        valueColor: AlwaysStoppedAnimation<Color>(
          isDark ? AppColors.white : AppColors.black,
        ),
      ),
    );
  }
}
