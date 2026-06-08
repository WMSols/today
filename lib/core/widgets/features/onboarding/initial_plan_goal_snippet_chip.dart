import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';

class InitialPlanGoalSnippetChip extends StatelessWidget {
  const InitialPlanGoalSnippetChip({
    super.key,
    required this.label,
    required this.onTap,
    this.enabled = true,
  });

  final String label;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final palette = context.accentPalette;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, factor: 4),
        ),
        child: Container(
          padding: AppSpacing.symmetric(context, h: 0.025, v: 0.008),
          decoration: BoxDecoration(
            color: palette.sectionCard,
            borderRadius: BorderRadius.circular(
              AppResponsive.radius(context, factor: 4),
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.labelText(context).copyWith(
              color: palette.onSectionCard,
              fontWeight: FontWeight.w600,
              fontSize: AppResponsive.scaleSize(context, 10),
              height: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
