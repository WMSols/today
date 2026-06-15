import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/widgets/common/app_section_card.dart';

class AppDrawerHistoryEntry {
  const AppDrawerHistoryEntry({
    required this.id,
    required this.title,
    required this.timeLabel,
    required this.isSelected,
    required this.onTap,
  });

  final String id;
  final String title;
  final String timeLabel;
  final bool isSelected;
  final VoidCallback onTap;
}

class AppDrawerHistoryTile extends StatelessWidget {
  const AppDrawerHistoryTile({
    super.key,
    required this.title,
    required this.timeLabel,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String timeLabel;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final onSurface = context.onSurfaceColor;
    final muted = context.mutedOnSurfaceColor;

    return AppSectionCard(
      onTap: onTap,
      backgroundColor: isSelected
          ? context.sectionCardColor
          : Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyText(context).copyWith(
              color: isSelected ? context.onSectionCardColor : onSurface,
              fontWeight: FontWeight.w600,
              fontSize: AppResponsive.scaleSize(context, 14),
            ),
          ),
          Text(
            timeLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.labelText(context).copyWith(
              color: isSelected ? context.onSectionCardColor : muted,
              fontWeight: FontWeight.w500,
              fontSize: AppResponsive.scaleSize(context, 11),
            ),
          ),
        ],
      ),
    );
  }
}
