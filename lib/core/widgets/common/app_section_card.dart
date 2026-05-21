import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';

/// Grey rounded surface used across home, goals, and settings feature cards.
class AppSectionCard extends StatelessWidget {
  const AppSectionCard({
    super.key,
    required this.child,
    this.onTap,
    this.paddingHorizontal = 0.04,
    this.paddingVertical = 0.04,
    this.radiusFactor = 5,
    this.width,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double paddingHorizontal;
  final double paddingVertical;
  final double radiusFactor;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: width ?? double.infinity,
      padding: AppSpacing.symmetric(
        context,
        h: paddingHorizontal,
        v: paddingVertical,
      ),
      decoration: BoxDecoration(
        color: context.sectionCardColor,
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, factor: radiusFactor),
        ),
      ),
      child: child,
    );

    if (onTap == null) {
      return content;
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: content,
    );
  }
}

/// Icon + uppercase section title row inside [AppSectionCard].
class AppSectionCardHeader extends StatelessWidget {
  const AppSectionCardHeader({
    super.key,
    required this.iconPath,
    required this.title,
    this.iconSizeFactor = 0.8,
    this.titleFontSize = 10,
  });

  final String iconPath;
  final String title;
  final double iconSizeFactor;
  final double titleFontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          iconPath,
          width: AppResponsive.iconSize(context, factor: iconSizeFactor),
          height: AppResponsive.iconSize(context, factor: iconSizeFactor),
        ),
        AppSpacing.horizontal(context, 0.02),
        Text(
          title,
          style: AppTextStyles.labelText(context).copyWith(
            color: context.onSectionCardColor,
            fontWeight: FontWeight.w600,
            fontSize: AppResponsive.scaleSize(context, titleFontSize),
          ),
        ),
      ],
    );
  }
}
