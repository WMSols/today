import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';

/// Right-side overlay drawer with blur scrim (Gemini-style).
class AppSideDrawer extends StatelessWidget {
  const AppSideDrawer({
    super.key,
    required this.isOpen,
    required this.onClose,
    required this.panel,
    this.widthFactor = 0.82,
    this.animationDuration = const Duration(milliseconds: 260),
  });

  final bool isOpen;
  final VoidCallback onClose;
  final Widget panel;
  final double widthFactor;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    final drawerWidth = AppResponsive.screenWidth(context) * widthFactor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scrim = isDark
        ? AppColors.black.withValues(alpha: 0.45)
        : AppColors.black.withValues(alpha: 0.28);

    return Stack(
      fit: StackFit.expand,
      children: [
        IgnorePointer(
          ignoring: !isOpen,
          child: AnimatedOpacity(
            duration: animationDuration,
            curve: Curves.easeOutCubic,
            opacity: isOpen ? 1 : 0,
            child: GestureDetector(
              onTap: onClose,
              behavior: HitTestBehavior.opaque,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                  child: Container(color: scrim),
                ),
              ),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: animationDuration,
          curve: Curves.easeOutCubic,
          right: isOpen ? 0 : -drawerWidth,
          top: 0,
          bottom: 0,
          width: drawerWidth,
          child: panel,
        ),
      ],
    );
  }
}
