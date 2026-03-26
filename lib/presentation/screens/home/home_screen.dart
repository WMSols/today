import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/widgets/features/home/home_body.dart';
import 'package:today/presentation/routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: HomeBody(onDateTap: () => Get.toNamed(AppRoutes.homeCalendar)),
      ),
    );
  }
}
