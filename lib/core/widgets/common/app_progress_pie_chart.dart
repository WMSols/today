import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';

/// Two-slice pie chart for goals vs tasks with in-slice fraction labels.
class AppProgressPieChart extends StatelessWidget {
  const AppProgressPieChart({
    super.key,
    required this.size,
    required this.goalsCount,
    required this.goalsTotal,
    required this.tasksCount,
    required this.tasksTotal,
    this.animationFactor = 1,
    this.gapDegrees = 2.5,
    this.centerHoleRadiusFactor = 0.06,
    this.goalsColor = AppColors.information,
    this.tasksColor = AppColors.warning,
  });

  final double size;
  final int goalsCount;
  final int goalsTotal;
  final int tasksCount;
  final int tasksTotal;
  final double animationFactor;
  final double gapDegrees;
  final double centerHoleRadiusFactor;
  final Color goalsColor;
  final Color tasksColor;

  String get _goalsLabel {
    final total = goalsTotal.clamp(1, 999);
    return '${goalsCount.clamp(0, total)}/$total ${AppTexts.goals.toLowerCase()}';
  }

  String get _tasksLabel {
    final total = tasksTotal.clamp(1, 999);
    return '${tasksCount.clamp(0, total)}/$total tasks';
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = AppTextStyles.labelText(context).copyWith(
      color: AppColors.white,
      fontWeight: FontWeight.w700,
      fontSize: AppResponsive.scaleSize(context, 9),
      height: 1.15,
    );

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _AppProgressPieChartPainter(
          goalsCount: goalsCount,
          tasksCount: tasksCount,
          goalsColor: goalsColor,
          tasksColor: tasksColor,
          goalsLabel: _goalsLabel,
          tasksLabel: _tasksLabel,
          labelStyle: labelStyle,
          animationFactor: animationFactor.clamp(0.0, 1.0),
          gapRadians: gapDegrees * (math.pi / 180),
          centerHoleRadiusFactor: centerHoleRadiusFactor,
        ),
      ),
    );
  }
}

class _SliceSpec {
  const _SliceSpec({
    required this.sweep,
    required this.color,
    required this.label,
  });

  final double sweep;
  final Color color;
  final String label;
}

class _AppProgressPieChartPainter extends CustomPainter {
  _AppProgressPieChartPainter({
    required this.goalsCount,
    required this.tasksCount,
    required this.goalsColor,
    required this.tasksColor,
    required this.goalsLabel,
    required this.tasksLabel,
    required this.labelStyle,
    required this.animationFactor,
    required this.gapRadians,
    required this.centerHoleRadiusFactor,
  });

  final int goalsCount;
  final int tasksCount;
  final Color goalsColor;
  final Color tasksColor;
  final String goalsLabel;
  final String tasksLabel;
  final TextStyle labelStyle;
  final double animationFactor;
  final double gapRadians;
  final double centerHoleRadiusFactor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    const startAngle = -math.pi / 2;

    final slices = _buildSlices();
    if (slices.isEmpty) {
      final trackPaint = Paint()
        ..color = goalsColor.withValues(alpha: 0.2)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, radius, trackPaint);
      return;
    }

    final totalGap = gapRadians * slices.length;
    final availableSweep = (math.pi * 2 - totalGap) * animationFactor;
    var cursor = startAngle + gapRadians / 2;

    for (final slice in slices) {
      final sweep = availableSweep * slice.sweep;
      if (sweep <= 0.001) continue;

      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(rect, cursor, sweep, false)
        ..close();

      canvas.drawPath(path, Paint()..color = slice.color);

      final midAngle = cursor + sweep / 2;
      final labelRadius = radius * 0.58;
      final labelCenter = Offset(
        center.dx + math.cos(midAngle) * labelRadius,
        center.dy + math.sin(midAngle) * labelRadius,
      );
      _paintSliceLabel(canvas, slice.label, labelCenter, size);

      cursor += sweep + gapRadians;
    }

    final holeRadius = radius * centerHoleRadiusFactor.clamp(0.0, 0.2);
    if (holeRadius > 0) {
      canvas.drawCircle(center, holeRadius, Paint()..color = AppColors.white);
    }
  }

  List<_SliceSpec> _buildSlices() {
    final goals = goalsCount.clamp(0, 9999);
    final tasks = tasksCount.clamp(0, 9999);
    final sum = goals + tasks;

    if (sum == 0) {
      return [
        _SliceSpec(
          sweep: 0.5,
          color: goalsColor.withValues(alpha: 0.35),
          label: goalsLabel,
        ),
        _SliceSpec(
          sweep: 0.5,
          color: tasksColor.withValues(alpha: 0.35),
          label: tasksLabel,
        ),
      ];
    }

    return [
      _SliceSpec(sweep: goals / sum, color: goalsColor, label: goalsLabel),
      _SliceSpec(sweep: tasks / sum, color: tasksColor, label: tasksLabel),
    ];
  }

  void _paintSliceLabel(
    Canvas canvas,
    String text,
    Offset center,
    Size chartSize,
  ) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: labelStyle),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: chartSize.width * 0.42);

    painter.paint(
      canvas,
      center - Offset(painter.width / 2, painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _AppProgressPieChartPainter oldDelegate) {
    return oldDelegate.goalsCount != goalsCount ||
        oldDelegate.tasksCount != tasksCount ||
        oldDelegate.goalsColor != goalsColor ||
        oldDelegate.tasksColor != tasksColor ||
        oldDelegate.goalsLabel != goalsLabel ||
        oldDelegate.tasksLabel != tasksLabel ||
        oldDelegate.animationFactor != animationFactor ||
        oldDelegate.labelStyle != labelStyle;
  }
}
