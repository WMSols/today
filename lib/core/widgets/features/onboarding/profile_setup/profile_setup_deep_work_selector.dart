import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/features/onboarding/profile_setup/profile_setup_section_header.dart';
import 'package:today/domain/entities/profile_setup_entity.dart';

class ProfileSetupDeepWorkSelector extends StatelessWidget {
  const ProfileSetupDeepWorkSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final DeepWorkPreference selected;
  final ValueChanged<DeepWorkPreference> onSelected;

  static const _options = <(DeepWorkPreference, String)>[
    (DeepWorkPreference.earlyBird, AppTexts.profileSetupDeepWorkEarlyBird),
    (DeepWorkPreference.midDay, AppTexts.profileSetupDeepWorkMidDay),
    (DeepWorkPreference.nightOwl, AppTexts.profileSetupDeepWorkNightOwl),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ProfileSetupSectionHeader(
          title: AppTexts.profileSetupDeepWorkTitle,
          subtitle: AppTexts.profileSetupDeepWorkSubtitle,
        ),
        AppSpacing.vertical(context, 0.005),
        Container(
          padding: AppSpacing.symmetric(context, h: 0.02, v: 0.005),
          decoration: BoxDecoration(
            color: context.sectionCardColor,
            borderRadius: BorderRadius.circular(
              AppResponsive.radius(context, factor: 3),
            ),
          ),
          child: Row(
            children: [
              for (var i = 0; i < _options.length; i++)
                Expanded(
                  child: _Segment(
                    label: _options[i].$2,
                    isSelected: selected == _options[i].$1,
                    onTap: () => onSelected(_options[i].$1),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        alignment: Alignment.center,
        padding: AppSpacing.symmetric(context, h: 0.01, v: 0.01),
        decoration: BoxDecoration(
          color: isSelected ? context.surfaceColor : Colors.transparent,
          borderRadius: BorderRadius.circular(
            AppResponsive.radius(context, factor: 2.5),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: context.onSurfaceColor.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.labelText(context).copyWith(
            color: isSelected
                ? context.onSurfaceColor
                : context.onSectionCardColor,
            fontWeight: FontWeight.w600,
            fontSize: AppResponsive.scaleSize(context, 11),
          ),
        ),
      ),
    );
  }
}
