class AppTexts {
  AppTexts._();

  // App name and version
  static const String appName = "Today";
  static const String appNewName = "todAI";
  static const String appVersion = "Version 1.0.0";

  // Button texts
  static const String login = "Login";
  static const String logout = "Logout";
  static const String submit = "Submit";
  static const String submitting = "Submitting";
  static const String loading = "Loading";
  static const String loggingIn = "Logging in";
  static const String loggingOut = "Logging out";
  static const String gettingStarted = "Getting started";
  static const String getStarted = "Get started";
  static const String continueWithEmail = "Continue with Email";
  static const String confirm = "Confirm";
  static const String cancel = "Cancel";
  static const String save = "Save";
  static const String signUp = "Sign up";
  static const String createAccount = "Create account";
  static const String username = "Username";
  static const String usernameHint = "Enter your username";
  static const String email = "Email";
  static const String emailHint = "Enter your email";
  static const String authOrContinueWith = "Or continue with";
  static const String password = "Password";
  static const String passwordHint = "Enter your password";
  static const String confirmPassword = "Confirm password";
  static const String confirmPasswordHint = "Re-enter your password";
  static const String rememberMe = "Remember me";
  static const String authWelcomeTitle = "Welcome";
  static const String authWelcomeSubtitle =
      "Login or create your account to continue.";

  // Home — dashboard cards
  static String homeAiGeneratedAt(String time) => 'Generated at $time';
  static const String homeAiSummaryLead = ', you completed ';
  static const String homeAiSummaryMid =
      ' of your tasks yesterday. Today\'s focus is on ';
  static const String homeAiSummaryTail = '. AI plan ready.';
  static const String homeViewAiPlan = 'View AI Plan';
  static const String homeDailyPlanNotSetTitle =
      'Daily Plan Is Not Set Completely';
  static const String homeAddGoal = 'Add Goal';
  static const String homeYourProgress = 'Your Progress';
  static const String homeTasksRingLabel = 'TASKS';
  static const String homeAiFocusDefault = 'consistency';

  // Home
  static const String homeGoalEntryHint =
      'Enter a goal you want to achieve ...';
  static String homeGreetingHey(String name) => 'Hey $name,';
  static const String homeGreetingHeyPrefix = 'Hey! ';
  static const String homeGreetingHeySuffix = ',';
  static const String homeGreetingGuestName = 'there';
  static const String greetingMorning = 'Good Morning';
  static const String greetingAfternoon = 'Good Afternoon';
  static const String greetingEvening = 'Good Evening';
  static const String greetingNight = 'Good Night';

  // Planner
  static const String plannerMessageInputHint = 'Type your message...';

  // No data yet
  static const String noDataYet = "No data yet";
  static const String notAvailable = "Not available";

  // Select date time
  static const String selectDateTime = "Select date time";
  static const String selectDate = "Select date";
  static const String selectTime = "Select time";

  // Toast texts
  static const String error = "Error";
  static const String information = "Information";
  static const String warning = "Warning";
  static const String success = "Success";
  static const String noInternet = "No internet connection";
  static const String noInternetDescription =
      "Please check your internet connection and try again.";
  static const String noInternetButton = "Try again";
  static const String noInternetButtonDescription =
      "Please check your internet connection and try again.";

  // Onboarding
  static const String onboardingTaglineBold1 = "Dream big, act small. ";
  static const String onboardingTaglineRegular1 =
      "Turn your long-term ambitions into manageable daily actions.";
  static const String onboardingTaglineBold2 = "Focus on the now. ";
  static const String onboardingTaglineRegular2 =
      "Get a curated list of tasks every morning to keep you on track.";
  static const String onboardingTerms =
      "By clicking 'Get Started,' you confirm that you have read and agree to Today's Terms and Privacy policies.";
  static const String plannerWelcomeMessage =
      "Heyy 👋 and welcome to your daily task planner - Today";
  static const String plannerNamePrompt = "What would you like to be called?";

