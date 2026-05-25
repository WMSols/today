import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:today/core/network/zen_quote_service.dart';
import 'package:today/core/utils/app_formatter/app_formatter.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/feedback/app_toast.dart';
import 'package:today/domain/entities/home_daily_calendar_day_entity.dart';
import 'package:today/domain/entities/goal_card_entity.dart';
import 'package:today/domain/entities/active_goal_task_entity.dart';
import 'package:today/domain/entities/goal_history_day_entity.dart';
import 'package:today/domain/entities/home_today_task_entity.dart';
import 'package:today/domain/usecases/get_home_today_tasks_usecase.dart';
import 'package:today/domain/usecases/create_goal_usecase.dart';
import 'package:today/domain/usecases/complete_task_usecase.dart';
import 'package:today/domain/usecases/delete_goal_usecase.dart';
import 'package:today/domain/usecases/get_active_goal_tasks_usecase.dart';
import 'package:today/domain/usecases/get_goal_history_usecase.dart';
import 'package:today/domain/usecases/skip_task_usecase.dart';
import 'package:today/domain/usecases/get_weekly_calendar_usecase.dart';
import 'package:today/domain/repositories/home_daily_calendar_repository.dart';
import 'package:today/presentation/controllers/goals/goal_cards_controller.dart';
import 'package:today/presentation/controllers/main/main_app_controller.dart';
import 'package:today/presentation/controllers/settings/settings_controller.dart';
import 'package:today/core/widgets/common/app_bottom_sheet.dart';
import 'package:today/core/widgets/features/home/goal_entry/home_add_goal_bottom_sheet.dart';
import 'package:today/presentation/routes/app_routes.dart';

class ActiveGoalOverviewDisplay {
  const ActiveGoalOverviewDisplay({
    required this.dayLeftDisplay,
    required this.dayRightDisplay,
    required this.tasksText,
    required this.percentText,
    required this.progress,
    required this.footerText,
    required this.medalIconPath,
  });

  final String dayLeftDisplay;
  final String dayRightDisplay;
  final String tasksText;
  final String percentText;
  final double progress;
  final String footerText;
  final String medalIconPath;
}

class HomeCalendarDisplay {
  const HomeCalendarDisplay({
    required this.dayOfYear,
    required this.totalDays,
    required this.daysLeft,
    required this.year,
  });

  final int dayOfYear;
  final int totalDays;
  final int daysLeft;
  final int year;
}

class HomeController extends GetxController with GetTickerProviderStateMixin {
  static const Duration _calendarRingAnimationDuration = Duration(seconds: 2);
  static const String _lastAiPlanKey = 'last_ai_plan_generated_at_ms';
  static const int homeTodayTasksPreviewLimit = 5;

  HomeController(
    this._goalCardsController,
    this._getActiveGoalTasksUseCase,
    this._createGoalUseCase,
    this._completeTaskUseCase,
    this._skipTaskUseCase,
    this._getGoalHistoryUseCase,
    this._deleteGoalUseCase,
    this._getWeeklyCalendarUseCase,
    this._getHomeTodayTasksUseCase,
  );

  final GoalCardsController _goalCardsController;
  final GetActiveGoalTasksUseCase _getActiveGoalTasksUseCase;
  final CreateGoalUseCase _createGoalUseCase;
  final CompleteTaskUseCase _completeTaskUseCase;
  final SkipTaskUseCase _skipTaskUseCase;
  final GetGoalHistoryUseCase _getGoalHistoryUseCase;
  final DeleteGoalUseCase _deleteGoalUseCase;
  final GetWeeklyCalendarUseCase _getWeeklyCalendarUseCase;
  final GetHomeTodayTasksUseCase _getHomeTodayTasksUseCase;

  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxBool isCreatingGoal = false.obs;
  final RxList<ActiveGoalTaskEntity> activeGoalTasks =
      <ActiveGoalTaskEntity>[].obs;
  final RxList<GoalHistoryDayEntity> goalHistoryDays =
      <GoalHistoryDayEntity>[].obs;
  final RxList<HomeDailyCalendarDayEntity> calendarDays =
      <HomeDailyCalendarDayEntity>[].obs;
  final RxList<HomeTodayTaskEntity> todayTasks = <HomeTodayTaskEntity>[].obs;
  final RxString selectedTodayTaskId = ''.obs;
  final Rxn<DateTime> lastAiPlanGeneratedAt = Rxn<DateTime>();

