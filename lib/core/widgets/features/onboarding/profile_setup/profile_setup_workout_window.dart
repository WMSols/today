import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/features/onboarding/profile_setup/profile_setup_section_header.dart';
import 'package:today/domain/entities/profile_setup_entity.dart';

class ProfileSetupWorkoutWindow extends StatelessWidget {
  const ProfileSetupWorkoutWindow({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final WorkoutWindow selected;
  final ValueChanged<WorkoutWindow> onSelected;

  static const _options = <(WorkoutWindow, String, String)>[
    (
      WorkoutWindow.morning,
      AppImages.morning,
      AppTexts.profileSetupWorkoutMorning,
    ),
    (
      WorkoutWindow.afternoon,
      AppImages.afternoon,
      AppTexts.profileSetupWorkoutAfternoon,
    ),
    (
      WorkoutWindow.evening,
      AppImages.evening,
      AppTexts.profileSetupWorkoutEvening,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ProfileSetupSectionHeader(
          title: AppTexts.profileSetupWorkoutWindowTitle,
          subtitle: AppTexts.profileSetupWorkoutWindowSubtitle,
        ),
        AppSpacing.vertical(context, 0.005),
        Row(
          children: [
            for (var i = 0; i < _options.length; i++) ...[
              if (i > 0) AppSpacing.horizontal(context, 0.02),
              Expanded(
                child: _WorkoutCard(
                  label: _options[i].$3,
                  iconAsset: _options[i].$2,
                  isSelected: selected == _options[i].$1,
                  onTap: () => onSelected(_options[i].$1),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  const _WorkoutCard({
    required this.label,
    required this.iconAsset,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String iconAsset;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.accentPalette;
    final bgColor = isSelected
        ? palette.buttonFilled
        : context.sectionCardColor;
    final fgColor = isSelected
        ? palette.buttonFilledForeground
        : context.onSectionCardColor;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: AppSpacing.symmetric(context, h: 0.02, v: 0.005),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(
            AppResponsive.radius(context, factor: 2),
          ),
        ),
        child: Column(
          children: [
            Image.asset(
              iconAsset,
              width: AppResponsive.scaleSize(context, 28),
              height: AppResponsive.scaleSize(context, 28),
              color: isSelected ? fgColor : null,
              colorBlendMode: isSelected ? BlendMode.srcIn : null,
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.labelText(context).copyWith(
                color: fgColor,
                fontWeight: FontWeight.w600,
                fontSize: AppResponsive.scaleSize(context, 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