  // Initial plan funnel
  static const String initialPlanChatWelcome =
      "Heyy 👋 What do you want to achieve?";
  static const String initialPlanChatPrompt =
      "Pick one of the goals below or tell me in your own words.";
  static const String initialPlanCustomGoalHint = "Enter your own goal...";
  static const String initialPlanSkipCta = "Skip";
  static const String initialPlanSeeMoreSnippets = "See more";
  static const String initialPlanSeeLessSnippets = "See less";
  static const List<String> initialPlanGoalSnippets = [
    'Lose weight and get fitter',
    'Wake up earlier',
    'Read more books',
    'Learn a new skill',
    'Save more money',
    'Eat healthier',
    'Exercise consistently',
    'Reduce screen time',
    'Build a morning routine',
    'Improve focus at work',
    'Drink more water',
  ];
  static const String initialPlanAlreadyHaveAccount =
      "Already have an account?";
  static const String planStatusReadyTitle = "Your plan is ready";
  static const String planStatusReadySubtitle =
      "We've prepared your daily tasks based on your goal. Let's get started.";
  static const String planStatusPendingTitle = "Plan setup incomplete";
  static const String planStatusPendingSubtitle =
      "Add a goal anytime from the home screen to unlock your full AI plan.";
  static const String planStatusContinueCta = "Continue";
  static const String planStatusSkipCta = "Skip";

  // Planner
  static const String creatingPlanTitle =
      "Sit back and relax while we set your tasks for you.";
  static const String didYouKnow = "DID YOU KNOW";
  static const String didYouKnowDescription =
      "Your brain uses less energy starting a task than avoiding it.";
  // Goals
  static const String goals = "Goals";
  static const String goalsProgressLabel = 'PROGRESS';
  static const String goalsTotalLabel = 'GOALS';
  static const String goalsCompletedTasksLabel = 'COMPLETED';
  static const String emptyGoalTitle = "This is awkwardly empty.";
  static const String emptyGoalSubtitle =
      "Your future self is waiting - add a goal to get started.";

  // Subscription
  static const String subscriptionTitle = "You've hit your goal limit.";
  static const String subscriptionSubtitle =
      "Upgrade to keep momentum.\nUnlock more goals, smarter scheduling, and full analytics.";
  static const String subscriptionRestore =
      "Restore purchase • Terms • Privacy";
  static const String subscriptionCtaFree = "Current Free Plan";
  static const String subscriptionCtaPro = "Start Pro - \$4.99 / month";
  static const String subscriptionCtaLifetime = "Get Lifetime - \$59.99";
  static const String unlockPro = "UNLOCK PRO";

  static const String subscriptionPlanFreeName = "Free";
  static const String subscriptionPlanFreeSubtitle = "SINGLE GOAL • BASIC AI";
  static const String subscriptionPlanProName = "Pro";
  static const String subscriptionPlanProSubtitle = "\$34.99 / YEAR - SAVE 40%";
  static const String subscriptionPlanLifetimeName = "Lifetime";
  static const String subscriptionPlanLifetimeSubtitle =
      "PAY ONCE. OWN FOREVER";

  static const String subscriptionPriceFree = "\$0";
  static const String subscriptionPriceProMonthly = "\$4.99 / mo";
  static const String subscriptionPriceLifetime = "\$59.99";

  static const List<String> subscriptionFreePerks = [
    "Single active goal with daily tasks",
    "Manual schedule adjustments",
    "Limited AI planning tokens",
  ];
  static const List<String> subscriptionProPerks = [
    "5–10 active goals",
    "Higher AI token limits and plan restructuring",
    "Full calendar integration",
    "Productivity analytics and insights",
  ];
  static const List<String> subscriptionLifetimePerks = [
    "Unlimited goals and AI usage",
    "All Pro features permanently",
    "Priority AI and future premium updates",
  ];

