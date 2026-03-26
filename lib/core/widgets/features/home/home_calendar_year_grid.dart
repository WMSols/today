import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';

class HomeCalendarYearGrid extends StatelessWidget {
  const HomeCalendarYearGrid({
    super.key,
    required this.activeCount,
    required this.totalDays,
  });

  final int activeCount;
  final int totalDays;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: totalDays,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 25,
        crossAxisSpacing: AppResponsive.scaleSize(context, 8),
        mainAxisSpacing: AppResponsive.scaleSize(context, 8),
      ),
      itemBuilder: (context, index) {
        final isActive = index < activeCount;
        return Container(
          width: AppResponsive.scaleSize(context, 8),
          height: AppResponsive.scaleSize(context, 8),
          color: isActive ? AppColors.lightGrey : AppColors.darkGrey,
        );
      },
      shrinkWrap: true,
    );
  }
}

