import 'package:flutter/material.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';

class SocialActionButton extends StatelessWidget {
  const SocialActionButton({
    super.key,
    required this.image,
    required this.onTap,
  });

  final String image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.lightGrey,
      borderRadius: BorderRadius.circular(
        AppResponsive.radius(context, factor: 5),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, factor: 5),
        ),
        child: Padding(
          padding: AppSpacing.symmetric(context, h: 0.04, v: 0.015),
          child: Image.asset(
            image,
            width: AppResponsive.iconSize(context),
            height: AppResponsive.iconSize(context),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
