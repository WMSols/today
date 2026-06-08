import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/widgets/common/app_section_card.dart';

class ProfileSetupTimeCard extends StatelessWidget {
  const ProfileSetupTimeCard({
    super.key,
    required this.label,
    required this.timeLabel,
    required this.leadingIcon,
    required this.onTap,
  });

  final String label;
  final String timeLabel;
  final IconData leadingIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.labelText(context).copyWith(
              color: context.onSectionCardColor,
              fontWeight: FontWeight.w600,
              fontSize: AppResponsive.scaleSize(context, 10),
              letterSpacing: 0.8,
            ),
          ),
          AppSpacing.vertical(context, 0.005),
          Row(
            children: [
              Icon(
                leadingIcon,
                size: AppResponsive.iconSize(context, factor: 0.9),
                color: context.onSectionCardColor,
              ),
              AppSpacing.horizontal(context, 0.015),
              Expanded(
                child: Text(
                  timeLabel,
                  style: AppTextStyles.heading(context).copyWith(
                    color: context.onSectionCardColor,
                    fontWeight: FontWeight.w600,
                    fontSize: AppResponsive.scaleSize(context, 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
