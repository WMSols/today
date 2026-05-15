import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/widgets/common/app_page_scaffold.dart';
import 'package:today/core/widgets/feedback/app_loading_indicator.dart';
import 'package:today/core/widgets/features/settings/subscription_footer.dart';
import 'package:today/core/widgets/features/settings/subscription_header.dart';
import 'package:today/core/widgets/features/settings/subscription_perks_list.dart';
import 'package:today/core/widgets/features/settings/subscription_plans_list.dart';
import 'package:today/presentation/controllers/settings/subscription_controller.dart';

class SubscriptionScreen extends GetView<SubscriptionController> {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      scrollable: true,
      padding: AppPageScaffold.defaultBodyPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SubscriptionHeader(),
          AppSpacing.vertical(context, 0.02),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: AppLoadingIndicator());
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
    );
  }
}
