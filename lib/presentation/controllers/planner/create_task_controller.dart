import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/utils/app_formatter/app_formatter.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/feedback/app_toast.dart';
import 'package:today/core/widgets/form/app_datetime_picker/app_datetime_picker.dart';
import 'package:today/domain/entities/create_today_task_params.dart';
import 'package:today/domain/usecases/create_today_task_usecase.dart';
import 'package:today/presentation/controllers/animation/app_animation_controller.dart';
import 'package:today/presentation/controllers/home/home_controller.dart';
import 'package:today/presentation/controllers/settings/haptics_controller.dart';
import 'package:today/presentation/routes/app_routes.dart';

class CreateTaskController extends GetxController {
  CreateTaskController(this._createTodayTaskUseCase);

  final CreateTodayTaskUseCase _createTodayTaskUseCase;

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final notesController = TextEditingController();

  final Rxn<DateTime> scheduledDate = Rxn<DateTime>();
  final Rxn<DateTime> startDateTime = Rxn<DateTime>();
  final Rxn<DateTime> endDateTime = Rxn<DateTime>();
  final RxBool isRecurring = false.obs;
  final RxBool isSubmitting = false.obs;

  String get scheduleDisplay {
    final date = scheduledDate.value;
    if (date == null) return '';
    return AppFormatter.shortDate(date);
  }

  String get startTimeDisplay {
    final time = startDateTime.value;
    if (time == null) return '';
    return AppFormatter.timeOfDay(time);
  }

  String get endTimeDisplay {
    final time = endDateTime.value;
    if (time == null) return '';
    return AppFormatter.timeOfDay(time);
  }

  @override
  void onInit() {
    super.onInit();
    final now = DateTime.now();
    scheduledDate.value = DateTime(now.year, now.month, now.day);
    startDateTime.value = DateTime(now.year, now.month, now.day, 9);
    endDateTime.value = DateTime(now.year, now.month, now.day, 10);
  }

  @override
  void onClose() {
    titleController.dispose();
    notesController.dispose();
    super.onClose();
  }

  void toggleRecurring(bool value) {
    isRecurring.value = value;
  }

  Future<void> openSchedulePicker() async {
    final context = Get.context;
    if (context == null) return;
    _impact();
    final picked = await AppDateTimePicker.show(
      context,
      title: AppTexts.createTaskScheduleLabel,
      initial: scheduledDate.value ?? DateTime.now(),
      mode: AppDateTimePickerMode.dateOnly,
    );
    if (picked == null) return;
    scheduledDate.value = DateTime(picked.year, picked.month, picked.day);
    _realignTimesToSchedule();
  }

  Future<void> openStartTimePicker() async {
    await _openTimePicker(isStart: true);
  }

  Future<void> openEndTimePicker() async {
    await _openTimePicker(isStart: false);
  }

  Future<void> _openTimePicker({required bool isStart}) async {
    final context = Get.context;
    if (context == null) return;
    final schedule = scheduledDate.value;
    if (schedule == null) {
      AppToast.showError(
        AppTexts.error,
        AppTexts.createTaskSelectScheduleFirst,
      );
      return;
    }
    _impact();
    final current = isStart ? startDateTime.value : endDateTime.value;
    final initial =
        current ?? DateTime(schedule.year, schedule.month, schedule.day, 9);
    final picked = await AppDateTimePicker.show(
      context,
      title: isStart
          ? AppTexts.createTaskStartTimeLabel
          : AppTexts.createTaskEndTimeLabel,
      initial: initial,
      mode: AppDateTimePickerMode.timeOnly,
    );
    if (picked == null) return;
    final merged = _mergeWithSchedule(schedule, picked);
    if (isStart) {
      startDateTime.value = merged;
    } else {
      endDateTime.value = merged;
    }
  }

  void _realignTimesToSchedule() {
    final schedule = scheduledDate.value;
    if (schedule == null) return;
    final start = startDateTime.value;
    if (start != null) {
      startDateTime.value = _mergeWithSchedule(schedule, start);
    }
    final end = endDateTime.value;
    if (end != null) {
      endDateTime.value = _mergeWithSchedule(schedule, end);
    }
  }

  DateTime _mergeWithSchedule(DateTime schedule, DateTime time) {
    return DateTime(
      schedule.year,
      schedule.month,
      schedule.day,
      time.hour,
      time.minute,
    );
  }

  String? validateTitle(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return AppTexts.createTaskTitleRequired;
    return null;
  }

  bool _validateDateTimes() {
    if (scheduledDate.value == null) {
      AppToast.showError(AppTexts.error, AppTexts.createTaskScheduleRequired);
      return false;
    }
    if (startDateTime.value == null) {
      AppToast.showError(AppTexts.error, AppTexts.createTaskStartTimeRequired);
      return false;
    }
    if (endDateTime.value == null) {
      AppToast.showError(AppTexts.error, AppTexts.createTaskEndTimeRequired);
      return false;
    }
    if (!endDateTime.value!.isAfter(startDateTime.value!)) {
      AppToast.showError(AppTexts.error, AppTexts.createTaskEndBeforeStart);
      return false;
    }
    return true;
  }

  Future<void> onCreateTap() async {
    if (isSubmitting.value) return;
    if (!(formKey.currentState?.validate() ?? false)) return;
    if (!_validateDateTimes()) return;

    _impact();
    isSubmitting.value = true;
    try {
      final schedule = scheduledDate.value!;
      final params = CreateTodayTaskParams(
        title: titleController.text.trim(),
        notes: notesController.text.trim().isEmpty
            ? null
            : notesController.text.trim(),
        scheduledDate: schedule,
        startDateTime: startDateTime.value!,
        endDateTime: endDateTime.value!,
        isRecurring: isRecurring.value,
      );
      await _createTodayTaskUseCase(params);
      if (Get.isRegistered<HomeController>()) {
        await Get.find<HomeController>().loadTodayTasks();
      }
      AppToast.showSuccess(AppTexts.toastTaskCreated);
      await AppAnimationController.offNamed<void>(AppRoutes.todaysTasks);
    } catch (_) {
      AppToast.showError(AppTexts.error, AppTexts.createTaskUnableToCreate);
    } finally {
      isSubmitting.value = false;
    }
  }

  void _impact() {
    if (Get.isRegistered<HapticsController>()) {
      Get.find<HapticsController>().impact();
    }
  }
}
