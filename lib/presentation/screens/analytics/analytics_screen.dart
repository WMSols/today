import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/widgets/features/analytics/analytics_tab_content.dart';
import 'package:today/presentation/controllers/analytics/analytics_controller.dart';

class AnalyticsScreen extends GetView<AnalyticsController> {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnalyticsTabContent();
  }
}
