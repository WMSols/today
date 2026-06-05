import 'package:shared_preferences/shared_preferences.dart';
import 'package:today/core/constants/storage_keys.dart';

/// Local state for the pre-auth initial plan funnel and plan status gate.
class InitialPlanStorage {
  InitialPlanStorage(this._prefs);

  final SharedPreferences _prefs;

  Future<bool> hasCompletedOnboarding() async {
    return _prefs.getBool(StorageKeys.hasCompletedOnboarding) ?? false;
  }

  Future<void> setOnboardingCompleted() async {
    await _prefs.setBool(StorageKeys.hasCompletedOnboarding, true);
  }

  Future<bool> hasCompletedInitialPlanFlow() async {
    return _prefs.getBool(StorageKeys.hasCompletedInitialPlanFlow) ?? false;
  }

  Future<void> setInitialPlanFlowCompleted() async {
    await _prefs.setBool(StorageKeys.hasCompletedInitialPlanFlow, true);
  }

  Future<bool> hasSeenPlanStatusGate() async {
    return _prefs.getBool(StorageKeys.hasSeenPlanStatusGate) ?? false;
  }

  Future<void> setPlanStatusGateSeen() async {
    await _prefs.setBool(StorageKeys.hasSeenPlanStatusGate, true);
  }

  Future<String?> getPendingGoalText() async {
    final value = _prefs.getString(StorageKeys.pendingInitialGoalText);
    if (value == null || value.trim().isEmpty) return null;
    return value.trim();
  }

  Future<void> savePendingGoalDraft({
    required String goalText,
    String? duration,
    String? resetTime,
  }) async {
    await _prefs.setString(StorageKeys.pendingInitialGoalText, goalText.trim());
    if (duration != null) {
      await _prefs.setString(StorageKeys.pendingInitialGoalDuration, duration);
    }
    if (resetTime != null) {
      await _prefs.setString(
        StorageKeys.pendingInitialGoalResetTime,
        resetTime,
      );
    }
  }

  Future<void> clearPendingGoalDraft() async {
    await _prefs.remove(StorageKeys.pendingInitialGoalText);
    await _prefs.remove(StorageKeys.pendingInitialGoalDuration);
    await _prefs.remove(StorageKeys.pendingInitialGoalResetTime);
  }

  Future<({String? duration, String? resetTime})>
  getPendingGoalOptions() async {
    return (
      duration: _prefs.getString(StorageKeys.pendingInitialGoalDuration),
      resetTime: _prefs.getString(StorageKeys.pendingInitialGoalResetTime),
    );
  }

  /// Marks funnel done and clears any draft (skip / social shortcut).
  Future<void> skipInitialPlanDraft() async {
    await clearPendingGoalDraft();
    await setInitialPlanFlowCompleted();
  }
}
