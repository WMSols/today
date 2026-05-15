import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_lotties/app_lotties.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/features/onboarding/onboarding_page_actions.dart';
import 'package:today/core/widgets/features/onboarding/onboarding_page_content.dart';
import 'package:today/presentation/controllers/onboarding/onboarding_controller.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceColor,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: controller.pageController,
                  onPageChanged: controller.setPage,
                  children: const [
                    OnboardingPageContent(
                      lottiePath: AppLotties.onboarding1,
                      taglineBold: AppTexts.onboardingTaglineBold1,
                      taglineRegular: AppTexts.onboardingTaglineRegular1,
                    ),
                    OnboardingPageContent(
                      lottiePath: AppLotties.onboarding2,
                      taglineBold: AppTexts.onboardingTaglineBold2,
                      taglineRegular: AppTexts.onboardingTaglineRegular2,
                    ),
                  ],
                ),
              ),
              AppSpacing.vertical(context, 0.025),
              Obx(
                () => OnboardingPageActions(
                  primaryLabel: controller.primaryActionLabel,
                  onPrimaryTap: controller.onPrimaryAction,
                  onSocialTap: controller.goToPlanner,
                  showSocialButtons: controller.showSocialButtons,
                  legalText: controller.legalText,
                ),
              ),
              AppSpacing.vertical(context, 0.01),
            ],
          ),
        ),
      ),
    );
  }
}
