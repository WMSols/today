import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/app/routes/app_pages.dart';
import 'package:today/core/init/app_initializer.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';

class TodayApp extends StatelessWidget {
  const TodayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppTexts.appName,
      initialRoute: AppInitializer.initialRoute,
      getPages: AppPages.pages,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.white,
        primaryColor: AppColors.primary,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),
      ),
    );
  }
}
