import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:today/core/utils/app_lotties/app_lotties.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/buttons/app_button.dart';

class InitialPlanHeader extends StatelessWidget {
  const InitialPlanHeader({super.key, required this.onSkipTap});

  final VoidCallback onSkipTap;

  @override
  Widget build(BuildContext context) {
    final lottieSize = AppResponsive.scaleSize(context, 200);
    return SizedBox(
      height: lottieSize,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.center,
            child: Lottie.asset(
              AppLotties.createPlan,
              width: lottieSize,
              height: lottieSize,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: AppButton(
              label: AppTexts.initialPlanSkipCta,
              size: AppButtonSize.small,
              onPressed: onSkipTap,
            ),
          ),
        ],
      ),
    );
  }
}
