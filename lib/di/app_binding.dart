import 'package:get/get.dart';

import 'package:today/core/auth/firebase_auth_gateway.dart';
import 'package:today/core/auth/firebase_token_provider.dart';
import 'package:today/core/network/connectivity_service.dart';
import 'package:today/core/network/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:today/core/storage/initial_plan_storage.dart';
import 'package:today/core/storage/profile_setup_storage.dart';
import 'package:today/core/storage/calendar_cache_storage.dart';
import 'package:today/core/storage/calendar_chat_history_storage.dart';
import 'package:today/core/storage/session_storage.dart';
import 'package:today/data/datasources/remote/calendar_remote_data_source.dart';
import 'package:today/data/repositories/calendar_repository_impl.dart';
import 'package:today/domain/repositories/calendar_repository.dart';
import 'package:today/domain/usecases/create_calendar_event_usecase.dart';
import 'package:today/domain/usecases/delete_calendar_event_usecase.dart';
import 'package:today/domain/usecases/get_calendar_agenda_usecase.dart';
import 'package:today/domain/usecases/send_calendar_chat_message_usecase.dart';
import 'package:today/domain/usecases/update_calendar_event_usecase.dart';
import 'package:today/data/datasources/local/goal_local_data_source.dart';
import 'package:today/data/datasources/local/subscription_local_data_source.dart';
import 'package:today/data/datasources/remote/planner_remote_data_source.dart';
import 'package:today/data/datasources/remote/auth_remote_data_source.dart';
import 'package:today/data/datasources/remote/active_goal_remote_data_source.dart';
import 'package:today/data/datasources/remote/analytics_remote_data_source.dart';
import 'package:today/data/datasources/remote/home_daily_calendar_remote_data_source.dart';
import 'package:today/data/datasources/remote/home_today_tasks_remote_data_source.dart';
import 'package:today/data/repositories/home_today_tasks_repository_impl.dart';
import 'package:today/domain/repositories/home_today_tasks_repository.dart';
import 'package:today/domain/usecases/create_today_task_usecase.dart';
import 'package:today/domain/usecases/get_home_today_tasks_usecase.dart';
import 'package:today/data/repositories/active_goal_repository_impl.dart';
import 'package:today/data/repositories/analytics_repository_impl.dart';
import 'package:today/data/repositories/home_daily_calendar_repository_impl.dart';
import 'package:today/data/repositories/auth_repository_impl.dart';
import 'package:today/data/repositories/goal_repository_impl.dart';
import 'package:today/data/repositories/planner_repository_impl.dart';
import 'package:today/data/repositories/subscription_repository_impl.dart';
import 'package:today/domain/repositories/active_goal_repository.dart';
import 'package:today/domain/repositories/analytics_repository.dart';
import 'package:today/domain/repositories/home_daily_calendar_repository.dart';
import 'package:today/domain/repositories/auth_repository.dart';
import 'package:today/domain/repositories/goal_repository.dart';
import 'package:today/domain/repositories/planner_repository.dart';
import 'package:today/domain/repositories/subscription_repository.dart';
import 'package:today/domain/usecases/bootstrap_user_usecase.dart';
import 'package:today/domain/usecases/check_health_usecase.dart';
import 'package:today/domain/usecases/get_auth_config_usecase.dart';
import 'package:today/domain/usecases/get_active_goal_tasks_usecase.dart';
import 'package:today/domain/usecases/get_goal_cards_usecase.dart';
import 'package:today/domain/usecases/get_subscription_plans_usecase.dart';
import 'package:today/domain/usecases/get_today_plan_usecase.dart';
import 'package:today/domain/usecases/get_goal_history_usecase.dart';
import 'package:today/domain/usecases/create_goal_usecase.dart';
import 'package:today/domain/usecases/complete_task_usecase.dart';
import 'package:today/domain/usecases/skip_task_usecase.dart';
import 'package:today/domain/usecases/delete_goal_usecase.dart';
import 'package:today/domain/usecases/get_analytics_dashboard_usecase.dart';
import 'package:today/domain/usecases/get_weekly_calendar_usecase.dart';
import 'package:today/domain/usecases/save_goal_usecase.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.isRegistered<SharedPreferences>()) {
      Get.put<InitialPlanStorage>(
        InitialPlanStorage(Get.find<SharedPreferences>()),
        permanent: true,
      );
      Get.put<ProfileSetupStorage>(
        ProfileSetupStorage(Get.find<SharedPreferences>()),
        permanent: true,
      );
      Get.put<CalendarChatHistoryStorage>(
        CalendarChatHistoryStorage(Get.find<SharedPreferences>()),
        permanent: true,
      );
    }
    final sessionStorage = SessionStorage();
    Get.put<SessionStorage>(sessionStorage, permanent: true);
    Get.lazyPut<FirebaseAuthGateway>(() => FirebaseAuthGateway(), fenix: true);
    Get.put<FirebaseTokenProvider>(FirebaseTokenProvider(), permanent: true);
    final dio = DioClient.instanceWith(
      tokenProvider: Get.find<FirebaseTokenProvider>(),
    );
    Get.put<ConnectivityService>(ConnectivityService(), permanent: true);
    // Data sources
    Get.lazyPut<GoalLocalDataSource>(GoalLocalDataSource.new, fenix: true);
    Get.lazyPut<SubscriptionLocalDataSource>(
      SubscriptionLocalDataSource.new,
      fenix: true,
    );
    Get.lazyPut<PlannerRemoteDataSource>(
      () => PlannerRemoteDataSource(dio),
      fenix: true,
    );
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(dio),
      fenix: true,
    );
    Get.lazyPut<ActiveGoalRemoteDataSource>(
      () => ActiveGoalRemoteDataSource(dio),
      fenix: true,
    );
    Get.lazyPut<AnalyticsRemoteDataSource>(
      AnalyticsRemoteDataSource.new,
      fenix: true,
    );
    Get.lazyPut<HomeDailyCalendarRemoteDataSource>(
      HomeDailyCalendarRemoteDataSource.new,
      fenix: true,
    );
    Get.lazyPut<HomeTodayTasksRemoteDataSource>(
      HomeTodayTasksRemoteDataSource.new,
      fenix: true,
    );
    Get.lazyPut<CalendarRemoteDataSource>(
      () => CalendarRemoteDataSource(dio),
      fenix: true,
    );
    Get.put<CalendarCacheStorage>(CalendarCacheStorage(), permanent: true);

    // Repositories
    Get.lazyPut<GoalRepository>(
      () => GoalRepositoryImpl(Get.find<GoalLocalDataSource>()),
      fenix: true,
    );
    Get.lazyPut<PlannerRepository>(
      () => PlannerRepositoryImpl(Get.find<PlannerRemoteDataSource>()),
      fenix: true,
    );
    Get.lazyPut<SubscriptionRepository>(
      () => SubscriptionRepositoryImpl(Get.find<SubscriptionLocalDataSource>()),
      fenix: true,
    );
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        Get.find<AuthRemoteDataSource>(),
        Get.find<SessionStorage>(),
      ),
      fenix: true,
    );
    Get.lazyPut<ActiveGoalRepository>(
      () => ActiveGoalRepositoryImpl(Get.find<ActiveGoalRemoteDataSource>()),
      fenix: true,
    );
    Get.lazyPut<AnalyticsRepository>(
      () => AnalyticsRepositoryImpl(Get.find<AnalyticsRemoteDataSource>()),
      fenix: true,
    );
    Get.lazyPut<CalendarRepository>(
      () => CalendarRepositoryImpl(
        Get.find<CalendarRemoteDataSource>(),
        Get.find<CalendarCacheStorage>(),
      ),
      fenix: true,
    );
    Get.lazyPut<HomeDailyCalendarRepository>(
      () => HomeDailyCalendarRepositoryImpl(
        Get.find<HomeDailyCalendarRemoteDataSource>(),
        Get.find<CalendarRepository>(),
      ),
      fenix: true,
    );
    Get.lazyPut<HomeTodayTasksRepository>(
      () => HomeTodayTasksRepositoryImpl(
        Get.find<HomeTodayTasksRemoteDataSource>(),
        Get.find<CalendarRepository>(),
      ),
      fenix: true,
    );

    // Use cases
    Get.lazyPut<GetTodayPlanUseCase>(
      () => GetTodayPlanUseCase(Get.find<PlannerRepository>()),
      fenix: true,
    );
    Get.lazyPut<SaveGoalUseCase>(
      () => SaveGoalUseCase(Get.find<GoalRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetSubscriptionPlansUseCase>(
      () => GetSubscriptionPlansUseCase(Get.find<SubscriptionRepository>()),
      fenix: true,
    );
    Get.lazyPut<BootstrapUserUseCase>(
      () => BootstrapUserUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetAuthConfigUseCase>(
      () => GetAuthConfigUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );
    Get.lazyPut<CheckHealthUseCase>(
      () => CheckHealthUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );
    Get.lazyPut<SendCalendarChatMessageUseCase>(
      () => SendCalendarChatMessageUseCase(Get.find<CalendarRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetCalendarAgendaUseCase>(
      () => GetCalendarAgendaUseCase(Get.find<CalendarRepository>()),
      fenix: true,
    );
    Get.lazyPut<CreateCalendarEventUseCase>(
      () => CreateCalendarEventUseCase(Get.find<CalendarRepository>()),
      fenix: true,
    );
    Get.lazyPut<UpdateCalendarEventUseCase>(
      () => UpdateCalendarEventUseCase(Get.find<CalendarRepository>()),
      fenix: true,
    );
    Get.lazyPut<DeleteCalendarEventUseCase>(
      () => DeleteCalendarEventUseCase(Get.find<CalendarRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetGoalCardsUseCase>(
      () => GetGoalCardsUseCase(Get.find<ActiveGoalRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetActiveGoalTasksUseCase>(
      () => GetActiveGoalTasksUseCase(Get.find<ActiveGoalRepository>()),
      fenix: true,
    );
    Get.lazyPut<CreateGoalUseCase>(
      () => CreateGoalUseCase(Get.find<ActiveGoalRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetGoalHistoryUseCase>(
      () => GetGoalHistoryUseCase(Get.find<ActiveGoalRepository>()),
      fenix: true,
    );
    Get.lazyPut<CompleteTaskUseCase>(
      () => CompleteTaskUseCase(Get.find<ActiveGoalRepository>()),
      fenix: true,
    );
    Get.lazyPut<SkipTaskUseCase>(
      () => SkipTaskUseCase(Get.find<ActiveGoalRepository>()),
      fenix: true,
    );
    Get.lazyPut<DeleteGoalUseCase>(
      () => DeleteGoalUseCase(Get.find<ActiveGoalRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetAnalyticsDashboardUseCase>(
      () => GetAnalyticsDashboardUseCase(Get.find<AnalyticsRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetWeeklyCalendarUseCase>(
      () => GetWeeklyCalendarUseCase(Get.find<HomeDailyCalendarRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetHomeTodayTasksUseCase>(
      () => GetHomeTodayTasksUseCase(Get.find<HomeTodayTasksRepository>()),
      fenix: true,
    );
    Get.lazyPut<CreateTodayTaskUseCase>(
      () => CreateTodayTaskUseCase(Get.find<HomeTodayTasksRepository>()),
      fenix: true,
    );
  }
}
