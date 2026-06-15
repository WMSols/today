import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/widgets/common/app_bottom_nav_item.dart';

class AppBottomNavBarScaffold extends StatelessWidget {
  const AppBottomNavBarScaffold({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.children,
    this.backgroundColor,
    this.overlay,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<Widget> children;
  final Color? backgroundColor;

  /// Full-screen layers above tab content (e.g. home FAB blur menu).
  final Widget? overlay;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.black : AppColors.white;
    return Scaffold(
      backgroundColor: backgroundColor ?? surface,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: IndexedStack(index: currentIndex, children: children),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: AppResponsive.scaleSize(context, 6),
            child: AppBottomNavBar(currentIndex: currentIndex, onTap: onTap),
          ),
          ?overlay,
        ],
      ),
    );
  }
}

class AppBottomNavBar extends StatefulWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  State<AppBottomNavBar> createState() => _AppBottomNavBarState();
}

class _AppBottomNavBarState extends State<AppBottomNavBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _previousIndex = widget.currentIndex;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 820),
    )..value = 1;
  }

  @override
  void didUpdateWidget(covariant AppBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _previousIndex = oldWidget.currentIndex;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final barHeight = AppResponsive.screenHeight(context) * 0.055;
    final radius = AppResponsive.radius(context, factor: 4);
    const itemsCount = 4;
    final palette = context.accentPalette;
    final barColor = palette.navBar;
    final bubbleColor = palette.navBubble;

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            width: AppResponsive.screenWidth(context) * 0.88,
            height: barHeight,
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.circular(radius),
            ),
            padding: EdgeInsets.all(AppResponsive.scaleSize(context, 2)),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final totalWidth = constraints.maxWidth;
                final itemWidth = totalWidth / itemsCount;
                final bubbleInset = AppResponsive.scaleSize(context, 1);
                final prevLeft = itemWidth * _previousIndex + bubbleInset;
                final targetLeft =
                    itemWidth * widget.currentIndex + bubbleInset;
                final baseWidth = itemWidth - (bubbleInset * 2);

                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final t = Curves.elasticOut.transform(_controller.value);
                    final left = lerpDouble(prevLeft, targetLeft, t)!;
                    final stretch =
                        AppResponsive.scaleSize(context, 5) *
                        (1 - ((t * 2) - 1).abs());
                    final width = baseWidth + stretch;
                    final correctedLeft = left - (stretch / 2);

                    return Stack(
                      children: [
                        Positioned(
                          left: correctedLeft,
                          top: bubbleInset,
                          width: width,
                          height: constraints.maxHeight - (bubbleInset * 2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              AppResponsive.scaleSize(context, 20),
                            ),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: bubbleColor,
                                  borderRadius: BorderRadius.circular(
                                    AppResponsive.scaleSize(context, 20),
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
                              currentIndex: widget.currentIndex,
                              label: AppTexts.navHome,
                              icon: Iconsax.home_trend_up,
                              onTap: widget.onTap,
                            ),
                            AppBottomNavItem(
                              index: 1,
                              currentIndex: widget.currentIndex,
                              label: AppTexts.navGoals,
                              icon: Iconsax.flag,
                              onTap: widget.onTap,
                            ),
                            AppBottomNavItem(
                              index: 2,
                              currentIndex: widget.currentIndex,
                              label: AppTexts.navAnalytics,
                              icon: Iconsax.diagram,
                              onTap: widget.onTap,
                            ),
                            AppBottomNavItem(
                              index: 3,
                              currentIndex: widget.currentIndex,
                              label: AppTexts.navSettings,
                              icon: Iconsax.setting_4,
                              onTap: widget.onTap,
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