  late final AnimationController calendarRingAnimationController;
  late final AnimationController todayProgressRingAnimationController;
  final RxDouble calendarRingAnimationFactor = 0.0.obs;
  final RxDouble todayProgressRingAnimationFactor = 0.0.obs;

  final Rxn<({String quote, String author})> calendarQuote = Rxn();
  final RxBool isCalendarQuoteLoading = false.obs;

  final TextEditingController goalInputController = TextEditingController();
  final RxString goalDraft = ''.obs;
  final RxString selectedGoalId = ''.obs;

  bool _calendarQuoteRequested = false;

  RxList<GoalCardEntity> get goalCards => _goalCardsController.goalCards;

  RxBool get isGoalCardsLoading => _goalCardsController.isLoading;

  GoalCardEntity? get selectedGoalCard {
    final id = selectedGoalId.value;
    if (id.isEmpty) return null;
    for (final goal in goalCards) {
      if (goal.goalId == id) return goal;
    }
    return null;
  }

  String get selectedGoalTitle {
    return selectedGoalCard?.title ?? AppTexts.goalDefaultTitle;
  }

  ActiveGoalOverviewDisplay get activeGoalOverviewDisplay {
    final card = selectedGoalCard;
    final fallbackRight = AppTexts.activeGoalOverviewOutOfSample;
    final dayLeft = card?.dayText ?? AppTexts.activeGoalOverviewDaySample;
    final (dayLeftDisplay, dayRight) = card == null
        ? (dayLeft, fallbackRight)
        : _splitGoalDayHeaderText(card.dayText, fallbackRight);

    return ActiveGoalOverviewDisplay(
      dayLeftDisplay: dayLeftDisplay,
      dayRightDisplay: dayRight,
      tasksText: card?.tasksText ?? AppTexts.activeGoalOverviewTasksSample,
      percentText:
          card?.percentText ?? AppTexts.activeGoalOverviewPercentSample,
      progress: card?.progress ?? 0.28,
      footerText: card?.totalTasksText ?? AppTexts.activeGoalOverviewMotivation,
      medalIconPath: card?.iconPath ?? AppImages.medal1,
    );
  }

  String get dashboardUserName {
    if (Get.isRegistered<SettingsController>()) {
      return Get.find<SettingsController>().greetingDisplayName;
    }
    return AppTexts.homeGreetingGuestName;
  }

  String get aiFocusKeyword => AppTexts.homeAiFocusDefault;

