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
    this.paddingVertical = 0.01,
    this.radiusFactor = 2,
    this.width,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 0,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double paddingHorizontal;
  final double paddingVertical;
  final double radiusFactor;
  final double? width;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(
      AppResponsive.radius(context, factor: radiusFactor),
    );
    final content = Container(
      width: width ?? double.infinity,
      clipBehavior: Clip.antiAlias,
      padding: AppSpacing.symmetric(
        context,
        h: paddingHorizontal,
        v: paddingVertical,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? context.sectionCardColor,
        borderRadius: radius,
        border: borderWidth > 0 && borderColor != null
            ? Border.all(color: borderColor!, width: borderWidth)
            : null,
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
    required this.icon,
    required this.title,
    this.iconColor,
    this.iconSizeFactor = 0.8,
    this.titleFontSize = 10,
  });

  final IconData icon;
  final String title;
  final double iconSizeFactor;
  final Color? iconColor;
  final double titleFontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: AppResponsive.iconSize(context, factor: iconSizeFactor),
          color: iconColor ?? context.onSectionCardColor,
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
