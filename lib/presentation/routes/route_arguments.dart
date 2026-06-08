/// GetX route argument keys shared across the initial-plan funnel.
abstract class AuthRouteArgs {
  static const openSignup = 'openSignup';
  static const openLogin = 'openLogin';
}

abstract class CreatingPlanRouteArgs {
  static const flow = 'flow';
}

enum CreatingPlanFlow { initial, planner }

enum ProfileSetupMode { onboarding, settings }

abstract class ProfileSetupRouteArgs {
  static const mode = 'mode';
}
