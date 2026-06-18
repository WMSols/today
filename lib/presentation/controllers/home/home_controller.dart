import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:today/core/network/zen_quote_service.dart';
import 'package:today/core/utils/app_formatter/app_formatter.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/common/app_action_dialog.dart';
import 'package:today/core/widgets/feedback/app_toast.dart';
import 'package:today/domain/entities/home_daily_calendar_day_entity.dart';
import 'package:today/domain/entities/goal_card_entity.dart';
import 'package:today/domain/entities/active_goal_task_entity.dart';
import 'package:today/domain/entities/goal_history_day_entity.dart';
import 'package:today/domain/entities/home_today_task_entity.dart';
import 'package:today/core/storage/today_schedule_store.dart';
import 'package:today/domain/repositories/home_today_tasks_repository.dart';
import 'package:today/domain/usecases/create_goal_usecase.dart';
import 'package:today/domain/usecases/complete_task_usecase.dart';
import 'package:today/domain/usecases/delete_goal_usecase.dart';
import 'package:today/domain/usecases/get_active_goal_tasks_usecase.dart';
import 'package:today/domain/usecases/get_goal_history_usecase.dart';
import 'package:today/domain/usecases/skip_task_usecase.dart';
import 'package:today/core/constants/api_constants.dart';
import 'package:today/domain/entities/update_calendar_event_params.dart';
import 'package:today/domain/usecases/delete_calendar_event_usecase.dart';
import 'package:today/domain/usecases/get_weekly_calendar_usecase.dart';
import 'package:today/domain/usecases/delete_goal_task_usecase.dart';
import 'package:today/domain/usecases/update_calendar_event_usecase.dart';
import 'package:today/domain/usecases/update_goal_task_usecase.dart';
import 'package:today/domain/repositories/home_daily_calendar_repository.dart';
import 'package:today/presentation/controllers/goals/goal_cards_controller.dart';
import 'package:today/presentation/controllers/main/main_app_controller.dart';
import 'package:today/presentation/controllers/settings/settings_controller.dart';
import 'package:today/core/widgets/common/app_bottom_sheet.dart';
import 'package:today/core/widgets/features/home/goal_entry/home_add_goal_bottom_sheet.dart';
import 'package:today/presentation/controllers/animation/app_animation_controller.dart';
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
    this._scheduleStore,
    this._homeTodayTasksRepository,
    this._deleteCalendarEventUseCase,
    this._updateCalendarEventUseCase,
    this._updateGoalTaskUseCase,
    this._deleteGoalTaskUseCase,
  );

  final GoalCardsController _goalCardsController;
  final GetActiveGoalTasksUseCase _getActiveGoalTasksUseCase;
  final CreateGoalUseCase _createGoalUseCase;
  final CompleteTaskUseCase _completeTaskUseCase;
  final SkipTaskUseCase _skipTaskUseCase;
  final GetGoalHistoryUseCase _getGoalHistoryUseCase;
  final DeleteGoalUseCase _deleteGoalUseCase;
  final GetWeeklyCalendarUseCase _getWeeklyCalendarUseCase;
  final TodayScheduleStore _scheduleStore;
  final HomeTodayTasksRepository _homeTodayTasksRepository;
  final DeleteCalendarEventUseCase _deleteCalendarEventUseCase;
  final UpdateCalendarEventUseCase _updateCalendarEventUseCase;
  final UpdateGoalTaskUseCase _updateGoalTaskUseCase;
  final DeleteGoalTaskUseCase _deleteGoalTaskUseCase;

  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxBool isCreatingGoal = false.obs;
  final RxList<ActiveGoalTaskEntity> activeGoalTasks =
      <ActiveGoalTaskEntity>[].obs;
  final RxList<GoalHistoryDayEntity> goalHistoryDays =
      <GoalHistoryDayEntity>[].obs;
  final RxList<HomeDailyCalendarDayEntity> calendarDays =
      <HomeDailyCalendarDayEntity>[].obs;
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

  List<HomeTodayTaskEntity> get todayTasks {
    _scheduleStore.agendaTasks.length;
    return _scheduleStore.todayTasks;
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

  List<HomeTodayTaskEntity> get todayCalendarEvents => todayTasks
      .where((task) => task.source == HomeTodayTaskSource.calendarEvent)
      .toList(growable: false);

  List<HomeTodayTaskEntity> get todayGoalTasks => todayTasks
      .where((task) => task.source == HomeTodayTaskSource.goalTask)
      .toList(growable: false);

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
    _scheduleStore.ensureLoaded().then((_) => _playTodayProgressRingAnimation());
  }

  Future<void> loadTodayTasks() async {
    try {
      await _scheduleStore.ensureLoaded();
      _playTodayProgressRingAnimation();
    } catch (_) {
      _showError(AppTexts.homeUnableLoadTodayTasks);
    }
  }

  Future<void> refreshAgendaFromCalendar() async {
    await Future.wait([
      _scheduleStore.refreshFromApi(),
      loadWeeklyCalendar(),
    ]);
    _playTodayProgressRingAnimation();
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

  Future<void> refreshTodaysTasks() async {
    await refreshAgendaFromCalendar();
  }

  void selectTodayTask(String taskId) {
    if (taskId.isEmpty) return;
    final task = todayTasks.firstWhereOrNull((t) => t.id == taskId);
    if (task == null || !task.isPending) return;
    selectedTodayTaskId.value = selectedTodayTaskId.value == taskId
        ? ''
        : taskId;
  }

  Future<void> completeTodayTask(String taskId) async {
    final task = todayTasks.firstWhereOrNull((t) => t.id == taskId);
    if (task == null || !task.isGoalTask) return;

    if (ApiConstants.backendApiEnabled) {
      await completeTask(taskId);
      selectedTodayTaskId.value = '';
      return;
    }

    await _homeTodayTasksRepository.updateTodayTaskStatus(
      taskId: taskId,
      status: HomeTodayTaskStatus.completed,
    );
    _setTodayTaskStatus(taskId, HomeTodayTaskStatus.completed);
    selectedTodayTaskId.value = '';
    AppToast.showSuccess(AppTexts.toastTaskCompleted);
  }

  Future<void> skipTodayTask(String taskId) async {
    final task = todayTasks.firstWhereOrNull((t) => t.id == taskId);
    if (task == null || !task.isGoalTask) return;

    if (ApiConstants.backendApiEnabled) {
      await skipTask(taskId);
      selectedTodayTaskId.value = '';
      return;
    }

    await _homeTodayTasksRepository.updateTodayTaskStatus(
      taskId: taskId,
      status: HomeTodayTaskStatus.skipped,
    );
    _setTodayTaskStatus(taskId, HomeTodayTaskStatus.skipped);
    selectedTodayTaskId.value = '';
    AppToast.showError(AppTexts.toastTaskSkippedTitle);
  }

  Future<void> onCalendarEventLongPress(HomeTodayTaskEntity task) async {
    if (!task.isCalendarEvent) return;
    await deleteCalendarEvent(task);
  }

  Future<void> onCalendarEventEdit(HomeTodayTaskEntity task) async {
    if (!task.isCalendarEvent) return;
    final context = Get.context;
    if (context == null) return;

    var updateSeries = false;
    if (task.isRecurring) {
      final scope = await AppActionDialog.showRecurringScope(
        context,
        title: AppTexts.recurringEventTitle,
        subtitle: AppTexts.recurringEventEditSubtitle,
        seriesLabel: AppTexts.updateSeriesLabel,
      );
      if (scope == null) return;
      updateSeries = scope;
    }

    await AppActionDialog.showTextInput(
      context,
      title: AppTexts.editEventTitle,
      initialValue: task.title,
      onSubmit: (title) => updateCalendarEventTitle(
        task: task,
        title: title,
        updateSeries: updateSeries,
      ),
    );
  }

  Future<void> onGoalTaskEdit(HomeTodayTaskEntity task) async {
    if (!task.isGoalTask) return;
    final context = Get.context;
    if (context == null) return;
    await AppActionDialog.showTextInput(
      context,
      title: AppTexts.editGoalTaskTitle,
      subtitle: AppTexts.editGoalTaskSubtitle,
      initialValue: task.title,
      onSubmit: (title) => updateGoalTaskTitle(task: task, title: title),
    );
  }

  Future<void> onGoalTaskDelete(HomeTodayTaskEntity task) async {
    if (!task.isGoalTask) return;
    final context = Get.context;
    if (context == null) return;
    await AppActionDialog.showConfirm(
      context,
      title: AppTexts.deleteGoalTaskTitle,
      subtitle: AppTexts.deleteGoalTaskBody,
      confirmLabel: AppTexts.delete,
      onConfirm: () async {
        try {
          await _deleteGoalTaskUseCase(task.id);
          selectedTodayTaskId.value = '';
          await _scheduleStore.applyGoalTaskDeleted(taskId: task.id);
          _playTodayProgressRingAnimation();
          AppToast.showSuccess(AppTexts.goalTaskDeleted);
          return true;
        } catch (_) {
          AppToast.showError(AppTexts.goalTaskDeleteFailed);
          return false;
        }
      },
    );
  }

  void onCalendarEventCompletePlaceholder(HomeTodayTaskEntity task) {
    if (!task.isCalendarEvent) return;
    AppToast.showInformation(AppTexts.calendarEventCompleteNotImplemented);
  }

  void onCalendarEventSkipPlaceholder(HomeTodayTaskEntity task) {
    if (!task.isCalendarEvent) return;
    AppToast.showInformation(AppTexts.calendarEventSkipNotImplemented);
  }

  Future<void> deleteCalendarEvent(
    HomeTodayTaskEntity task, {
    bool? deleteSeries,
  }) async {
    if (!task.isCalendarEvent) return;
    final context = Get.context;
    if (context == null) return;

    var applyToSeries = deleteSeries ?? false;
    if (deleteSeries == null && task.isRecurring) {
      final scope = await AppActionDialog.showRecurringScope(
        context,
        title: AppTexts.recurringEventTitle,
        subtitle: AppTexts.recurringEventDeleteSubtitle,
        seriesLabel: AppTexts.deleteSeriesLabel,
      );
      if (scope == null) return;
      applyToSeries = scope;
    }

    await AppActionDialog.showConfirm(
      context,
      title: AppTexts.deleteEventTitle,
      subtitle: AppTexts.deleteEventBody,
      confirmLabel: AppTexts.delete,
      onConfirm: () async {
        try {
          await _deleteCalendarEventUseCase(
            eventId: task.id,
            deleteSeries: applyToSeries,
          );
          selectedTodayTaskId.value = '';
          await _scheduleStore.applyCalendarEventDeleted(eventId: task.id);
          _playTodayProgressRingAnimation();
          AppToast.showSuccess(AppTexts.calendarEventDeleted);
          return true;
        } catch (_) {
          AppToast.showError(AppTexts.calendarEventDeleteFailed);
          return false;
        }
      },
    );
  }

  Future<bool> updateCalendarEventTitle({
    required HomeTodayTaskEntity task,
    required String title,
    bool updateSeries = false,
  }) async {
    try {
      await _updateCalendarEventUseCase(
        eventId: task.id,
        params: UpdateCalendarEventParams(title: title),
        updateSeries: updateSeries,
      );
      await _scheduleStore.applyCalendarEventEdited(
        eventId: task.id,
        newTitle: title,
      );
      _playTodayProgressRingAnimation();
      AppToast.showSuccess(AppTexts.calendarEventUpdated);
      return true;
    } catch (_) {
      AppToast.showError(AppTexts.calendarEventUpdateFailed);
      return false;
    }
  }

  Future<bool> updateGoalTaskTitle({
    required HomeTodayTaskEntity task,
    required String title,
  }) async {
    try {
      await _updateGoalTaskUseCase(taskId: task.id, title: title);
      await _scheduleStore.applyGoalTaskTitle(taskId: task.id, title: title);
      _playTodayProgressRingAnimation();
      AppToast.showSuccess(AppTexts.goalTaskUpdated);
      return true;
    } catch (_) {
      AppToast.showError(AppTexts.goalTaskUpdateFailed);
      return false;
    }
  }

  void _setTodayTaskStatus(String taskId, HomeTodayTaskStatus status) {
    _scheduleStore.applyGoalTaskStatus(taskId: taskId, status: status);
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

  void openNewGoalChat() {
    AppAnimationController.pushNamed<void>(AppRoutes.goalsChat);
  }

  void openCreateTask() {
    AppAnimationController.pushNamed<void>(AppRoutes.createTask);
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

  void openAgendaScreen() {
    AppAnimationController.pushNamed<void>(AppRoutes.agenda);
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
      await _scheduleStore.applyGoalTaskStatus(
        taskId: taskId,
        status: HomeTodayTaskStatus.completed,
      );
      _playTodayProgressRingAnimation();
      await _goalCardsController.loadGoalCards(force: true);
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
          result.balance == null
              ? AppTexts.toastTaskSkippedTitle
              : '${AppTexts.toastTaskSkippedTitle} · '
                    '${AppTexts.taskSkippedBalanceSubtitle(result.balance!)}',
        );
      } else {
        AppToast.showInformation(AppTexts.toastTaskAlreadySkipped);
      }
      if (selectedGoalId.value.isNotEmpty) {
        await loadActiveGoalTasks(selectedGoalId.value);
      }
      await _scheduleStore.applyGoalTaskStatus(
        taskId: taskId,
        status: HomeTodayTaskStatus.skipped,
      );
      _playTodayProgressRingAnimation();
      await _goalCardsController.loadGoalCards(force: true);
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
      AppToast.showError(message);
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
