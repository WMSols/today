import 'package:get/get.dart';
import 'package:today/core/widgets/feedback/app_toast.dart';
import 'package:today/domain/entities/me_entity.dart';
import 'package:today/domain/repositories/auth_repository.dart';
import 'package:today/domain/usecases/get_me_usecase.dart';
import 'package:today/presentation/routes/app_routes.dart';

class SettingsController extends GetxController {
  SettingsController(this._getMeUseCase, this._authRepository);

  final GetMeUseCase _getMeUseCase;
  final AuthRepository _authRepository;

  final RxBool hapticsEnabled = true.obs;
  final RxBool notificationsEnabled = false.obs;
  final RxBool isProfileLoading = false.obs;
  final Rxn<MeEntity> me = Rxn<MeEntity>();

  String get profileName {
    final username = me.value?.user.username.trim().toLowerCase();
    if (username == null || username.isEmpty) return '@guest';
    return '@$username';
  }
  String get gemsCount => '${me.value?.wallet.balance ?? 0}';
  String get streakCount => '0';

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
        'Profile unavailable',
        'Unable to load profile details right now.',
      );
    } finally {
      isProfileLoading.value = false;
    }
  }

  void setHaptics(bool value) {
    hapticsEnabled.value = value;
  }

  void setNotifications(bool value) {
    notificationsEnabled.value = value;
  }

  void openClaimRewards() {
    Get.toNamed(AppRoutes.claimRewards);
  }

  void openSubscription() {
    Get.toNamed(AppRoutes.subscription);
  }

  Future<void> logout() async {
    await _authRepository.clearSession();
    AppToast.showSuccess('Logged out successfully');
    Get.offAllNamed(AppRoutes.onboarding);
  }
}
