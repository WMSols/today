import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:today/core/utils/app_formatter/app_formatter.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/common/app_drawer/app_drawer_history_tile.dart';
import 'package:today/core/widgets/features/planner/planner_chat_avatar.dart';
import 'package:today/core/widgets/features/planner/planner_chat_message_list.dart';
import 'package:today/core/widgets/features/planner/planner_message_bubble.dart';
import 'package:today/presentation/controllers/goals/goal_chat_session.dart';
import 'package:today/presentation/controllers/settings/haptics_controller.dart';

class GoalsChatController extends GetxController {
  final TextEditingController messageInputController = TextEditingController();
  final ScrollController chatScrollController = ScrollController();

  final RxBool isDrawerOpen = false.obs;
  final RxList<GoalChatSession> sessions = <GoalChatSession>[].obs;
  final RxnString activeSessionId = RxnString();
  final RxList<GoalChatMessage> currentMessages = <GoalChatMessage>[].obs;
  final RxBool isAiTyping = false.obs;

  static const _stubReplyDelay = Duration(milliseconds: 900);
  int _sessionCounter = 0;
  int _stubReplyIndex = 0;

  String get headerTitle {
    final id = activeSessionId.value;
    if (id == null) return AppTexts.fabAddGoal;

    final session = sessions.firstWhereOrNull((s) => s.id == id);
    final title = session?.title ?? AppTexts.fabAddGoal;
    return title.isEmpty ? AppTexts.fabAddGoal : title;
  }

  List<AppDrawerHistoryEntry> get drawerHistoryEntries {
    final activeId = activeSessionId.value;
    return sessions
        .map(
          (session) => AppDrawerHistoryEntry(
            id: session.id,
            title: session.title,
            timeLabel: formatSessionTime(session.updatedAt),
            isSelected: activeId == session.id,
            onTap: () => selectSession(session.id),
          ),
        )
        .toList();
  }

  List<PlannerChatMessageItem> get chatMessageItems {
    final items = <PlannerChatMessageItem>[];

    for (final message in currentMessages) {
      if (message.isUser) {
        items.add(
          PlannerChatMessageItem(
            sender: PlannerMessageSender.user,
            message: message.text,
          ),
        );
      } else {
        items.add(
          PlannerChatMessageItem(
            sender: PlannerMessageSender.ai,
            message: message.text,
            avatarKind: PlannerChatAvatarKind.brandLogo,
          ),
        );
      }
    }

    if (isAiTyping.value) {
      items.add(
        const PlannerChatMessageItem(
          sender: PlannerMessageSender.ai,
          isTyping: true,
          avatarKind: PlannerChatAvatarKind.brandLogo,
        ),
      );
    }

    return items;
  }

  @override
  void onInit() {
    super.onInit();
    _seedDummySessions();
    _resetToNewChat();
  }

  @override
  void onClose() {
    messageInputController.dispose();
    chatScrollController.dispose();
    super.onClose();
  }

  void openDrawer() {
    _impact();
    isDrawerOpen.value = true;
  }

  void closeDrawer() {
    if (!isDrawerOpen.value) return;
    isDrawerOpen.value = false;
  }

  void toggleDrawer() {
    if (isDrawerOpen.value) {
      closeDrawer();
    } else {
      openDrawer();
    }
  }

  void startNewChat() {
    _impact();
    _resetToNewChat();
    closeDrawer();
  }

  void selectSession(String id) {
    final session = sessions.firstWhereOrNull((s) => s.id == id);
    if (session == null) return;

    _impact();
    activeSessionId.value = id;
    currentMessages.assignAll(session.messages);
    isAiTyping.value = false;
    closeDrawer();
    _scrollToBottom();
  }

  void onSendTap() {
    final text = messageInputController.text.trim();
    if (text.isEmpty || isAiTyping.value) return;

    _impact();
    currentMessages.add(GoalChatMessage(isUser: true, text: text));
    messageInputController.clear();

    final sessionId = activeSessionId.value;
    if (sessionId == null) {
      _sessionCounter++;
      final newId = 'draft_$_sessionCounter';
      final title = _titleFromMessage(text);
      final session = GoalChatSession(
        id: newId,
        title: title,
        preview: text,
        updatedAt: DateTime.now(),
        messages: List<GoalChatMessage>.from(currentMessages),
      );
      sessions.insert(0, session);
      activeSessionId.value = newId;
    } else {
      _updateActiveSession();
    }

    _scrollToBottom();
    _scheduleStubReply();
  }

  String formatSessionTime(DateTime updatedAt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sessionDay = DateTime(updatedAt.year, updatedAt.month, updatedAt.day);
    final dayDiff = today.difference(sessionDay).inDays;

    if (dayDiff == 1) return AppTexts.goalsChatYesterday;
    if (dayDiff > 1 && dayDiff < 7) {
      return AppTexts.goalsChatDaysAgo(dayDiff);
    }
    if (dayDiff >= 7 && dayDiff < 14) return AppTexts.goalsChatLastWeek;
    return AppFormatter.shortDate(updatedAt);
  }

