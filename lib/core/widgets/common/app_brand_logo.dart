import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/theme/app_accent_color.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';

/// Theme-aware app logo for headers (auth, create task, etc.).
///
/// When [showBackground] is true, uses the same accent [fabBackground] circle
/// treatment as the home FAB logo button.
class AppBrandLogo extends StatelessWidget {
  const AppBrandLogo({
    super.key,
    this.heightFactor = 0.12,
    this.alignment = Alignment.center,
    this.showBackground = true,
    this.backgroundColor,
  });

  /// Fraction of screen height used for logo height.
  final double heightFactor;
  final AlignmentGeometry alignment;

  /// Circular accent backdrop matching the home FAB logo button.
  final bool showBackground;

  /// Overrides [AppAccentPalette.fabBackground] when [showBackground] is true.
  final Color? backgroundColor;

  String _logoAsset(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (context.accentColor == AppAccentColor.lavendar) {
      return AppImages.appLogoWhite;
    }
    return isDark ? AppImages.appLogoWhite : AppImages.appLogoBlack;
  }

  @override
  Widget build(BuildContext context) {
    final logoHeight = AppResponsive.screenHeight(context) * heightFactor;
    final logo = Image.asset(
      _logoAsset(context),
      height: logoHeight,
      fit: BoxFit.contain,
    );

    if (!showBackground) {
      return Align(alignment: alignment, child: logo);
    }

    final palette = context.accentPalette;
    final padding = AppSpacing.all(context, factor: 1.5);
    final diameter = logoHeight + padding.vertical * 2;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: alignment,
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor ?? palette.fabBackground,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: isDark ? 0.35 : 0.12),
              blurRadius: AppResponsive.scaleSize(context, 12),
              offset: Offset(0, AppResponsive.scaleSize(context, 4)),
            ),
          ],
        ),
        padding: padding,
        child: Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: Image.asset(_logoAsset(context), height: logoHeight),
          ),
        ),
      ),
    );
  }
}
