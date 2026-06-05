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
}
