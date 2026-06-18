import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/auth/auth_error_messages.dart';
import 'package:today/core/storage/calendar_chat_history_storage.dart';
import 'package:today/core/storage/today_schedule_store.dart';
import 'package:today/core/utils/app_formatter/app_formatter.dart';
import 'package:today/core/utils/app_helper/app_helper.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/common/app_drawer/app_drawer_history_tile.dart';
import 'package:today/core/widgets/features/planner/planner_chat_avatar.dart';
import 'package:today/core/widgets/features/planner/planner_chat_message_list.dart';
import 'package:today/core/widgets/features/planner/planner_message_bubble.dart';
import 'package:today/core/widgets/feedback/app_toast.dart';
import 'package:today/domain/entities/schedule_display_entity.dart';
import 'package:today/domain/usecases/send_calendar_chat_message_usecase.dart';
import 'package:today/presentation/controllers/animation/app_animation_controller.dart';
import 'package:today/presentation/controllers/planner/calendar_chat_session.dart';
import 'package:today/presentation/controllers/settings/haptics_controller.dart';
import 'package:today/presentation/routes/app_routes.dart';

abstract class CalendarChatController extends GetxController {
  CalendarChatHistoryStorage get _historyStorage =>
      Get.find<CalendarChatHistoryStorage>();

  SendCalendarChatMessageUseCase get sendCalendarChatMessageUseCase;

  String get chatWelcomeMessage;
  String get chatPromptMessage;
  String get chatInputHint;
  String get chatHeaderTitle;
  bool get showInitialTypingIndicator => false;

  /// When false, chat is one persistent thread (create task) instead of sessions.
  bool get usesMultiSessionHistory => true;

  final TextEditingController messageInputController = TextEditingController();
  final ScrollController chatScrollController = ScrollController();

  final RxList<CalendarChatMessage> chatMessages = <CalendarChatMessage>[].obs;
  final RxList<CalendarChatSession> chatSessions = <CalendarChatSession>[].obs;
  final RxBool isAiTyping = false.obs;
  final RxBool isChatSending = false.obs;
  final RxBool isDrawerOpen = false.obs;
  final RxnString activeSessionId = RxnString();
  final Rxn<ScheduleDisplayEntity> latestScheduleDisplay =
      Rxn<ScheduleDisplayEntity>();
  final RxnInt scheduleMessageAnchor = RxnInt();
  final keyboardInset = 0.0.obs;

  int _sessionCounter = 0;
  Worker? _scrollWorker;

  String get headerTitle {
    if (!usesMultiSessionHistory) return chatHeaderTitle;

    final id = activeSessionId.value;
    if (id == null) return chatHeaderTitle;

    final session = chatSessions.firstWhereOrNull((s) => s.id == id);
    final title = session?.title ?? chatHeaderTitle;
    return title.isEmpty ? chatHeaderTitle : title;
  }

