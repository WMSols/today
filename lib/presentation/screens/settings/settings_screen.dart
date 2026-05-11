import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/widgets/features/settings/settings_body.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.black : AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
          child: const SettingsBody(),
        ),
      ),
    );
  }
}
