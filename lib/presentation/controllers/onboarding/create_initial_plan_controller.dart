import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/storage/initial_plan_storage.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/features/planner/planner_chat_avatar.dart';
import 'package:today/core/widgets/features/planner/planner_chat_message_list.dart';
import 'package:today/core/widgets/features/planner/planner_message_bubble.dart';
import 'package:today/presentation/controllers/settings/haptics_controller.dart';
import 'package:today/presentation/routes/app_routes.dart';
import 'package:today/presentation/routes/route_arguments.dart';

class CreateInitialPlanController extends GetxController {
  CreateInitialPlanController(this._storage);

  final InitialPlanStorage _storage;

  final goalController = TextEditingController();
  final chatScrollController = ScrollController();
  final RxList<String> userMessages = <String>[].obs;
  final isSubmitting = false.obs;
  final snippetsExpanded = false.obs;
  final hideSnippets = false.obs;
  final keyboardInset = 0.0.obs;

  bool get keyboardVisible => keyboardInset.value > 0;
  bool get showSnippets => !hideSnippets.value && !keyboardVisible;

  List<PlannerChatMessageItem> get chatMessageItems => [
    const PlannerChatMessageItem(
      sender: PlannerMessageSender.ai,
      message: AppTexts.initialPlanChatWelcome,
      avatarKind: PlannerChatAvatarKind.brandLogo,
    ),
    const PlannerChatMessageItem(
      sender: PlannerMessageSender.ai,
      message: AppTexts.initialPlanChatPrompt,
      avatarKind: PlannerChatAvatarKind.brandLogo,
    ),
    ...userMessages.map(
      (msg) => PlannerChatMessageItem(
        sender: PlannerMessageSender.user,
        message: msg,
      ),
    ),
  ];

  static const _bubblePause = Duration(milliseconds: 350);
  static const int _snippetMaxLines = 3;

  void updateKeyboardInset(double inset) {
    if (keyboardInset.value == inset) return;
    keyboardInset.value = inset;
  }

  double snippetSpacing(BuildContext context) =>
      AppResponsive.scaleSize(context, 2);

  List<String> snippetLabelsFor(BuildContext context, double maxWidth) {
    final snippets = AppTexts.initialPlanGoalSnippets;
    if (snippetsExpanded.value) {
      return [...snippets, AppTexts.initialPlanSeeLessSnippets];
    }

    final visible = _collapsedSnippetCount(context, maxWidth);
    if (visible >= snippets.length) return snippets;

    return [...snippets.take(visible), AppTexts.initialPlanSeeMoreSnippets];
  }

  void onSnippetChipTap(String label) {
    if (label == AppTexts.initialPlanSeeMoreSnippets) {
      snippetsExpanded.value = true;
      return;
    }
    if (label == AppTexts.initialPlanSeeLessSnippets) {
      snippetsExpanded.value = false;
      return;
    }
    onSnippetTap(label);
  }

  double _chipHorizontalPadding(BuildContext context) =>
      AppResponsive.screenWidth(context) * 0.025;

  double _snippetChipWidth(BuildContext context, String label) {
    final fontSize = AppResponsive.scaleSize(context, 10);
    final painter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
      ),
      maxLines: 1,
      textDirection: Directionality.of(context),
    )..layout();
    return painter.width + _chipHorizontalPadding(context);
  }

  bool _snippetsFitInMaxLines(
    BuildContext context,
    double maxWidth,
    List<String> labels,
  ) {
    if (labels.isEmpty) return true;
    final gap = snippetSpacing(context);
    var x = 0.0;
    var line = 1;

    for (final label in labels) {
      final chipW = _snippetChipWidth(context, label);
      if (x > 0 && x + gap + chipW > maxWidth) {
        line++;
        x = 0;
      }
      if (line > _snippetMaxLines) return false;
      x = x == 0 ? chipW : x + gap + chipW;
    }
    return true;
  }

  int _collapsedSnippetCount(BuildContext context, double maxWidth) {
    final snippets = AppTexts.initialPlanGoalSnippets;
    if (_snippetsFitInMaxLines(context, maxWidth, snippets)) {
      return snippets.length;
    }

    var low = 0;
    var high = snippets.length - 1;
    var best = 0;

    while (low <= high) {
      final mid = (low + high) ~/ 2;
      final trial = <String>[
        ...snippets.take(mid),
        AppTexts.initialPlanSeeMoreSnippets,
      ];
      if (_snippetsFitInMaxLines(context, maxWidth, trial)) {
        best = mid;
        low = mid + 1;
      } else {
        high = mid - 1;
      }
    }
    return best;
  }

  bool _isValidGoal(String text) => text.trim().length >= 3;

  void onSnippetTap(String goal) {
    unawaited(_selectGoalAndSubmit(goal, fromCustomInput: false));
  }

  void onSendCustomGoal() {
    unawaited(_selectGoalAndSubmit(goalController.text, fromCustomInput: true));
  }

  void scrollChatToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isClosed || !chatScrollController.hasClients) return;
      chatScrollController.animateTo(
        chatScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _selectGoalAndSubmit(
    String raw, {
    required bool fromCustomInput,
  }) async {
    if (isSubmitting.value) return;
    final goal = raw.trim();
    if (!_isValidGoal(goal)) return;

    if (Get.isRegistered<HapticsController>()) {
      Get.find<HapticsController>().impact();
    }

    isSubmitting.value = true;
    snippetsExpanded.value = false;
    if (fromCustomInput) {
      hideSnippets.value = true;
    }
    userMessages.assignAll([goal]);
    goalController.clear();
    scrollChatToBottom();

    await Future<void>.delayed(_bubblePause);
    if (isClosed) return;

    await _storage.savePendingGoalDraft(
      goalText: goal,
      duration: AppTexts.goalDurationDropdownOptions.first,
      resetTime: AppTexts.goalResetFrequencyDropdownOptions.first,
    );
    await Get.toNamed<void>(
      AppRoutes.creatingPlan,
      arguments: {CreatingPlanRouteArgs.flow: CreatingPlanFlow.initial.name},
    );
    isSubmitting.value = false;
  }

  Future<void> skipForNow() async {
    if (Get.isRegistered<HapticsController>()) {
      Get.find<HapticsController>().impact();
    }
    await _storage.skipInitialPlanDraft();
    await _goToAuthSignup();
  }

  Future<void> openExistingAccountLogin() async {
    if (Get.isRegistered<HapticsController>()) {
      Get.find<HapticsController>().impact();
    }
    await _storage.skipInitialPlanDraft();
    await Get.offNamed<void>(
      AppRoutes.auth,
      arguments: {AuthRouteArgs.openLogin: true},
    );
  }

  Future<void> _goToAuthSignup() async {
    await Get.offAllNamed<void>(
      AppRoutes.auth,
      arguments: {AuthRouteArgs.openSignup: true},
    );
  }

  @override
  void onClose() {
    goalController.dispose();
    chatScrollController.dispose();
    super.onClose();
  }
}
