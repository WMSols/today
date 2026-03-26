import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/widgets/common/app_bottom_nav_item.dart';

class AppBottomNavBarScaffold extends StatelessWidget {
  const AppBottomNavBarScaffold({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.children,
    this.backgroundColor = AppColors.black,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<Widget> children;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: IndexedStack(index: currentIndex, children: children),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: AppResponsive.scaleSize(context, 20),
            child: AppBottomNavBar(currentIndex: currentIndex, onTap: onTap),
          ),
        ],
      ),
    );
  }
}

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final barHeight = AppResponsive.screenHeight(context) * 0.07;
    final radius = AppResponsive.radius(context, factor: 5);
    const itemsCount = 3;

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            width: AppResponsive.screenWidth(context) * 0.7,
            height: barHeight,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(radius),
            ),
            padding: EdgeInsets.all(AppResponsive.scaleSize(context, 3)),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final totalWidth = constraints.maxWidth;
                final itemWidth = totalWidth / itemsCount;
                final bubbleInset = AppResponsive.scaleSize(context, 2);
                return Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 380),
                      curve: Curves.easeOutCubic,
                      left: itemWidth * currentIndex + bubbleInset,
                      top: bubbleInset,
                      width: itemWidth - (bubbleInset * 2),
                      height: constraints.maxHeight - (bubbleInset * 2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AppResponsive.scaleSize(context, 26),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.34),
                              borderRadius: BorderRadius.circular(
                                AppResponsive.scaleSize(context, 26),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        AppBottomNavItem(
                          index: 0,
                          currentIndex: currentIndex,
                          label: 'HOME',
                          iconPath: AppImages.home,
                          onTap: onTap,
                        ),
                        AppBottomNavItem(
                          index: 1,
                          currentIndex: currentIndex,
                          label: 'GOALS',
                          iconPath: AppImages.goals,
                          onTap: onTap,
                        ),
                        AppBottomNavItem(
                          index: 2,
                          currentIndex: currentIndex,
                          label: 'SETTINGS',
                          iconPath: AppImages.settings,
                          onTap: onTap,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
