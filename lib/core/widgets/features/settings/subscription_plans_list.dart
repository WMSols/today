import 'package:flutter/material.dart';

import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/widgets/features/settings/subscription_plan_card.dart';
import 'package:today/domain/entities/subscription_plan_entity.dart';

class SubscriptionPlansList extends StatelessWidget {
  const SubscriptionPlansList({
    super.key,
    required this.plans,
    required this.selectedIndex,
    required this.onPlanTap,
  });

  final List<SubscriptionPlanEntity> plans;
  final int selectedIndex;
  final ValueChanged<int> onPlanTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(plans.length, (index) {
        final plan = plans[index];
        return Padding(
          padding: EdgeInsets.only(
            bottom: AppResponsive.scaleSize(context, 12),
          ),
          child: SubscriptionPlanCard(
            plan: plan,
            isSelected: selectedIndex == index,
            onTap: () => onPlanTap(index),
          ),
        );
      }),
    );
  }
}
