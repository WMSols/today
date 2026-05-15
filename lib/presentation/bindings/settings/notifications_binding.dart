import 'package:get/get.dart';

import 'package:today/presentation/controllers/settings/notifications_controller.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationsController>(NotificationsController.new);
  }
}
