import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_lotties/app_lotties.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/widgets/buttons/app_button.dart';
import 'package:today/core/widgets/common/app_count_badge.dart';

class ClaimRewardsScreen extends StatelessWidget {
  const ClaimRewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
          child: Column(
            children: [
              AppSpacing.vertical(context, 0.08),
              Text(
                'COMPLETED!!!',
                style: AppTextStyles.labelText(context).copyWith(
                  color: AppColors.grey,
                  fontWeight: FontWeight.w700,
                  fontSize: AppResponsive.scaleSize(context, 12),
                ),
              ),
              AppSpacing.vertical(context, 0.005),
              Text(
                'Get fit in 30 days',
                style: AppTextStyles.heading(context).copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: AppResponsive.scaleSize(context, 22),
                ),
              ),
              AppSpacing.vertical(context, 0.04),
              SizedBox(
                height: AppResponsive.screenHeight(context) * 0.42,
                child: Lottie.asset(
                  AppLotties.theoScrolling,
                  fit: BoxFit.contain,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppCountBadge(iconPath: AppImages.gem, count: '8'),
                  AppSpacing.horizontal(context, 0.02),
                  AppCountBadge(iconPath: AppImages.streak, count: '8'),
                ],
              ),
              AppSpacing.vertical(context, 0.04),
              SizedBox(
                width: AppResponsive.screenWidth(context) * 0.8,
                child: AppButton(
                  label: 'Claim Rewards',
                  primary: false,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
