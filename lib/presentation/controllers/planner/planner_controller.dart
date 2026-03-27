import 'package:get/get.dart';
import 'package:today/presentation/routes/app_routes.dart';

class PlannerController extends GetxController {
  void onConfirmTap() {
    Get.toNamed(AppRoutes.creatingPlan);
  }
}
