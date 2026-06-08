import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/buttons/app_button.dart';
import 'package:today/core/widgets/common/app_custom_app_bar.dart';
import 'package:today/core/widgets/features/onboarding/profile_setup/profile_setup_deep_work_selector.dart';
import 'package:today/core/widgets/features/onboarding/profile_setup/profile_setup_header.dart';
import 'package:today/core/widgets/features/onboarding/profile_setup/profile_setup_office_hours.dart';
import 'package:today/core/widgets/features/onboarding/profile_setup/profile_setup_time_card.dart';
import 'package:today/core/widgets/features/onboarding/profile_setup/profile_setup_workout_window.dart';
import 'package:today/presentation/controllers/onboarding/profile_setup_controller.dart';

class ProfileSetupScreen extends GetView<ProfileSetupController> {
  const ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceColor,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
          child: controller.isOnboarding
              ? _OnboardingLayout(controller: controller)
              : _SettingsLayout(controller: controller),
        ),
      ),
    );
  }
}

class _OnboardingLayout extends StatelessWidget {
  const _OnboardingLayout({required this.controller});

  final ProfileSetupController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: AppButton(
            label: AppTexts.profileSetupSkipCta,
            size: AppButtonSize.small,
            onPressed: controller.skipForNow,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: _ProfileSetupFields(controller: controller),
          ),
        ),
        AppSpacing.vertical(context, 0.02),
        Obx(
          () => AppButton(
            label: controller.primaryCtaLabel,
            isLoading: controller.isSubmitting.value,
            onPressed: controller.isSubmitting.value
                ? null
                : controller.onPrimaryAction,
          ),
        ),
      ],
    );
  }
}

class _SettingsLayout extends StatelessWidget {
  const _SettingsLayout({required this.controller});

  final ProfileSetupController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCustomAppBar.titleWithActions(
          title: AppTexts.profileSetupTitle,
          onBack: () => Get.back<void>(),
        ),
        AppSpacing.vertical(context, 0.01),
        Expanded(
          child: SingleChildScrollView(
            child: _ProfileSetupFields(controller: controller),
          ),
        ),
        Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppButton(
                label: AppTexts.profileSetupResetDefaultsCta,
                primary: false,
                onPressed: controller.isSubmitting.value
                    ? null
                    : controller.resetToDefaults,
              ),
              AppSpacing.vertical(context, 0.01),
              AppButton(
                label: controller.primaryCtaLabel,
                isLoading: controller.isSubmitting.value,
                onPressed: controller.isSubmitting.value
                    ? null
                    : controller.onPrimaryAction,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileSetupFields extends StatelessWidget {
  const _ProfileSetupFields({required this.controller});

  final ProfileSetupController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (controller.isOnboarding) ...[
          const ProfileSetupHeader(),
          AppSpacing.vertical(context, 0.02),
        ],
        Obx(
          () => Row(
            children: [
              Expanded(
                child: ProfileSetupTimeCard(
                  label: AppTexts.profileSetupWakeUpLabel,
                  timeLabel: controller.wakeTimeLabel,
                  leadingIcon: Iconsax.sun_1,
                  onTap: controller.openWakeTimePicker,
                ),
              ),
              AppSpacing.horizontal(context, 0.01),
              Expanded(
                child: ProfileSetupTimeCard(
                  label: AppTexts.profileSetupBedtimeLabel,
                  timeLabel: controller.bedTimeLabel,
                  leadingIcon: Iconsax.moon,
                  onTap: controller.openBedTimePicker,
                ),
              ),
            ],
          ),
        ),
        AppSpacing.vertical(context, 0.01),
        Obx(
          () => ProfileSetupOfficeHours(
            startLabel: controller.officeStartLabel,
            endLabel: controller.officeEndLabel,
            rangeValues: controller.officeHoursRange,
            onChanged: controller.onOfficeHoursChanged,
          ),
        ),
        AppSpacing.vertical(context, 0.01),
        Obx(
          () => ProfileSetupWorkoutWindow(
            selected: controller.workoutWindow.value,
            onSelected: controller.selectWorkoutWindow,
          ),
        ),
        AppSpacing.vertical(context, 0.01),
        Obx(
          () => ProfileSetupDeepWorkSelector(
            selected: controller.deepWorkPreference.value,
            onSelected: controller.selectDeepWorkPreference,
          ),
        ),
      ],
    );
  }
}
