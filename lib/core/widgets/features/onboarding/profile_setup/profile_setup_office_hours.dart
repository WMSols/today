import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/common/app_section_card.dart';
import 'package:today/core/widgets/features/onboarding/profile_setup/profile_setup_section_header.dart';
import 'package:today/presentation/controllers/onboarding/profile_setup_controller.dart';

class ProfileSetupOfficeHours extends StatelessWidget {
  const ProfileSetupOfficeHours({
    super.key,
    required this.startLabel,
    required this.endLabel,
    required this.rangeValues,
    required this.onChanged,
  });

  final String startLabel;
  final String endLabel;
  final RangeValues rangeValues;
  final ValueChanged<RangeValues> onChanged;

  @override
  Widget build(BuildContext context) {
    final accent = context.accentPalette;
    final trackColor = context.sectionCardRingTrackColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ProfileSetupSectionHeader(
          title: AppTexts.profileSetupOfficeHoursTitle,
          subtitle: AppTexts.profileSetupOfficeHoursSubtitle,
        ),
        AppSpacing.vertical(context, 0.005),
        AppSectionCard(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _TimePill(label: startLabel)),
                  Container(
                    width: AppResponsive.scaleSize(context, 24),
                    height: 1,
                    color: context.mutedOnSurfaceColor.withValues(alpha: 0.35),
                  ),
                  Expanded(child: _TimePill(label: endLabel)),
                ],
              ),
              AppSpacing.vertical(context, 0.02),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: AppResponsive.scaleSize(context, 4),
                  rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
                  activeTrackColor: accent.onSectionCard,
                  inactiveTrackColor: trackColor,
                  thumbColor: context.surfaceColor,
                  overlayColor: accent.buttonFilled.withValues(alpha: 0.08),
                  overlayShape: SliderComponentShape.noOverlay,
                  rangeThumbShape: const RoundRangeSliderThumbShape(
                    enabledThumbRadius: 6,
                    elevation: 0,
                    pressedElevation: 0,
                  ),
                ),
                child: RangeSlider(
                  values: rangeValues,
                  min: ProfileSetupController.officeHoursMinMinutes.toDouble(),
                  max: ProfileSetupController.officeHoursMaxMinutes.toDouble(),
                  divisions:
                      (ProfileSetupController.officeHoursMaxMinutes -
                          ProfileSetupController.officeHoursMinMinutes) ~/
                      ProfileSetupController.officeHoursStepMinutes,
                  onChanged: onChanged,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      AppTexts.profileSetupOfficeHoursMorning,
                      style: AppTextStyles.labelText(context).copyWith(
                        color: context.onSectionCardColor,
                        fontWeight: FontWeight.w600,
                        fontSize: AppResponsive.scaleSize(context, 9),
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      AppTexts.profileSetupOfficeHoursEvening,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.labelText(context).copyWith(
                        color: context.onSectionCardColor,
                        fontWeight: FontWeight.w600,
                        fontSize: AppResponsive.scaleSize(context, 9),
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      AppTexts.profileSetupOfficeHoursNight,
                      textAlign: TextAlign.end,
                      style: AppTextStyles.labelText(context).copyWith(
                        color: context.onSectionCardColor,
                        fontWeight: FontWeight.w600,
                        fontSize: AppResponsive.scaleSize(context, 9),
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimePill extends StatelessWidget {
  const _TimePill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: AppSpacing.symmetric(context, h: 0.02, v: 0.01),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, factor: 3),
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelText(context).copyWith(
          color: context.onSurfaceColor,
          fontWeight: FontWeight.w600,
          fontSize: AppResponsive.scaleSize(context, 12),
        ),
      ),
    );
  }
}
