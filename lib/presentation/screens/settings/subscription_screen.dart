import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_lotties/app_lotties.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/widgets/features/settings/subscription_footer.dart';
import 'package:today/core/widgets/features/settings/subscription_header.dart';
import 'package:today/core/widgets/features/settings/subscription_perks_list.dart';
import 'package:today/core/widgets/features/settings/subscription_plans_list.dart';
import 'package:today/presentation/controllers/settings/subscription_controller.dart';

class SubscriptionScreen extends GetView<SubscriptionController> {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SubscriptionHeader(),
              AppSpacing.vertical(context, 0.02),
              Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: Lottie.asset(
                      AppLotties.loadingWhite,
                      width: AppResponsive.scaleSize(context, 52),
                      height: AppResponsive.scaleSize(context, 52),
                      fit: BoxFit.contain,
                    ),
                  );
                }
                if (controller.plans.isEmpty) {
                  return const SizedBox.shrink();
                }
                final selectedPlan = controller.selectedPlanOrNull;
                if (selectedPlan == null) {
                  return const SizedBox.shrink();
                }
                return Column(
                  children: [
                    SubscriptionPlansList(
                      plans: controller.plans,
                      selectedIndex: controller.selectedPlanIndex.value,
                      onPlanTap: controller.selectPlan,
                    ),
                    AppSpacing.vertical(context, 0.02),
                    SubscriptionPerksList(perks: selectedPlan.perks),
                    AppSpacing.vertical(context, 0.02),
                    SubscriptionFooter(
                      selectedIndex: controller.selectedPlanIndex.value,
                    ),
                  ],
                );
              }),
              AppSpacing.vertical(context, 0.01),
            ],
          ),
        ),
      ),
    );
  }
}
