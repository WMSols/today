import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/buttons/app_button.dart';

class SubscriptionFooter extends StatelessWidget {
  const SubscriptionFooter({
    super.key,
    required this.selectedIndex,
    this.onTapCta,
  });

  final int selectedIndex;
  final VoidCallback? onTapCta;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: AppButton(
            label: selectedIndex == 0
                ? AppTexts.subscriptionCtaFree
                : selectedIndex == 1
                ? AppTexts.subscriptionCtaPro
                : AppTexts.subscriptionCtaLifetime,
            primary: false,
            onPressed: onTapCta ?? () {},
          ),
        ),
        AppSpacing.vertical(context, 0.01),
        Text(
          AppTexts.subscriptionRestore,
          style: AppTextStyles.labelText(context).copyWith(
            color: AppColors.lightGrey,
            fontWeight: FontWeight.w600,
            fontSize: AppResponsive.scaleSize(context, 12),
          ),
        ),
      ],
    );
  }
}
