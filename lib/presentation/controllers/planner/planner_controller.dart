import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/features/planner/planner_chat_message_list.dart';
import 'package:today/core/widgets/features/planner/planner_message_bubble.dart';
import 'package:today/presentation/controllers/settings/haptics_controller.dart';
import 'package:today/presentation/routes/app_routes.dart';
import 'package:today/presentation/routes/route_arguments.dart';

class PlannerController extends GetxController {
  final TextEditingController messageInputController = TextEditingController();

  final RxList<String> userMessages = <String>[].obs;
  final RxBool showConfirmButton = false.obs;

  List<PlannerChatMessageItem> get chatMessageItems => [
    const PlannerChatMessageItem(
      avatarPath: AppImages.aiAvatar,
      sender: PlannerMessageSender.ai,
      message: AppTexts.plannerWelcomeMessage,
    ),
    const PlannerChatMessageItem(
      avatarPath: AppImages.aiAvatar,
      sender: PlannerMessageSender.ai,
      message: AppTexts.plannerNamePrompt,
    ),
    if (userMessages.isEmpty)
      const PlannerChatMessageItem(
        avatarPath: AppImages.userProfile,
        sender: PlannerMessageSender.user,
        isTyping: true,
      )
    else
      ...userMessages.map(
        (msg) => PlannerChatMessageItem(
          avatarPath: AppImages.userProfile,
          sender: PlannerMessageSender.user,
          message: msg,
        ),
      ),
  ];

  @override
  void onClose() {
    messageInputController.dispose();
    super.onClose();
  }

  void onConfirmTap() {
    if (Get.isRegistered<HapticsController>()) {
      Get.find<HapticsController>().impact();
    }
    Get.toNamed<void>(
      AppRoutes.creatingPlan,
      arguments: {CreatingPlanRouteArgs.flow: CreatingPlanFlow.planner.name},
    );
  }

  void onSendTap() {
    final text = messageInputController.text.trim();
    if (text.isEmpty) return;

    if (Get.isRegistered<HapticsController>()) {
      Get.find<HapticsController>().impact();
    }
    userMessages.add(text);
    showConfirmButton.value = true;

    messageInputController.clear();
    // Backend integration later.
  }
}
