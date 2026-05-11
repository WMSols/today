import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:get/get.dart';

import 'package:today/core/widgets/features/home/home_body.dart';
import 'package:today/presentation/routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.black : AppColors.white,
      body: SafeArea(
        child: HomeBody(
          onDateTap: () => Get.toNamed(AppRoutes.homeCalendar),
          onGoalTap: (goalId) =>
              Get.toNamed(AppRoutes.activeGoalDetails, arguments: goalId),
        ),
      ),
    );
  }
}
