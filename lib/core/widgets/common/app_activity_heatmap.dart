import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_helper/app_helper.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';

/// GitHub-style activity grid: [rowCount] weekdays × [weekColumns] weeks.
class AppActivityHeatmap extends StatelessWidget {
  const AppActivityHeatmap({
    super.key,
    required this.levels,
    required this.weekColumns,
    this.rowCount = 7,
    this.maxLevel = 4,
    this.cellSize,
    this.gap,
  });

  final List<int> levels;
  final int weekColumns;
  final int rowCount;
  final int maxLevel;
  final double? cellSize;
  final double? gap;

  @override
  Widget build(BuildContext context) {
    final cell = cellSize ?? AppResponsive.scaleSize(context, 10);
    final spacing = gap ?? AppResponsive.scaleSize(context, 3);
    final safeColumns = weekColumns.clamp(0, 999);
    final onCard = context.onSectionCardColor;
    final emptyBorderColor = AppHelper.successHeatmapEmptyBorderColor(context);
    final borderWidth = AppResponsive.scaleSize(context, 0.8);
    final strokePad = borderWidth;
    final gridWidth = safeColumns == 0
        ? 0.0
        : safeColumns * cell + (safeColumns - 1) * spacing + strokePad;
    final gridHeight =
        rowCount * cell + math.max(0, rowCount - 1) * spacing + strokePad;

    if (safeColumns <= 0 || gridWidth <= 0) {
      return SizedBox(width: double.infinity, height: gridHeight);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              width: gridWidth,
              height: gridHeight,
              child: CustomPaint(
                size: Size(gridWidth, gridHeight),
                painter: _HeatmapPainter(
                  levels: levels,
                  rowCount: rowCount,
                  weekColumns: safeColumns,
                  maxLevel: maxLevel,
                  cellSize: cell,
                  gap: spacing,
                  emptyBorderColor: emptyBorderColor,
                  emptyBorderWidth: borderWidth,
                  colorForLevel: (level) => AppHelper.successHeatmapColor(
                    context,
                    level: level,
                    maxLevel: maxLevel,
                  ),
                ),
              ),
            ),
          ),
        ),
        AppSpacing.vertical(context, 0.012),
        Align(
          alignment: Alignment.centerRight,
          child: _HeatmapLegend(
            maxLevel: maxLevel,
            emptyBorderColor: emptyBorderColor,
            emptyBorderWidth: borderWidth,
            labelStyle: AppTextStyles.labelText(context).copyWith(
              color: onCard.withValues(alpha: 0.75),
              fontSize: AppResponsive.scaleSize(context, 9),
              fontWeight: FontWeight.w500,
            ),
            cellSize: AppResponsive.scaleSize(context, 10),
            gap: AppResponsive.scaleSize(context, 4),
          ),
        ),
      ],
    );
  }
}

class _HeatmapLegend extends StatelessWidget {
  const _HeatmapLegend({
    required this.maxLevel,
    required this.emptyBorderColor,
    required this.emptyBorderWidth,
    required this.labelStyle,
    required this.cellSize,
    required this.gap,
  });

  final int maxLevel;
  final Color emptyBorderColor;
  final double emptyBorderWidth;
  final TextStyle labelStyle;
  final double cellSize;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(AppTexts.analyticsHeatmapLess, style: labelStyle),
        SizedBox(width: gap),
        _HeatmapLegendSwatch(
          level: 0,
          maxLevel: maxLevel,
          size: cellSize,
          borderColor: emptyBorderColor,
          borderWidth: emptyBorderWidth,
        ),
        SizedBox(width: gap * 0.5),
        for (var level = 1; level <= maxLevel; level++) ...[
          if (level > 1) SizedBox(width: gap * 0.5),
          _HeatmapLegendSwatch(
            level: level,
            maxLevel: maxLevel,
            size: cellSize,
            borderColor: emptyBorderColor,
            borderWidth: emptyBorderWidth,
          ),
        ],
        SizedBox(width: gap),
        Text(AppTexts.analyticsHeatmapMore, style: labelStyle),
      ],
    );
  }
}

class _HeatmapLegendSwatch extends StatelessWidget {
  const _HeatmapLegendSwatch({
    required this.level,
    required this.maxLevel,
    required this.size,
    required this.borderColor,
    required this.borderWidth,
  });

  final int level;
  final int maxLevel;
  final double size;
  final Color borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final fill = AppHelper.successHeatmapColor(
      context,
      level: level,
      maxLevel: maxLevel,
    );
    final radius = BorderRadius.circular(
      AppResponsive.radius(context, factor: 0.5),
    );

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: radius,
        border: level == 0
            ? Border.all(color: borderColor, width: borderWidth)
            : null,
      ),
    );
  }
}

class _HeatmapPainter extends CustomPainter {
  _HeatmapPainter({
    required this.levels,
    required this.rowCount,
    required this.weekColumns,
    required this.maxLevel,
    required this.cellSize,
    required this.gap,
    required this.emptyBorderColor,
    required this.emptyBorderWidth,
    required this.colorForLevel,
  });

  final List<int> levels;
  final int rowCount;
  final int weekColumns;
  final int maxLevel;
  final double cellSize;
  final double gap;
  final Color emptyBorderColor;
  final double emptyBorderWidth;
  final Color Function(int level) colorForLevel;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);

    final radius = Radius.circular(cellSize * 0.22);
    final expected = rowCount * weekColumns;
    final halfStroke = emptyBorderWidth / 2;
    final borderPaint = Paint()
      ..color = emptyBorderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = emptyBorderWidth;

    for (var col = 0; col < weekColumns; col++) {
      for (var row = 0; row < rowCount; row++) {
        final index = row * weekColumns + col;
        final level = index < levels.length && index < expected
            ? levels[index]
            : 0;
        final clamped = level.clamp(0, maxLevel);
        final left = col * (cellSize + gap) + halfStroke;
        final top = row * (cellSize + gap) + halfStroke;
        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(left, top, cellSize, cellSize),
          radius,
        );

        canvas.drawRRect(rect, Paint()..color = colorForLevel(clamped));

        if (clamped == 0) {
          canvas.drawRRect(rect, borderPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _HeatmapPainter oldDelegate) {
    return oldDelegate.levels != levels ||
        oldDelegate.weekColumns != weekColumns ||
        oldDelegate.rowCount != rowCount ||
        oldDelegate.emptyBorderColor != emptyBorderColor;
  }
}
