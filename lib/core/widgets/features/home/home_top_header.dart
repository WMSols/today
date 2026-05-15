import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/widgets/common/app_custom_app_bar.dart';
import 'package:today/presentation/controllers/home/home_controller.dart';

class HomeTopHeader extends GetView<HomeController> {
  const HomeTopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCustomAppBar.homeStatus(
      now: DateTime.now(),
      onTapDate: controller.openHomeCalendar,
    );
  }
}