  // Month names
  static const String monthJanuary = "January";
  static const String monthFebruary = "February";
  static const String monthMarch = "March";
  static const String monthApril = "April";
  static const String monthMay = "May";
  static const String monthJune = "June";
  static const String monthJuly = "July";
  static const String monthAugust = "August";
  static const String monthSeptember = "September";
  static const String monthOctober = "October";
  static const String monthNovember = "November";
  static const String monthDecember = "December";

  // Short month names
  static const String monJan = "Jan";
  static const String monFeb = "Feb";
  static const String monMar = "Mar";
  static const String monApr = "Apr";
  static const String monMay = "May";
  static const String monJun = "Jun";
  static const String monJul = "Jul";
  static const String monAug = "Aug";
  static const String monSep = "Sep";
  static const String monOct = "Oct";
  static const String monNov = "Nov";
  static const String monDec = "Dec";

  // Day names
  static const String dayMonday = "Monday";
  static const String dayTuesday = "Tuesday";
  static const String dayWednesday = "Wednesday";
  static const String dayThursday = "Thursday";
  static const String dayFriday = "Friday";
  static const String daySaturday = "Saturday";
  static const String daySunday = "Sunday";

  // Short day names
  static const String dayMon = "Mon";
  static const String dayTue = "Tue";
  static const String dayWed = "Wed";
  static const String dayThu = "Thu";
  static const String dayFri = "Fri";
  static const String daySat = "Sat";
  static const String daySun = "Sun";

  // Period names
  static const String periodAm = "AM";
  static const String periodPm = "PM";

  // Appearance / theme (settings row)
  static const String themeDarkMode = "DARK MODE";
  static const String themeSystem = "System";

  // Bottom navigation
  static const String navHome = "HOME";
  static const String navGoals = "GOALS";
  static const String navAnalytics = "ANALYTICS";
  static const String navSettings = "SETTINGS";

  // Analytics tab
  static const String analyticsTitle = "Analytics";
  static const String analyticsProductivityPercentageTitle =
      "Productivity Percentage";
  static const String analyticsWeeklyConsistencyTitle = "Weekly Consistency";
  static const String analyticsTaskOutcomesTitle = "Task Outcomes";
  static const String analyticsTaskOutcomesPeriodLabel = "This week";
  static const String analyticsTaskOutcomesCompleted = "Completed";
  static const String analyticsTaskOutcomesSkipped = "Skipped";
  static const String analyticsTaskOutcomesPending = "Pending";
  static const String analyticsTaskOutcomesEmpty =
      "No tasks planned yet this week.";
  static const String analyticsWeekAtAGlanceTitle = "Week at a Glance";
  static const String analyticsWeekAtAGlanceAverage = "Average";
  static const String analyticsWeekAtAGlanceBestDay = "Best Day";
  static const String analyticsWeekAtAGlanceOnTrack = "On Track";
  static const String analyticsWeekAtAGlanceEmptyInsight =
      "Your week summary will appear once you have daily progress.";
  static String analyticsWeekAtAGlanceInsight(String day, int percent) =>
      '$day was your lowest day ($percent%). Focus there next.';
  static String analyticsTaskOutcomesPlannedSummary(
    int planned,
    int finished,
  ) => '$planned planned · $finished finished on time';
  static const String analyticsActivityHeatmapTitle = "Activity Heatmap";
  static const String analyticsHeatmapRangeLabel = "Last 12 Months";
  static const String analyticsHeatmapLess = "Less";
  static const String analyticsHeatmapMore = "More";

  // Notifications screen
  static const String notificationsTitle = "Notifications";
  static const String notificationsDescription =
      "Reminder timing and AI nudges will be configured here.";

  // Auth footer
  static const String authFooterPoweredBy = "Powered by ";
  static const String authFooterBrand = "WMSols";
  static const String authFooterTagline = " for your daily growth";

  // Home — active goals
  static const String activeGoalsHeading = "ACTIVE GOALS";
  static const String noActiveGoalsYet = "No active goals yet";

