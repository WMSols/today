import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';

class SubscriptionPerksList extends StatelessWidget {
  const SubscriptionPerksList({super.key, required this.perks});

  final List<String> perks;

  InlineSpan _buildPerkSpan(BuildContext context, String perk) {
    final words = perk.trim().split(RegExp(r'\s+'));
    if (words.length < 4) {
      return TextSpan(
        text: perk,
        style: AppTextStyles.heading(context).copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
          fontSize: AppResponsive.scaleSize(context, 16),
          height: 1.2,
        ),
      );
    }

    final greyWordCount = words.length >= 7 ? 3 : 2;
    final splitIndex = words.length - greyWordCount;
    final leading = words.take(splitIndex).join(' ');
    final trailing = words.skip(splitIndex).join(' ');

    return TextSpan(
      children: [
        TextSpan(
          text: '$leading ',
          style: AppTextStyles.heading(context).copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: AppResponsive.scaleSize(context, 16),
            height: 1.2,
          ),
        ),
        TextSpan(
          text: trailing,
          style: AppTextStyles.heading(context).copyWith(
            color: AppColors.grey.withValues(alpha: 0.9),
            fontWeight: FontWeight.w600,
            fontSize: AppResponsive.scaleSize(context, 16),
            height: 1.2,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: perks.map((perk) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: AppResponsive.scaleSize(context, 12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.proPlanTick,
                width: AppResponsive.scaleSize(context, 16),
                height: AppResponsive.scaleSize(context, 16),
              ),
              AppSpacing.horizontal(context, 0.01),
              Expanded(child: RichText(text: _buildPerkSpan(context, perk))),
            ],
          ),
        );
      }).toList(),
    );
  }
}
