import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';

class AppShimmer extends StatefulWidget {
  const AppShimmer({super.key, this.width, this.height, this.borderRadius});

  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuint));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius =
        widget.borderRadius ??
        BorderRadius.circular(AppResponsive.radius(context));
    final height = widget.height ?? AppResponsive.shimmerDefaultHeight(context);
    final width = widget.width ?? double.infinity;

    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.3),
                borderRadius: borderRadius,
              ),
            ),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final w = constraints.maxWidth;
                    final h = constraints.maxHeight;
                    final sweep = w * 0.5;
                    final dx = -sweep + 2 * sweep * _animation.value;
                    return Transform.translate(
                      offset: Offset(dx, 0),
                      child: SizedBox(
                        width: sweep * 2,
                        height: h,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.transparent,
                                AppColors.white.withValues(alpha: 0.06),
                                AppColors.white.withValues(alpha: 0.28),
                                AppColors.white.withValues(alpha: 0.45),
                                AppColors.white.withValues(alpha: 0.28),
                                AppColors.white.withValues(alpha: 0.06),
                                Colors.transparent,
                              ],
                              stops: const [
                                0.0,
                                0.32,
                                0.42,
                                0.5,
                                0.58,
                                0.68,
                                1.0,
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AppShimmerList extends StatelessWidget {
  const AppShimmerList({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final screenWidth = AppResponsive.screenWidth(context);
    final bannerHeight = AppResponsive.shimmerBannerHeight(context);
    final lineHeight = AppResponsive.shimmerTextLineHeight(context);
    final avatarSize = AppResponsive.shimmerAvatarSize(context);
    final blockSpacing = AppResponsive.shimmerContentBlockSpacing(context);
    final elementSpacing = AppResponsive.shimmerElementSpacing(context);
    final radius = AppResponsive.radius(context);
    final cornerRadius = radius * 1.5;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Large banner placeholder (90–95% width, rounded corners)
          Center(
            child: SizedBox(
              width: screenWidth * 0.92,
              height: bannerHeight,
              child: AppShimmer(
                borderRadius: BorderRadius.circular(cornerRadius),
                width: screenWidth * 0.92,
                height: bannerHeight,
              ),
            ),
          ),
          SizedBox(height: blockSpacing),
          // 2. First content block: two stacked text lines (70–80% top, 40–50% bottom)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppShimmer(
                width: screenWidth * 0.75,
                height: lineHeight,
                borderRadius: BorderRadius.circular(lineHeight / 2),
              ),
              SizedBox(height: elementSpacing),
              AppShimmer(
                width: screenWidth * 0.45,
                height: lineHeight,
                borderRadius: BorderRadius.circular(lineHeight / 2),
              ),
            ],
          ),
          SizedBox(height: blockSpacing),
          // 3–N. List blocks: alternating circle and rounded square + two text lines
          ...List.generate((itemCount - 2).clamp(0, 6), (index) {
            final useCircle = index.isEven;
            return Padding(
              padding: EdgeInsets.only(bottom: blockSpacing),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left: circle or rounded square
                  AppShimmer(
                    width: avatarSize,
                    height: avatarSize,
                    borderRadius: useCircle
                        ? BorderRadius.circular(avatarSize / 2)
                        : BorderRadius.circular(cornerRadius),
                  ),
                  SizedBox(width: elementSpacing * 2),
                  // Right: two text lines
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppShimmer(
                          width: screenWidth * 0.5,
                          height: lineHeight,
                          borderRadius: BorderRadius.circular(lineHeight / 2),
                        ),
                        SizedBox(height: elementSpacing),
                        AppShimmer(
                          width: screenWidth * 0.35,
                          height: lineHeight,
                          borderRadius: BorderRadius.circular(lineHeight / 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