  List<AppDrawerHistoryEntry> get drawerHistoryEntries {
    final activeId = activeSessionId.value;
    return chatSessions
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

  List<PlannerChatMessageItem> get chatMessageItems =>
      _buildMessageItems(chatMessages);

  List<PlannerChatMessageItem> get chatMessageItemsBeforeSchedule {
    final anchor = scheduleMessageAnchor.value;
    if (anchor == null || anchor <= 0) {
      return _buildMessageItems(chatMessages);
    }
    final end = anchor.clamp(0, chatMessages.length);
    return _buildMessageItems(chatMessages.sublist(0, end));
  }

  List<PlannerChatMessageItem> get chatMessageItemsAfterSchedule {
    final anchor = scheduleMessageAnchor.value;
    if (anchor == null) return const [];
    final end = anchor.clamp(0, chatMessages.length);
    if (end >= chatMessages.length) return const [];
    return _buildMessageItems(chatMessages.sublist(end));
  }

  bool get hasPinnedSchedule {
    final display = latestScheduleDisplay.value;
    if (display == null) return false;
    return AppHelper.scheduleDaysWithSlots(display).isNotEmpty;
  }

  ScheduleDisplayEntity? get pinnedScheduleDisplay {
    final display = latestScheduleDisplay.value;
    if (display == null) return null;
    final days = AppHelper.scheduleDaysWithSlots(display);
    if (days.isEmpty) return null;
    return ScheduleDisplayEntity(schema: display.schema, days: days);
  }

  /// Persists an updated schedule display back to chat history / active session.
  Future<void> commitScheduleDisplay(ScheduleDisplayEntity display) async {
    latestScheduleDisplay.value = display;
    if (Get.isRegistered<TodayScheduleStore>()) {
      await Get.find<TodayScheduleStore>().setPinnedSchedule(display);
    }
    if (usesMultiSessionHistory) {
      _updateActiveSession();
      await _persistChatHistory();
      return;
    }
    await _persistChatHistory();
  }

  /// Shown under suggested schedule until the user sends another message.
  bool get showViewFullAgendaButton =>
      hasPinnedSchedule &&
      !isAiTyping.value &&
      !isChatSending.value &&
      chatMessageItemsAfterSchedule.isEmpty;

  void openFullAgenda() {
    _impact();
    AppAnimationController.pushNamed<void>(AppRoutes.agenda);
  }

  @override
  void onInit() {
    super.onInit();
    _loadChatHistory();
    _scrollWorker = ever(
      chatMessages,
      (_) => scrollChatToBottom(animated: false),
    );
    ever(isAiTyping, (_) => scrollChatToBottom(animated: false));
    ever(scheduleMessageAnchor, (_) => scrollChatToBottom(animated: false));
    ever(latestScheduleDisplay, (_) => scrollChatToBottom(animated: false));
  }

  @override
  void onClose() {
    _scrollWorker?.dispose();
    messageInputController.dispose();
    chatScrollController.dispose();
    super.onClose();
  }

  void updateKeyboardInset(double inset) {
    if (keyboardInset.value == inset) return;
    keyboardInset.value = inset;
    if (inset > 0) scrollChatToBottom();
  }

  void openDrawer() {
    _impact();
    isDrawerOpen.value = true;
  }

  void closeDrawer() {
    if (!isDrawerOpen.value) return;
    isDrawerOpen.value = false;
  }

  void startNewChat() {
    _impact();
    _resetToNewChat();
    closeDrawer();
  }

  void selectSession(String id) {
    final session = chatSessions.firstWhereOrNull((s) => s.id == id);
    if (session == null) return;

    _impact();
    isAiTyping.value = false;
    closeDrawer();
    _restoreSession(session);
  }

  void _restoreSession(CalendarChatSession session) {
    activeSessionId.value = session.id;
    chatMessages.assignAll(session.messages);
    latestScheduleDisplay.value = session.scheduleDisplay;
    scheduleMessageAnchor.value = session.scheduleMessageAnchor;
    _syncStorePinnedSchedule(session.scheduleDisplay);
    scrollChatToBottom(animated: false);
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

  Future<void> onSendChatMessage() async {
    final text = messageInputController.text.trim();
    if (text.isEmpty || isChatSending.value) return;

    _impact();
    messageInputController.clear();
    await _sendCalendarChatMessage(AppFormatter.capitalizeFirstLetter(text));
  }

  void scrollChatToBottom({bool animated = true}) {
    _scrollToBottomAttempt(animated: animated, retriesLeft: 24);
  }

  void _scrollToBottomAttempt({
    required bool animated,
    required int retriesLeft,
    double? previousMaxExtent,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isClosed) return;

      if (!chatScrollController.hasClients) {
        if (retriesLeft > 0) {
          _scrollToBottomAttempt(
            animated: animated,
            retriesLeft: retriesLeft - 1,
            previousMaxExtent: previousMaxExtent,
          );
        }
        return;
      }

      final position = chatScrollController.position;
      final maxExtent = position.maxScrollExtent;
      const tolerance = 2.0;

      if (maxExtent > 0) {
        if (animated && retriesLeft <= 1) {
          chatScrollController.animateTo(
            maxExtent,
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
          );
        } else {
          chatScrollController.jumpTo(maxExtent);
        }
      }

      final atBottom =
          maxExtent <= 0 || (maxExtent - position.pixels).abs() <= tolerance;
      final layoutStillChanging =
          previousMaxExtent == null ||
          (maxExtent - previousMaxExtent).abs() > tolerance;

      if (retriesLeft > 0 && (!atBottom || layoutStillChanging)) {
        _scrollToBottomAttempt(
          animated: animated,
          retriesLeft: retriesLeft - 1,
          previousMaxExtent: maxExtent,
        );
      }
    });
  }

