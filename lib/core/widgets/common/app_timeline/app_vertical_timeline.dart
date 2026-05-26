import 'package:flutter/material.dart';

import 'package:today/core/utils/app_responsive/app_responsive.dart';

/// Vertical connector segment used between [AppTimelineNode] markers.
class AppTimelineConnector extends StatelessWidget {
  const AppTimelineConnector({super.key, required this.color, this.width});

  final Color color;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width ?? AppResponsive.scaleSize(context, 2),
        color: color,
      ),
    );
  }
}

/// Lays out [children] in a column; each child is expected to include its own
/// spine column using [AppTimelineConnector] and [AppTimelineNode].
class AppVerticalTimeline extends StatelessWidget {
  const AppVerticalTimeline({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}
