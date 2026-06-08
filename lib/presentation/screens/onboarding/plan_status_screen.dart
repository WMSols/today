import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_lotties/app_lotties.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/buttons/app_button.dart';
import 'package:today/presentation/controllers/onboarding/plan_status_controller.dart';

class PlanStatusScreen extends GetView<PlanStatusController> {
  const PlanStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceColor,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: AppButton(
                  label: AppTexts.planStatusSkipCta,
                  size: AppButtonSize.small,
                  onPressed: controller.skipToApp,
                ),
              ),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final isReady =
                      controller.status.value == PlanStatusUiState.ready;
                  final title = isReady
                      ? AppTexts.planStatusReadyTitle
                      : AppTexts.planStatusPendingTitle;
                  final subtitle = isReady
                      ? AppTexts.planStatusReadySubtitle
                      : AppTexts.planStatusPendingSubtitle;
                  final lottie = isReady
                      ? AppLotties.planReady
                      : AppLotties.planNotReady;

                  return Column(
                    children: [
                      const Spacer(),
                      Lottie.asset(
                        lottie,
                        width: AppResponsive.scaleSize(context, 280),
                        height: AppResponsive.scaleSize(context, 280),
                        fit: BoxFit.contain,
                      ),
                      AppSpacing.vertical(context, 0.02),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.heading(context).copyWith(
                          color: context.onSurfaceColor,
                          fontWeight: FontWeight.w600,
                          fontSize: AppResponsive.scaleSize(context, 20),
                        ),
                      ),
                      AppSpacing.vertical(context, 0.01),
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyText(context).copyWith(
                          color: context.onSurfaceColor,
                          fontWeight: FontWeight.w500,
                          fontSize: AppResponsive.scaleSize(context, 14),
                          height: 1.3,
                        ),
                      ),
                      if (isReady && controller.goalPreview.value != null) ...[
                        AppSpacing.vertical(context, 0.02),
                        Text(
                          '"${controller.goalPreview.value}"',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.labelText(context).copyWith(
                            color: context.onSurfaceColor,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                      const Spacer(),
                      SizedBox(
                        width: AppResponsive.screenWidth(context) * 0.8,
                        child: AppButton(
                          label: AppTexts.planStatusContinueCta,
                          onPressed: controller.continueToApp,
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