  // Home — FAB menu
  static const String fabAddGoal = "New Goal";
  static const String fabNewTask = "New Task";
  static const String fabRestructureGoal = "Restructure";

  // Create task screen
  static const String createTaskTitle = "New Task";
  static const String createTaskHeading = "Create New Task";
  static const String createTaskScheduleLabel = "Schedule";
  static const String createTaskTitleLabel = "Title";
  static const String createTaskNotesLabel = "Notes";
  static const String createTaskStartTimeLabel = "Start time";
  static const String createTaskEndTimeLabel = "End time";
  static const String createTaskRecurringLabel = "Recurring";
  static const String createTaskRecurringSubtitle =
      "Repeat this task on future days";
  static const String createTaskButton = "Create Task";
  static const String createTaskSchedulePlaceholder = "Select a date";
  static const String createTaskTitleHint = "What do you need to do?";
  static const String createTaskNotesHint = "Add details (optional)";
  static const String createTaskTimePlaceholder = "Select time";
  static const String createTaskTitleRequired = "Title is required";
  static const String createTaskScheduleRequired = "Schedule date is required";
  static const String createTaskStartTimeRequired = "Start time is required";
  static const String createTaskEndTimeRequired = "End time is required";
  static const String createTaskEndBeforeStart =
      "End time must be after start time";
  static const String createTaskSelectScheduleFirst =
      "Select a schedule date first";
  static const String toastTaskCreated = "Task created";
  static const String createTaskUnableToCreate = "Unable to create task";

  // Home — goal entry card
  static const String goalDurationLabel = "GOAL DURATION";
  static const String resetTimeLabel = "RESET TIME";
  static const List<String> goalDurationDropdownOptions = [
    "7 Days",
    "14 Days",
    "30 Days",
    "60 Days",
  ];
  static const List<String> goalResetFrequencyDropdownOptions = [
    "Daily",
    "Weekly",
    "Monthly",
  ];

  // Home — active goal overview (stub / layout)
  static const String activeGoalOverviewDaySample = "DAY 01";
  static const String activeGoalOverviewOutOfSample = "OUT OF 10";
  static const String activeGoalOverviewTasksSample = "0/6 TASKS";
  static const String activeGoalOverviewPercentSample = "0%";
  static const String activeGoalOverviewMotivation =
      "DAY 1 IS ABOUT SHOWING UP - LET'S KEEP IT SIMPLE AND\nBUILD MOMENTUM BACK, YOU'VE GOT THIS!";

  // Home — tasks section
  static const String todaysTasksHeading = "TODAY'S TASKS";
  static const String todaysTasksProgressLabel = 'PROGRESS';
  static const String todaysTasksTotalLabel = 'TOTAL';
  static const String todaysTasksCompletedLabel = 'COMPLETED';
  static const String viewAll = 'View All';

  // Home — default goal title
  static const String goalDefaultTitle = "Goal";

  // Home — calendar
  static const String calendarDaysLeftInYearMiddle = "DAYS LEFT IN";
  static String calendarDaysLeftInYear(int daysLeft, int year) =>
      "$daysLeft $calendarDaysLeftInYearMiddle $year";

  // Settings — controls
  static const String settingsSectionHeading = "SETTINGS";
  static const String settingsHapticsLabel = "HAPTICS";
  static const String settingsHapticsSubtitle = "Tap feedback on actions";
  static const String settingsNotificationsLabel = "NOTIFICATIONS";
  static const String settingsNotificationsSubtitle = "Reminders and nudges";
  static const String settingsVacationModeLabel = "VACATION MODE";
  static const String settingsVacationModeSubtitle =
      "Pause goals & tasks creation temporarily";
  static const String notificationPreferencesLink = "Notification preferences";
  static const String settingsAccentColorLabel = "PALETTE COLOR";
  static const String settingsAccentColorSubtitle = "App accent palette";
  static const String settingsDarkModeSubtitle = "Light or dark appearance";
  static const String settingsAccentClassic = "Classic";
  static const String settingsAccentLavendar = "Lavendar";