  List<PlannerChatMessageItem> _buildMessageItems(
    List<CalendarChatMessage> messages,
  ) {
    final items = <PlannerChatMessageItem>[];

    if (messages.isEmpty &&
        chatMessages.isEmpty &&
        activeSessionId.value == null) {
      items.addAll([
        PlannerChatMessageItem(
          sender: PlannerMessageSender.ai,
          message: chatWelcomeMessage,
          avatarKind: PlannerChatAvatarKind.brandLogo,
        ),
        PlannerChatMessageItem(
          sender: PlannerMessageSender.ai,
          message: chatPromptMessage,
          avatarKind: PlannerChatAvatarKind.brandLogo,
        ),
      ]);
      if (showInitialTypingIndicator && !isAiTyping.value) {
        items.add(
          const PlannerChatMessageItem(
            sender: PlannerMessageSender.user,
            isTyping: true,
          ),
        );
      }
      return items;
    }

    for (final message in messages) {
      items.add(
        PlannerChatMessageItem(
          sender: message.isUser
              ? PlannerMessageSender.user
              : PlannerMessageSender.ai,
          message: message.text,
          avatarKind: message.isUser
              ? PlannerChatAvatarKind.userPhoto
              : PlannerChatAvatarKind.brandLogo,
        ),
      );
    }

    return items;
  }

  void _loadChatHistory() {
    if (usesMultiSessionHistory) {
      chatSessions.assignAll(_historyStorage.loadSessions());
      if (chatSessions.isNotEmpty) {
        _sessionCounter = chatSessions.length;
        _restoreSession(chatSessions.first);
      }
      return;
    }

    final cached = _historyStorage.loadCreateTaskChat();
    if (cached == null) return;
    chatMessages.assignAll(cached.messages);
    latestScheduleDisplay.value = cached.scheduleDisplay;
    scheduleMessageAnchor.value = cached.scheduleMessageAnchor;
    _syncStorePinnedSchedule(cached.scheduleDisplay);
    if (cached.messages.isNotEmpty) {
      scrollChatToBottom(animated: false);
    }
  }

  Future<void> _persistChatHistory() async {
    if (usesMultiSessionHistory) {
      await _historyStorage.saveSessions(chatSessions.toList());
      return;
    }

    if (chatMessages.isEmpty &&
        latestScheduleDisplay.value == null &&
        scheduleMessageAnchor.value == null) {
      await _historyStorage.clearCreateTaskChat();
      return;
    }

    await _historyStorage.saveCreateTaskChat(
      CalendarChatSession(
        id: 'create_task_chat',
        title: chatHeaderTitle,
        preview: '',
        updatedAt: DateTime.now(),
        messages: List<CalendarChatMessage>.from(chatMessages),
        scheduleDisplay: latestScheduleDisplay.value,
        scheduleMessageAnchor: scheduleMessageAnchor.value,
      ),
    );
  }

  void _resetToNewChat() {
    activeSessionId.value = null;
    isAiTyping.value = false;
    chatMessages.clear();
    latestScheduleDisplay.value = null;
    scheduleMessageAnchor.value = null;
    if (Get.isRegistered<TodayScheduleStore>()) {
      Get.find<TodayScheduleStore>().clearPinnedSchedule();
    }
  }

  void _syncStorePinnedSchedule(ScheduleDisplayEntity? display) {
    if (!Get.isRegistered<TodayScheduleStore>()) return;
    final store = Get.find<TodayScheduleStore>();
    if (display == null) {
      store.clearPinnedSchedule();
      return;
    }
    final days = AppHelper.scheduleDaysWithSlots(display);
    if (days.isEmpty) {
      store.clearPinnedSchedule();
      return;
    }
    store.setPinnedSchedule(
      ScheduleDisplayEntity(schema: display.schema, days: days),
      persist: false,
    );
  }

