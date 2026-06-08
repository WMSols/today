import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:today/core/utils/app_lotties/app_lotties.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';

/// Scrollable Lottie hero for [CreateInitialPlanScreen].
class InitialPlanHeader extends StatelessWidget {
  const InitialPlanHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final lottieSize = AppResponsive.scaleSize(context, 200);
    return Lottie.asset(
      AppLotties.createPlan,
      width: lottieSize,
      height: lottieSize,
      fit: BoxFit.contain,
    );
  }
}
