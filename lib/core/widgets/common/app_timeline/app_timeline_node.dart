import 'package:flutter/material.dart';

import 'package:today/core/utils/app_responsive/app_responsive.dart';

/// Circular timeline marker with a centered [child] (typically an icon).
class AppTimelineNode extends StatelessWidget {
  const AppTimelineNode({
    super.key,
    required this.color,
    required this.child,
    this.size,
    this.iconColor,
  });

  final Color color;
  final Color? iconColor;
  final Widget child;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final diameter = size ?? AppResponsive.scaleSize(context, 36);

    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: IconTheme(
        data: IconThemeData(
          color: iconColor,
          size: AppResponsive.scaleSize(context, 18),
        ),
        child: child,
      ),
    );
  }
}
