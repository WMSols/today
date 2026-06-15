import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:today/core/auth/firebase_auth_gateway.dart';
import 'package:today/core/constants/api_constants.dart';
import 'package:today/core/storage/profile_setup_storage.dart';
import 'package:today/core/utils/app_formatter/profile_setup_formatter.dart';
import 'package:today/domain/entities/auth_bootstrap_entity.dart';
import 'package:today/domain/entities/profile_setup_entity.dart';
import 'package:today/presentation/controllers/animation/app_animation_controller.dart';
import 'package:today/presentation/controllers/settings/haptics_controller.dart';
import 'package:today/presentation/controllers/settings/vacation_mode_controller.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/feedback/app_toast.dart';
import 'package:today/domain/repositories/auth_repository.dart';
import 'package:today/presentation/controllers/main/main_app_controller.dart';
import 'package:today/presentation/routes/app_routes.dart';
import 'package:today/presentation/routes/route_arguments.dart';

class SettingsController extends GetxController {
  SettingsController(
    this._authRepository,
    this._firebaseAuthGateway,
    this._profileSetupStorage,
  );

  final AuthRepository _authRepository;
  final FirebaseAuthGateway _firebaseAuthGateway;
  final ProfileSetupStorage _profileSetupStorage;

  final RxBool notificationsEnabled = false.obs;
  final RxBool hasUnreadNotifications = true.obs;
  final RxBool isProfileLoading = false.obs;
  final Rxn<AuthBootstrapEntity> bootstrapUser = Rxn<AuthBootstrapEntity>();
  final profileSetupSummary = ''.obs;

  String get profileName {
    final handle = _profileHandle;
    if (handle == null || handle.isEmpty) return '@guest';
    return '@$handle';
  }

  /// First-name style label for home greeting (e.g. "Alina").
  String get greetingDisplayName {
    final displayName = bootstrapUser.value?.displayName.trim();
    if (displayName != null && displayName.isNotEmpty) {
      return displayName.split(RegExp(r'\s+')).first;
    }
    final firebaseName = FirebaseAuth.instance.currentUser?.displayName?.trim();
    if (firebaseName != null && firebaseName.isNotEmpty) {
      return firebaseName.split(RegExp(r'\s+')).first;
    }
    return AppTexts.homeGreetingGuestName;
  }

  String? get profilePhotoUrl =>
      FirebaseAuth.instance.currentUser?.photoURL?.trim();

  String? get _profileHandle {
    final bootstrap = bootstrapUser.value;
    if (bootstrap != null) {
      final email = bootstrap.email?.trim();
      if (email != null && email.contains('@')) {
        return email.split('@').first.toLowerCase();
      }
      final normalized = bootstrap.displayName.trim().toLowerCase().replaceAll(
        RegExp(r'\s+'),
        '',
      );
      if (normalized.isNotEmpty) return normalized;
    }
    final firebaseEmail = FirebaseAuth.instance.currentUser?.email?.trim();
    if (firebaseEmail != null && firebaseEmail.contains('@')) {
      return firebaseEmail.split('@').first.toLowerCase();
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    loadProfile();
    loadProfileSetupSummary();
  }

  Future<void> loadProfile() async {
    isProfileLoading.value = true;
    try {
      bootstrapUser.value = await _authRepository.getCachedBootstrapUser();
      if (bootstrapUser.value == null && ApiConstants.backendApiEnabled) {
        bootstrapUser.value = await _authRepository.bootstrapUser();
      }
    } catch (_) {
      if (ApiConstants.backendApiEnabled) {
        AppToast.showWarning(AppTexts.profileUnavailableBody);
      }
    } finally {
      isProfileLoading.value = false;
    }
  }

  HapticsController get haptics => Get.find<HapticsController>();

  VacationModeController get vacationMode => Get.find<VacationModeController>();

  Future<void> loadProfileSetupSummary() async {
    final saved = await _profileSetupStorage.loadPreferences();
    final entity = saved ?? ProfileSetupEntity.defaults;
    final officeEndMinutes = saved != null
        ? _profileSetupStorage.decodeOfficeEndMinutes(entity.officeEnd)
        : entity.officeEnd.hour * 60 + entity.officeEnd.minute;
    profileSetupSummary.value = ProfileSetupFormatter.settingsSummary(
      entity,
      officeEndMinutes: officeEndMinutes,
    );
  }

  Future<void> openProfileSetup() async {
    haptics.impact();
    final saved = await AppAnimationController.pushNamed<bool>(
      AppRoutes.profileSetup,
      arguments: {ProfileSetupRouteArgs.mode: ProfileSetupMode.settings},
    );
    await loadProfileSetupSummary();
    if (saved == true) {
      AppToast.showSuccess(AppTexts.settingsProfileSetupSaved);
    }
  }

  void setNotifications(bool value) {
    notificationsEnabled.value = value;
    if (Get.isRegistered<HapticsController>()) {
      Get.find<HapticsController>().impact();
    }
  }

  void openNotifications() {
    hasUnreadNotifications.value = false;
    Get.toNamed(AppRoutes.notifications);
  }

  void openSettingsTab() {
    if (Get.isRegistered<MainAppController>()) {
      Get.find<MainAppController>().selectTab(
        MainAppController.settingsTabIndex,
      );
    }
  }

  Future<void> logout() async {
    await _firebaseAuthGateway.signOut();
    await _authRepository.clearSession();
    AppToast.showSuccess(AppTexts.loggedOutSuccess);
    Get.offAllNamed(AppRoutes.auth);
  }
}