  Future<void> _sendCalendarChatMessage(String text) async {
    isChatSending.value = true;
    chatMessages.add(CalendarChatMessage(isUser: true, text: text));
    isAiTyping.value = true;
    _ensureActiveSession(text);
    _updateActiveSession();
    scrollChatToBottom();

    try {
      final response = await sendCalendarChatMessageUseCase(message: text);
      isAiTyping.value = false;
      if (response.assistantText.trim().isNotEmpty) {
        chatMessages.add(
          CalendarChatMessage(
            isUser: false,
            text: response.assistantText.trim(),
          ),
        );
      }
      await _applyScheduleDisplay(
        response.scheduleDisplay,
        scheduleVersion: response.scheduleVersion,
      );
      _updateActiveSession();
      scrollChatToBottom();
    } catch (e) {
      isAiTyping.value = false;
      _updateActiveSession();
      if (e is DioException) {
        final resolved = AuthErrorMessages.resolveDio(e, isLogin: false);
        AppToast.showError(resolved.$2.isNotEmpty ? resolved.$2 : resolved.$1);
      } else {
        AppToast.showError(AppTexts.calendarChatSendFailed);
      }
    } finally {
      isChatSending.value = false;
    }
  }

  Future<void> _applyScheduleDisplay(
    ScheduleDisplayEntity? display, {
    int scheduleVersion = 0,
  }) async {
    if (display != null) {
      final days = AppHelper.scheduleDaysWithSlots(display);
      if (days.isEmpty) {
        latestScheduleDisplay.value = null;
      } else {
        latestScheduleDisplay.value = ScheduleDisplayEntity(
          schema: display.schema,
          days: days,
        );
      }
      scheduleMessageAnchor.value = chatMessages.length;
    }

    if (Get.isRegistered<TodayScheduleStore>()) {
      await Get.find<TodayScheduleStore>().applyChatSchedule(
        display: display,
        scheduleVersion: scheduleVersion,
      );
    }
  }

  void _ensureActiveSession(String firstUserMessage) {
    if (!usesMultiSessionHistory) return;
    if (activeSessionId.value != null) return;

    _sessionCounter++;
    final newId = 'calendar_chat_$_sessionCounter';
    final session = CalendarChatSession(
      id: newId,
      title: _titleFromMessage(firstUserMessage),
      preview: firstUserMessage,
      updatedAt: DateTime.now(),
      messages: List<CalendarChatMessage>.from(chatMessages),
      scheduleDisplay: latestScheduleDisplay.value,
      scheduleMessageAnchor: scheduleMessageAnchor.value,
    );
    chatSessions.insert(0, session);
    activeSessionId.value = newId;
  }

  void _updateActiveSession() {
    if (!usesMultiSessionHistory) {
      _persistChatHistory();
      return;
    }

    final sessionId = activeSessionId.value;
    if (sessionId == null) return;

    final index = chatSessions.indexWhere((s) => s.id == sessionId);
    if (index < 0) return;

    final current = chatSessions[index];
    final firstUser = chatMessages.firstWhereOrNull((m) => m.isUser);
    chatSessions[index] = current.copyWith(
      title: firstUser == null
          ? current.title
          : _titleFromMessage(firstUser.text),
      preview: firstUser?.text ?? current.preview,
      updatedAt: DateTime.now(),
      messages: List<CalendarChatMessage>.from(chatMessages),
      scheduleDisplay: latestScheduleDisplay.value ?? current.scheduleDisplay,
      scheduleMessageAnchor:
          scheduleMessageAnchor.value ?? current.scheduleMessageAnchor,
    );
    chatSessions.refresh();
    _persistChatHistory();
  }

  String _titleFromMessage(String text) {
    final title = AppFormatter.chatSessionTitle(text);
    if (title.isEmpty) return AppTexts.plannerMessageInputHint;
    return title;
  }

  void _impact() {
    if (Get.isRegistered<HapticsController>()) {
      Get.find<HapticsController>().impact();
    }
  }
}
