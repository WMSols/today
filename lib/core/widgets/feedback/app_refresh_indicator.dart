import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:today/core/utils/app_lotties/app_lotties.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';

/// Pull-to-refresh Lottie sized for the refresh header strip.
class AppRefreshIndicator extends StatelessWidget {
  const AppRefreshIndicator({
    super.key,
    this.size = 40,
    this.fit = BoxFit.contain,
  });

  final double size;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final dimension = AppResponsive.scaleSize(context, size);
    return Lottie.asset(
      AppLotties.refresh,
      width: dimension,
      height: dimension,
      fit: fit,
    );
  }
}
