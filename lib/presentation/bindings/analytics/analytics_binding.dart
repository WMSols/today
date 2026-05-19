import 'package:get/get.dart';

import 'package:today/domain/usecases/get_weekly_calendar_usecase.dart';
import 'package:today/presentation/controllers/analytics/analytics_controller.dart';

class AnalyticsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AnalyticsController>(
      () => AnalyticsController(Get.find<GetWeeklyCalendarUseCase>()),
    );
  }
}