  String get lastAiPlanGeneratedAtLabel {
    final at = lastAiPlanGeneratedAt.value;
    final fallback = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      6,
      30,
    );
    return AppFormatter.timeOfDay(at ?? fallback);
  }

  double get yesterdayCompletionProgress {
    final days = calendarDays;
    if (days.isEmpty) return 0;
    final todayIndex = days.indexWhere((d) => d.isToday);
    if (todayIndex > 0) {
      return days[todayIndex - 1].progress.clamp(0.0, 1.0);
    }
    return 0;
  }

  int get todayTasksTotalCount => todayTasks.length;

  int get todayTasksCompletedCount {
    if (todayTasks.isEmpty) return 0;
    return todayTasks
        .where((t) => t.status == HomeTodayTaskStatus.completed)
        .length;
  }

  /// Share of today's home tasks marked completed (drives progress card).
  double get todayTasksCompletionProgress {
    final total = todayTasksTotalCount;
    if (total == 0) return 0;
    return (todayTasksCompletedCount / total).clamp(0.0, 1.0);
  }

  /// Progress card color, %, and ring — completed ÷ total today's tasks only.
  double get todayProgressCardRatio => todayTasksCompletionProgress;

  /// Ring center label, e.g. `3/6`.
  String get todayProgressCardTasksFraction =>
      '$todayTasksCompletedCount/$todayTasksTotalCount';

  double get todayCompletionProgress {
    if (todayTasks.isNotEmpty) {
      return todayTasksCompletionProgress;
    }
    for (final day in calendarDays) {
      if (day.isToday) return day.progress.clamp(0.0, 1.0);
    }
    if (goalCards.isEmpty) return 0;
    var sum = 0.0;
    for (final goal in goalCards) {
      sum += goal.progress;
    }
    return (sum / goalCards.length).clamp(0.0, 1.0);
  }

  double get dailyPlanProgress {
    if (goalCards.isEmpty) return 0;
    var sum = 0.0;
    for (final goal in goalCards) {
      sum += goal.progress;
    }
    return (sum / goalCards.length).clamp(0.0, 1.0);
  }

  int get todayTasksCompleted {
    if (todayTasks.isNotEmpty) {
      return todayTasks
          .where((t) => t.status == HomeTodayTaskStatus.completed)
          .length;
    }
    final card =
        selectedGoalCard ?? (goalCards.isNotEmpty ? goalCards.first : null);
    if (card != null) {
      final match = RegExp(r'(\d+)\s*/\s*(\d+)').firstMatch(card.tasksText);
      if (match != null) {
        return int.tryParse(match.group(1)!) ?? 0;
      }
    }
    return (todayCompletionProgress * 6).round();
  }

  List<HomeTodayTaskEntity> get homeTodayTasksPreview =>
      todayTasks.take(homeTodayTasksPreviewLimit).toList(growable: false);

  HomeCalendarDisplay get calendarDisplay {
    final now = DateTime.now();
    final dayOfYear = _dayOfYear(now);
    final totalDays = _daysInYear(now.year);
    return HomeCalendarDisplay(
      dayOfYear: dayOfYear,
      totalDays: totalDays,
      daysLeft: totalDays - dayOfYear,
      year: now.year,
    );
  }

  @override
  void onInit() {
    super.onInit();
    calendarRingAnimationController = AnimationController(
      vsync: this,
      duration: _calendarRingAnimationDuration,
    )..addListener(_syncCalendarRingAnimationFactor);
    todayProgressRingAnimationController = AnimationController(
      vsync: this,
      duration: _calendarRingAnimationDuration,
    )..addListener(_syncTodayProgressRingAnimationFactor);
    ever(goalCards, (_) => _syncSelectedGoalId());
    _loadLastAiPlanTime();
    loadGoalCards();
    loadWeeklyCalendar();
    loadTodayTasks();
  }

  Future<void> loadTodayTasks() async {
    try {
      final items = await _getHomeTodayTasksUseCase();
      todayTasks.assignAll(items);
      _playTodayProgressRingAnimation();
    } catch (_) {
      _showError(AppTexts.homeUnableLoadTodayTasks);
    }
  }

  Future<void> refreshHome() async {
    isRefreshing.value = true;
    try {
      await Future.wait([
        loadGoalCards(),
        loadWeeklyCalendar(),
        loadTodayTasks(),
      ]);
    } finally {
      isRefreshing.value = false;
    }
  }

  void selectTodayTask(String taskId) {
    if (taskId.isEmpty) return;
    final task = todayTasks.firstWhereOrNull((t) => t.id == taskId);
    if (task == null || !task.isPending) return;
    selectedTodayTaskId.value = selectedTodayTaskId.value == taskId
        ? ''
        : taskId;
  }

  void completeTodayTask(String taskId) {
    _setTodayTaskStatus(taskId, HomeTodayTaskStatus.completed);
    selectedTodayTaskId.value = '';
    AppToast.showSuccess(AppTexts.toastTaskCompleted);
  }

  void skipTodayTask(String taskId) {
    _setTodayTaskStatus(taskId, HomeTodayTaskStatus.skipped);
    selectedTodayTaskId.value = '';
    AppToast.showInformation(AppTexts.toastTaskSkippedTitle);
  }

  void _setTodayTaskStatus(String taskId, HomeTodayTaskStatus status) {
    final index = todayTasks.indexWhere((t) => t.id == taskId);
    if (index < 0) return;
    todayTasks[index] = todayTasks[index].copyWith(status: status);
    todayTasks.refresh();
    _playTodayProgressRingAnimation();
  }

  void _syncTodayProgressRingAnimationFactor() {
    todayProgressRingAnimationFactor.value = Curves.easeOutCubic.transform(
      todayProgressRingAnimationController.value,
    );
  }

  void _playTodayProgressRingAnimation() {
    todayProgressRingAnimationController.forward(from: 0);
  }

  void _loadLastAiPlanTime() {
    if (!Get.isRegistered<SharedPreferences>()) return;
    final ms = Get.find<SharedPreferences>().getInt(_lastAiPlanKey);
    if (ms != null) {
      lastAiPlanGeneratedAt.value = DateTime.fromMillisecondsSinceEpoch(ms);
    }
  }

  static Future<void> recordLastAiPlanGeneratedAt(DateTime when) async {
    if (!Get.isRegistered<SharedPreferences>()) return;
    await Get.find<SharedPreferences>().setInt(
      _lastAiPlanKey,
      when.millisecondsSinceEpoch,
    );
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().lastAiPlanGeneratedAt.value = when;
    }
  }

  void _syncCalendarRingAnimationFactor() {
    calendarRingAnimationFactor.value = Curves.easeOutCubic.transform(
      calendarRingAnimationController.value,
    );
  }

  void _playCalendarRingAnimation() {
    calendarRingAnimationController.forward(from: 0);
  }

  Future<void> loadWeeklyCalendar() async {
    final days = await _getWeeklyCalendarUseCase(
      variant: HomeWeeklyCalendarVariant.home,
    );
    calendarDays.assignAll(days);
    _playCalendarRingAnimation();
  }

  void onCalendarDayTap(HomeDailyCalendarDayEntity day) {
    openStatsTab();
  }

  void openHomeCalendar() {
    ensureCalendarQuoteLoaded();
    Get.toNamed<void>(AppRoutes.homeCalendar);
  }

  void openPlanner() {
    Get.toNamed<void>(AppRoutes.planner);
  }

  void openAddGoalSheet() {
    final context = Get.context;
    if (context == null) return;
    AppBottomSheet.show<void>(context, child: const HomeAddGoalBottomSheet());
  }

  void openGoalsTab() {
    if (Get.isRegistered<MainAppController>()) {
      Get.find<MainAppController>().selectTab(MainAppController.goalsTabIndex);
    }
  }

  void openStatsTab() {
    if (Get.isRegistered<MainAppController>()) {
      Get.find<MainAppController>().openStatsTab();
    }
  }

  void openActiveGoalDetails(String goalId) {
    Get.toNamed<void>(AppRoutes.activeGoalDetails, arguments: goalId);
    final resolvedId = goalId.isNotEmpty ? goalId : selectedGoalId.value;
    if (resolvedId.isEmpty) return;
    if (selectedGoalId.value != resolvedId || activeGoalTasks.isEmpty) {
      loadActiveGoalTasks(resolvedId);
    }
  }

  void ensureCalendarQuoteLoaded() {
    if (_calendarQuoteRequested) return;
    _calendarQuoteRequested = true;
    isCalendarQuoteLoading.value = true;
    const ZenQuoteService()
        .fetchTodayQuote()
        .then((quote) {
          calendarQuote.value = quote;
        })
        .whenComplete(() {
          isCalendarQuoteLoading.value = false;
        });
  }

  Future<void> deleteActiveGoal() async {
    final goalId = selectedGoalId.value;
    if (goalId.isEmpty) return;
    await deleteGoal(goalId);
    if (Get.currentRoute == AppRoutes.activeGoalDetails) {
      Get.back<void>();
    }
  }

  void _syncSelectedGoalId() {
    if (selectedGoalId.value.isEmpty && goalCards.isNotEmpty) {
      selectedGoalId.value = goalCards.first.goalId;
    }
  }

  void setGoalDraft(String value) {
    goalDraft.value = value;
  }

  Future<void> loadGoalCards() async {
    final ok = await _goalCardsController.loadGoalCards();
    if (!ok) {
      _showError(AppTexts.homeUnableLoadGoals);
      return;
    }
    _syncSelectedGoalId();
  }

  Future<void> loadActiveGoalTasks(String goalId) async {
    isLoading.value = true;
    selectedGoalId.value = goalId;
    try {
      final items = await _getActiveGoalTasksUseCase(goalId);
      activeGoalTasks.assignAll(items);
      await loadGoalHistory(goalId, silent: true);
    } catch (_) {
      _showError(AppTexts.homeUnableLoadTodayTasks);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadGoalHistory(String goalId, {bool silent = false}) async {
    if (!silent) {
      isLoading.value = true;
    }
    try {
      final days = await _getGoalHistoryUseCase(goalId);
      goalHistoryDays.assignAll(days);
    } catch (_) {
      _showError(AppTexts.homeUnableLoadGoalHistory);
    } finally {
      if (!silent) {
        isLoading.value = false;
      }
    }
  }

  Future<void> completeTask(String taskId) async {
    if (taskId.isEmpty) return;
    try {
      final result = await _completeTaskUseCase(taskId);
      if (!result.already) {
        AppToast.showSuccess(AppTexts.toastTaskCompleted);
      } else {
        AppToast.showInformation(AppTexts.toastTaskAlreadyCompleted);
      }
      if (selectedGoalId.value.isNotEmpty) {
        await loadActiveGoalTasks(selectedGoalId.value);
      }
    } catch (_) {
      _showError(AppTexts.homeUnableCompleteTask);
    }
  }

  Future<void> skipTask(String taskId) async {
    if (taskId.isEmpty) return;
    try {
      final result = await _skipTaskUseCase(taskId);
      if (!result.already) {
        AppToast.showWarning(
          AppTexts.toastTaskSkippedTitle,
          result.balance == null
              ? null
              : AppTexts.taskSkippedBalanceSubtitle(result.balance!),
        );
      } else {
        AppToast.showInformation(AppTexts.toastTaskAlreadySkipped);
      }
      if (selectedGoalId.value.isNotEmpty) {
        await loadActiveGoalTasks(selectedGoalId.value);
      }
    } catch (_) {
      _showError(AppTexts.homeUnableSkipTask);
    }
  }

  Future<void> deleteGoal(String goalId) async {
    if (goalId.isEmpty) return;
    try {
      await _deleteGoalUseCase(goalId);
      AppToast.showSuccess(AppTexts.toastGoalDeleted);
      await loadGoalCards();
      if (selectedGoalId.value.isNotEmpty) {
        await loadActiveGoalTasks(selectedGoalId.value);
      } else {
        activeGoalTasks.clear();
      }
    } catch (_) {
      _showError(AppTexts.homeUnableDeleteGoal);
    }
  }

  Future<bool> createGoalFromDraft() async {
    final text = goalDraft.value.trim();
    if (text.length < 3) return false;
    isCreatingGoal.value = true;
    try {
      await _createGoalUseCase(
        goalText: text,
        durationDays: 30,
        resetTimeLocal: '09:00',
        tasksPerDay: 6,
      );
      goalInputController.clear();
      goalDraft.value = '';
      AppToast.showSuccess(AppTexts.toastGoalCreated);
      await loadGoalCards();
      return true;
    } catch (_) {
      _showError(AppTexts.homeUnableCreateGoal);
      return false;
    } finally {
      isCreatingGoal.value = false;
    }
  }

  Future<void> submitGoalDraftAndCloseSheet() async {
    final created = await createGoalFromDraft();
    if (!created) return;
    if (Get.isBottomSheetOpen == true) {
      Get.back<void>();
    }
  }

  (String, String) _splitGoalDayHeaderText(
    String dayText,
    String fallbackRight,
  ) {
    final match = RegExp(
      r'^(DAY\s+\d+)\s+OF\s+(\d+)$',
      caseSensitive: false,
    ).firstMatch(dayText.trim());
    if (match != null) {
      return (match.group(1)!, 'OUT OF ${match.group(2)}');
    }
    return (dayText, fallbackRight);
  }

  int _dayOfYear(DateTime now) {
    return now.difference(DateTime(now.year, 1, 1)).inDays + 1;
  }

  int _daysInYear(int year) {
    final start = DateTime(year, 1, 1);
    final end = DateTime(year + 1, 1, 1);
    return end.difference(start).inDays;
  }

  void _showError(String message) {
    if (Get.context != null) {
      AppToast.showError(AppTexts.error, message);
    }
  }

  @override
  void onClose() {
    calendarRingAnimationController.dispose();
    todayProgressRingAnimationController.dispose();
    goalInputController.dispose();
    super.onClose();
  }
}
