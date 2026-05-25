import 'package:flutter/material.dart';

import 'package:today/core/theme/app_accent_color.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';

/// Thin indeterminate line shown while pull-to-refresh is loading (Snapchat-style).
class AppRefreshProgressBar extends StatelessWidget {
  const AppRefreshProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    final color = AppAccentColor.lavendar.color;
    final height = AppResponsive.scaleSize(context, 3);
    return SizedBox(
      width: double.infinity,
      height: height,
      child: LinearProgressIndicator(
        minHeight: height,
        backgroundColor: color.withValues(alpha: 0.35),
        valueColor: AlwaysStoppedAnimation<Color>(color),
        borderRadius: BorderRadius.zero,
      ),
    );
  }
}