  // Settings — profile / session
  static const String profileUnavailableTitle = "Profile unavailable";
  static const String profileUnavailableBody =
      "Unable to load profile details right now.";
  static const String loggedOutSuccess = "Logged out successfully";

  // Home controller — errors & toasts
  static const String homeUnableLoadGoals = "Unable to load goals";
  static const String homeUnableLoadTodayTasks = "Unable to load today tasks";
  static const String homeUnableLoadGoalHistory = "Unable to load goal history";
  static const String homeUnableCompleteTask = "Unable to complete task";
  static const String homeUnableSkipTask = "Unable to skip task";
  static const String homeUnableDeleteGoal = "Unable to delete goal";
  static const String homeUnableCreateGoal = "Unable to create goal";
  static const String toastTaskCompleted = "Task completed";
  static const String toastTaskAlreadyCompleted = "Task already completed";
  static const String toastTaskSkippedTitle = "Task skipped";
  static const String toastTaskAlreadySkipped = "Task already skipped";
  static const String toastGoalDeleted = "Goal deleted";
  static const String toastGoalCreated = "Goal created";
  static const String balanceLabel = "Balance";
  static String taskSkippedBalanceSubtitle(int balance) =>
      "$balanceLabel: $balance";

  // Auth — success toasts
  static const String signedInWithGoogle = "Signed in with Google";
  static const String signedInWithApple = "Signed in with Apple";
  static const String loginSuccessful = "Login successful";
  static const String accountCreatedSuccess = "Account created successfully";

  // Auth — titles
  static const String googleSignInFailedTitle = "Google sign-in failed";
  static const String appleSignInFailedTitle = "Apple sign-in failed";
  static const String appleSignInInfoTitle = "Apple sign-in";
  static const String appleSignInInfoBody =
      "Apple sign-in will be enabled on iOS when you are ready. Use email or Google here.";
  static const String loginFailedTitle = "Login failed";
  static const String signUpFailedTitle = "Sign up failed";
  static const String pleaseTryAgainShort = "Please try again.";

  // Auth — Firebase messages (user-facing)
  static const String firebaseInvalidEmail = "That email address is not valid.";
  static const String firebaseUserDisabled = "This account has been disabled.";
  static const String firebaseIncorrectEmailOrPassword =
      "Incorrect email or password.";
  static const String firebaseEmailAlreadyInUse =
      "An account already exists for this email.";
  static const String firebaseWeakPassword =
      "Password is too weak. Use a stronger password.";
  static const String firebaseNetworkError =
      "Network error. Check your connection.";
  static const String firebaseTooManyRequests =
      "Too many attempts. Try again later.";
  static String firebaseAuthErrorWithCode(String code) =>
      "Authentication error ($code).";

  static const String firebaseMissingUserMessage = "No Firebase user returned.";
  static const String firebaseMissingIdTokenMessage =
      "Could not read Firebase ID token.";

  // Auth — API / Dio resolution
  static const String emailAlreadyInUseTitle = "Email already in use";
  static const String emailAlreadyInUseBody =
      "Sign in or use a different email.";
  static const String invalidCredentialsTitle = "Invalid credentials";
  static const String invalidCredentialsBody = "Check email and password.";
  static const String unauthorizedTitle = "Unauthorized";
  static const String unauthorizedBody = "Invalid email or session.";
  static const String serverNotConfiguredTitle = "Server not configured";
  static const String serverNotConfiguredBody =
      "Add POST /auth/firebase on your API to exchange Firebase ID tokens.";
  static const String authenticationFailedTitle = "Authentication failed";

  // HTTP status messages (API layer)
  static const String httpBadRequest = "Bad request";
  static const String httpUnauthorizedRequest = "Unauthorized request";
  static const String httpForbiddenRequest = "Forbidden request";
  static const String httpResourceNotFound = "Resource not found";
  static const String httpInternalServerError = "Internal server error";
  static const String httpSomethingWentWrong = "Something went wrong";
}
