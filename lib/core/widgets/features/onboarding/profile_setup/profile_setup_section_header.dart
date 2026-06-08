import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';

/// Title + short helper text for profile setup form sections.
class ProfileSetupSectionHeader extends StatelessWidget {
  const ProfileSetupSectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.heading(context).copyWith(
            color: context.onSurfaceColor,
            fontWeight: FontWeight.w600,
            fontSize: AppResponsive.scaleSize(context, 16),
          ),
        ),
        Text(
          subtitle,
          style: AppTextStyles.bodyText(context).copyWith(
            color: context.onSurfaceColor,
            fontWeight: FontWeight.w500,
            fontSize: AppResponsive.scaleSize(context, 12),
            height: 1.25,
          ),
        ),
      ],
    );
  }
}
