import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';

class AppModeTab {
  const AppModeTab({required this.label});

  final String label;
}

/// Segmented mode switch styled like [AppBottomNavBar] (blur bar + sliding bubble).
class AppModeTabs extends StatefulWidget {
  const AppModeTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
    this.widthFactor = 1,
  });

  final List<AppModeTab> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final double widthFactor;

  @override
  State<AppModeTabs> createState() => _AppModeTabsState();
}

class _AppModeTabsState extends State<AppModeTabs>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _previousIndex = widget.selectedIndex;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 820),
    )..value = 1;
  }

  @override
  void didUpdateWidget(covariant AppModeTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _previousIndex = oldWidget.selectedIndex;
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
    if (widget.tabs.isEmpty) return const SizedBox.shrink();

    final barHeight = AppResponsive.screenHeight(context) * 0.052;
    final radius = AppResponsive.radius(context, factor: 4);
    final palette = context.accentPalette;
    final barColor = palette.navBar;
    final bubbleColor = palette.navBubble;
    final labelColor = palette.onNavBar;

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            width: AppResponsive.screenWidth(context) * widget.widthFactor,
            height: barHeight,
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.circular(radius),
            ),
            padding: EdgeInsets.all(AppResponsive.scaleSize(context, 2)),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final itemsCount = widget.tabs.length;
                final totalWidth = constraints.maxWidth;
                final itemWidth = totalWidth / itemsCount;
                final bubbleInset = AppResponsive.scaleSize(context, 1);
                final prevLeft = itemWidth * _previousIndex + bubbleInset;
                final targetLeft =
                    itemWidth * widget.selectedIndex + bubbleInset;
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
                          children: List.generate(itemsCount, (index) {
                            final isSelected = index == widget.selectedIndex;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () => widget.onChanged(index),
                                behavior: HitTestBehavior.opaque,
                                child: Center(
                                  child: AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 220),
                                    curve: Curves.easeOutCubic,
                                    style: AppTextStyles.bodyText(context)
                                        .copyWith(
                                          color: labelColor.withValues(
                                            alpha: isSelected ? 1 : 0.72,
                                          ),
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                          fontSize: AppResponsive.scaleSize(
                                            context,
                                            12,
                                          ),
                                        ),
                                    child: Text(widget.tabs[index].label),
                                  ),
                                ),
                              ),
                            );
                          }),
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
