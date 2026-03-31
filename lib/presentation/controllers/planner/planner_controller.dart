import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:today/presentation/routes/app_routes.dart';

class PlannerController extends GetxController {
  final TextEditingController messageInputController = TextEditingController();

  final RxList<String> userMessages = <String>[].obs;
  final RxBool showConfirmButton = false.obs;

  @override
  void onClose() {
    messageInputController.dispose();
    super.onClose();
  }

  void onConfirmTap() {
    Get.toNamed(AppRoutes.creatingPlan);
  }

  void onSendTap() {
    final text = messageInputController.text.trim();
    if (text.isEmpty) return;

    userMessages.add(text);
    showConfirmButton.value = true;

    messageInputController.clear();
    // Backend integration later.
  }
}
