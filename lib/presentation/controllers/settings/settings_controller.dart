import 'package:get/get.dart';
import 'package:today/presentation/routes/app_routes.dart';

class SettingsController extends GetxController {
  final RxBool hapticsEnabled = true.obs;
  final RxBool notificationsEnabled = false.obs;

  void setHaptics(bool value) {
    hapticsEnabled.value = value;
  }

  void setNotifications(bool value) {
    notificationsEnabled.value = value;
  }

  void openClaimRewards() {
    Get.toNamed(AppRoutes.claimRewards);
  }

  void openSubscription() {
    Get.toNamed(AppRoutes.subscription);
  }
}
