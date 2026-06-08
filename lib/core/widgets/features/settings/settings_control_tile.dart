import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/widgets/common/app_section_card.dart';

/// Single settings option surface: title, short subtitle, and trailing control.
class SettingsControlTile extends StatelessWidget {
  const SettingsControlTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final titleColor = context.onSectionCardColor;
    final subtitleColor = titleColor.withValues(alpha: 0.55);

    return AppSectionCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyText(context).copyWith(
                    color: titleColor,
                    fontWeight: FontWeight.w600,
                    fontSize: AppResponsive.scaleSize(context, 14),
                  ),
                ),
                Text(
                  subtitle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: AppTextStyles.labelText(context).copyWith(
                    color: subtitleColor,
                    fontWeight: FontWeight.w500,
                    fontSize: AppResponsive.scaleSize(context, 11),
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.horizontal(context, 0.03),
          trailing,
        ],
      ),
    );
  }
}
