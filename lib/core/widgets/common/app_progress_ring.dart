import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';

/// Circular progress ring with optional center label(s). Used on home dashboard
/// cards and the weekly calendar day indicator.
class AppProgressRing extends StatelessWidget {
  const AppProgressRing({
    super.key,
    required this.progress,
    required this.size,
    this.strokeWidth,
    this.trackColor,
    this.progressColor,
    this.center,
    this.centerValue,
    this.centerSubLabel,
    this.centerValueStyle,
    this.centerSubLabelStyle,
    this.animationFactor = 1.0,
    this.style = AppProgressRingStyle.simple,
  });

  final double progress;
  final double size;
  final double? strokeWidth;
  final Color? trackColor;
  final Color? progressColor;
  final Widget? center;
  final String? centerValue;
  final String? centerSubLabel;
  final TextStyle? centerValueStyle;
  final TextStyle? centerSubLabelStyle;
  final double animationFactor;
  final AppProgressRingStyle style;

  @override
  Widget build(BuildContext context) {
    final effectiveStroke =
        strokeWidth ?? AppResponsive.scaleSize(context, size > 56 ? 5 : 4);
    final animatedProgress =
        progress.clamp(0.0, 1.0) * animationFactor.clamp(0.0, 1.0);
    final effectiveTrack = trackColor ?? Colors.transparent;
    final effectiveProgress = progressColor ?? Colors.transparent;

    Widget centerChild = center ?? const SizedBox.shrink();
    if (center == null && (centerValue != null || centerSubLabel != null)) {
      centerChild = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (centerValue != null)
            Text(
              centerValue!,
              style:
                  centerValueStyle ??
                  AppTextStyles.labelText(context).copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: AppResponsive.scaleSize(
                      context,
                      size > 56 ? 22 : 13,
                    ),
                    height: 1,
                  ),
            ),
          if (centerSubLabel != null) ...[
            SizedBox(height: AppResponsive.scaleSize(context, 2)),
            Text(
              centerSubLabel!,
              style:
                  centerSubLabelStyle ??
                  AppTextStyles.labelText(context).copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: AppResponsive.scaleSize(context, 8),
                    letterSpacing: 0.6,
                    height: 1,
                  ),
            ),
          ],
        ],
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (style == AppProgressRingStyle.layered) ...[
            CustomPaint(
              size: Size.square(size),
              painter: AppProgressRingPainter(
                progress: 0,
                trackColor: effectiveTrack.withValues(alpha: 0.22),
                progressColor: Colors.transparent,
                strokeWidth: effectiveStroke * 0.55,
              ),
            ),
            CustomPaint(
              size: Size.square(size * 0.82),
              painter: AppProgressRingPainter(
                progress: 0,
                trackColor: effectiveTrack.withValues(alpha: 0.14),
                progressColor: Colors.transparent,
                strokeWidth: effectiveStroke * 0.45,
              ),
            ),
          ],
          CustomPaint(
            size: Size.square(size),
            painter: AppProgressRingPainter(
              progress: animatedProgress,
              trackColor: effectiveTrack,
              progressColor: effectiveProgress,
              strokeWidth: effectiveStroke,
            ),
          ),
          centerChild,
        ],
      ),
    );
  }
}

enum AppProgressRingStyle { simple, layered }

/// Horizontal progress bar with optional animated fill (matches ring animation).
class AppLinearProgressBar extends StatelessWidget {
  const AppLinearProgressBar({
    super.key,
    required this.progress,
    this.trackColor,
    this.progressColor,
    this.animationFactor = 1.0,
    this.height,
    this.borderRadiusFactor = 5,
  });

  final double progress;
  final Color? trackColor;
  final Color? progressColor;
  final double animationFactor;
  final double? height;
  final double borderRadiusFactor;

  @override
  Widget build(BuildContext context) {
    final animatedProgress =
        progress.clamp(0.0, 1.0) * animationFactor.clamp(0.0, 1.0);
    final barHeight = height ?? AppResponsive.scaleSize(context, 8);
    final radius = BorderRadius.circular(
      AppResponsive.radius(context, factor: borderRadiusFactor),
    );

    return ClipRRect(
      borderRadius: radius,
      child: LinearProgressIndicator(
        value: animatedProgress,
        minHeight: barHeight,
        backgroundColor: trackColor ?? Colors.transparent,
        borderRadius: radius,
        valueColor: AlwaysStoppedAnimation<Color>(
          progressColor ?? Colors.transparent,
        ),
      ),
    );
  }
}

class AppProgressRingPainter extends CustomPainter {
  const AppProgressRingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  final double progress;
  final Color trackColor;
  final Color progressColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - strokeWidth) / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, trackPaint);

    final clamped = progress.clamp(0.0, 1.0);
    if (clamped <= 0 || progressColor.a == 0) return;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: center, radius: radius);
    if (clamped >= 1) {
      canvas.drawCircle(center, radius, progressPaint);
      return;
    }

    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * clamped,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant AppProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
