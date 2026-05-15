import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:today/core/utils/app_lotties/app_lotties.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({
    super.key,
    this.size = 52,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  /// Square dimension when [width]/[height] are not set.
  final double size;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final w = width ?? AppResponsive.scaleSize(context, size);
    final h = height ?? AppResponsive.scaleSize(context, size);
    return Lottie.asset(AppLotties.loadingWhite, width: w, height: h, fit: fit);
  }
}
