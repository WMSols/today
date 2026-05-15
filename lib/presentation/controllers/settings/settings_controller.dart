import 'package:get/get.dart';
import 'package:today/core/auth/firebase_auth_gateway.dart';
import 'package:today/presentation/controllers/settings/haptics_controller.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/feedback/app_toast.dart';
import 'package:today/domain/entities/me_entity.dart';
import 'package:today/domain/repositories/auth_repository.dart';
import 'package:today/domain/usecases/get_me_usecase.dart';
import 'package:today/presentation/routes/app_routes.dart';

class SettingsController extends GetxController {
  SettingsController(
    this._getMeUseCase,
    this._authRepository,
    this._firebaseAuthGateway,
  );

  final GetMeUseCase _getMeUseCase;
  final AuthRepository _authRepository;
  final FirebaseAuthGateway _firebaseAuthGateway;

  final RxBool notificationsEnabled = false.obs;
  final RxBool isProfileLoading = false.obs;
  final Rxn<MeEntity> me = Rxn<MeEntity>();

  String get profileName {
    final username = me.value?.user.username.trim().toLowerCase();
    if (username == null || username.isEmpty) return '@guest';
    return '@$username';
  }

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    isProfileLoading.value = true;
    try {
      me.value = await _getMeUseCase();
    } catch (_) {
      AppToast.showWarning(
        AppTexts.profileUnavailableTitle,
        AppTexts.profileUnavailableBody,
      );
    } finally {
      isProfileLoading.value = false;
    }
  }

  HapticsController get haptics => Get.find<HapticsController>();

  void setNotifications(bool value) {
    notificationsEnabled.value = value;
    if (Get.isRegistered<HapticsController>()) {
      Get.find<HapticsController>().impact();
    }
  }

  void openNotifications() {
    Get.toNamed(AppRoutes.notifications);
  }

  void openSubscription() {
    Get.toNamed(AppRoutes.subscription);
  }

  Future<void> logout() async {
    await _firebaseAuthGateway.signOut();
    await _authRepository.clearSession();
    AppToast.showSuccess(AppTexts.loggedOutSuccess);
    Get.offAllNamed(AppRoutes.onboarding);
  }
}
