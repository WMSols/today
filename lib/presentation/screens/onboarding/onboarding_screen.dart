import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_lotties/app_lotties.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/features/onboarding/onboarding_page_actions.dart';
import 'package:today/core/widgets/features/onboarding/onboarding_page_content.dart';
import 'package:today/presentation/controllers/onboarding/onboarding_controller.dart';
import 'package:today/presentation/routes/app_routes.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
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
                      lottiePath: AppLotties.theoDocument,
                      taglineBold: AppTexts.onboardingTaglineBold,
                      taglineRegular: AppTexts.onboardingTaglineRegular,
                    ),
                    OnboardingPageContent(
                      lottiePath: AppLotties.theoWaving,
                      taglineBold: AppTexts.onboardingTaglineBold,
                      taglineRegular: AppTexts.onboardingTaglineRegular,
                    ),
                  ],
                ),
              ),
              AppSpacing.vertical(context, 0.025),
              Obx(
                () => OnboardingPageActions(
                  primaryLabel: controller.currentPage.value == 0
                      ? AppTexts.getStarted
                      : AppTexts.continueWithEmail,
                  onPrimaryTap: controller.currentPage.value == 0
                      ? controller.nextPage
                      : () => Get.offAllNamed(AppRoutes.mainApp),
                  onSocialTap: () => Get.offAllNamed(AppRoutes.planner),
                  showSocialButtons: controller.currentPage.value == 1,
                  legalText: controller.currentPage.value == 0
                      ? AppTexts.onboardingTerms
                      : null,
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
