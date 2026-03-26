import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';

class PlannerAvatar extends StatelessWidget {
  const PlannerAvatar({super.key, required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final size = AppResponsive.scaleSize(context, 28);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.black,
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
    );
  }
}