  void _resetToNewChat() {
    activeSessionId.value = null;
    isAiTyping.value = false;
    currentMessages.assignAll([
      const GoalChatMessage(
        isUser: false,
        text: AppTexts.goalsChatWelcomeMessage,
      ),
    ]);
  }

  void _seedDummySessions() {
    final now = DateTime.now();
    sessions.assignAll([
      GoalChatSession(
        id: 'seed_1',
        title: AppTexts.goalsChatHistoryFitnessTitle,
        preview: AppTexts.goalsChatHistoryFitnessPreview,
        updatedAt: now.subtract(const Duration(days: 1)),
        messages: [
          const GoalChatMessage(
            isUser: false,
            text: AppTexts.goalsChatWelcomeMessage,
          ),
          const GoalChatMessage(
            isUser: true,
            text: AppTexts.goalsChatHistoryFitnessUserMessage,
          ),
          const GoalChatMessage(
            isUser: false,
            text: AppTexts.goalsChatStubReplyFitness,
          ),
        ],
      ),
      GoalChatSession(
        id: 'seed_2',
        title: AppTexts.goalsChatHistorySpanishTitle,
        preview: AppTexts.goalsChatHistorySpanishPreview,
        updatedAt: now.subtract(const Duration(days: 3)),
        messages: [
          const GoalChatMessage(
            isUser: false,
            text: AppTexts.goalsChatWelcomeMessage,
          ),
          const GoalChatMessage(
            isUser: true,
            text: AppTexts.goalsChatHistorySpanishUserMessage,
          ),
          const GoalChatMessage(
            isUser: false,
            text: AppTexts.goalsChatStubReplySpanish,
          ),
        ],
      ),
      GoalChatSession(
        id: 'seed_3',
        title: AppTexts.goalsChatHistoryMorningTitle,
        preview: AppTexts.goalsChatHistoryMorningPreview,
        updatedAt: now.subtract(const Duration(days: 8)),
        messages: [
          const GoalChatMessage(
            isUser: false,
            text: AppTexts.goalsChatWelcomeMessage,
          ),
          const GoalChatMessage(
            isUser: true,
            text: AppTexts.goalsChatHistoryMorningUserMessage,
          ),
          const GoalChatMessage(
            isUser: false,
            text: AppTexts.goalsChatStubReplyMorning,
          ),
        ],
      ),
      GoalChatSession(
        id: 'seed_4',
        title: AppTexts.goalsChatHistoryCareerTitle,
        preview: AppTexts.goalsChatHistoryCareerPreview,
        updatedAt: DateTime(now.year, now.month, 2),
        messages: [
          const GoalChatMessage(
            isUser: false,
            text: AppTexts.goalsChatWelcomeMessage,
          ),
          const GoalChatMessage(
            isUser: true,
            text: AppTexts.goalsChatHistoryCareerUserMessage,
          ),
          const GoalChatMessage(
            isUser: false,
            text: AppTexts.goalsChatStubReplyCareer,
          ),
        ],
      ),
    ]);
  }

  void _scheduleStubReply() {
    isAiTyping.value = true;
    Future<void>.delayed(_stubReplyDelay, () {
      if (!isClosed) {
        final reply = _nextStubReply();
        currentMessages.add(GoalChatMessage(isUser: false, text: reply));
        isAiTyping.value = false;
        _updateActiveSession();
        _scrollToBottom();
      }
    });
  }

  String _nextStubReply() {
    const replies = [
      AppTexts.goalsChatStubReplyGeneric1,
      AppTexts.goalsChatStubReplyGeneric2,
      AppTexts.goalsChatStubReplyGeneric3,
    ];
    final reply = replies[_stubReplyIndex % replies.length];
    _stubReplyIndex++;
    return reply;
  }

  String _titleFromMessage(String text) {
    final title = AppFormatter.chatSessionTitle(text);
    return title.isEmpty ? AppTexts.fabAddGoal : title;
  }

  void _updateActiveSession() {
    final id = activeSessionId.value;
    if (id == null) return;

    final index = sessions.indexWhere((s) => s.id == id);
    if (index < 0) return;

    final existing = sessions[index];
    GoalChatMessage? lastUserMessage;
    for (var i = currentMessages.length - 1; i >= 0; i--) {
      if (currentMessages[i].isUser) {
        lastUserMessage = currentMessages[i];
        break;
      }
    }
    sessions[index] = existing.copyWith(
      preview: lastUserMessage?.text ?? existing.preview,
      updatedAt: DateTime.now(),
      messages: List<GoalChatMessage>.from(currentMessages),
    );

    if (index > 0) {
      final updated = sessions.removeAt(index);
      sessions.insert(0, updated);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!chatScrollController.hasClients) return;
      chatScrollController.animateTo(
        chatScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _impact() {
    if (Get.isRegistered<HapticsController>()) {
      Get.find<HapticsController>().impact();
    }
  }
}
