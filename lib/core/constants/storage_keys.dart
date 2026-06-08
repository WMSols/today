/// Keys for local persistence (SharedPreferences).
class StorageKeys {
  StorageKeys._();

  static const String savedLoginEmail = 'saved_login_email';
  static const String savedLoginPassword = 'saved_login_password';

  static const String hasCompletedOnboarding = 'has_completed_onboarding';
  static const String hasCompletedInitialPlanFlow =
      'has_completed_initial_plan_flow';
  static const String hasSeenPlanStatusGate = 'has_seen_plan_status_gate';
  static const String pendingInitialGoalText = 'pending_initial_goal_text';
  static const String pendingInitialGoalDuration =
      'pending_initial_goal_duration';
  static const String pendingInitialGoalResetTime =
      'pending_initial_goal_reset_time';

  static const String hasCompletedProfileSetup = 'has_completed_profile_setup';
  static const String profileSetupWakeTime = 'profile_setup_wake_time';
  static const String profileSetupBedTime = 'profile_setup_bed_time';
  static const String profileSetupOfficeStart = 'profile_setup_office_start';
  static const String profileSetupOfficeEnd = 'profile_setup_office_end';
  static const String profileSetupWorkoutWindow =
      'profile_setup_workout_window';
  static const String profileSetupDeepWork = 'profile_setup_deep_work';
}
