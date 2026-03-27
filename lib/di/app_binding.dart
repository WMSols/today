import 'package:get/get.dart';

import 'package:today/core/network/connectivity_service.dart';
import 'package:today/core/network/dio_client.dart';
import 'package:today/data/datasources/local/active_goal_local_data_source.dart';
import 'package:today/data/datasources/local/goal_local_data_source.dart';
import 'package:today/data/datasources/local/subscription_local_data_source.dart';
import 'package:today/data/datasources/remote/planner_remote_data_source.dart';
import 'package:today/data/repositories/active_goal_repository_impl.dart';
import 'package:today/data/repositories/goal_repository_impl.dart';
import 'package:today/data/repositories/planner_repository_impl.dart';
import 'package:today/data/repositories/subscription_repository_impl.dart';
import 'package:today/domain/repositories/active_goal_repository.dart';
import 'package:today/domain/repositories/goal_repository.dart';
import 'package:today/domain/repositories/planner_repository.dart';
import 'package:today/domain/repositories/subscription_repository.dart';
import 'package:today/domain/usecases/get_active_goal_tasks_usecase.dart';
import 'package:today/domain/usecases/get_goal_cards_usecase.dart';
import 'package:today/domain/usecases/get_subscription_plans_usecase.dart';
import 'package:today/domain/usecases/get_today_plan_usecase.dart';
import 'package:today/domain/usecases/save_goal_usecase.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    final dio = DioClient.instanceWith();
    Get.put<ConnectivityService>(ConnectivityService(), permanent: true);

    // Data sources
    Get.lazyPut<GoalLocalDataSource>(GoalLocalDataSource.new, fenix: true);
    Get.lazyPut<SubscriptionLocalDataSource>(
      SubscriptionLocalDataSource.new,
      fenix: true,
    );
    Get.lazyPut<ActiveGoalLocalDataSource>(
      ActiveGoalLocalDataSource.new,
      fenix: true,
    );
    Get.lazyPut<PlannerRemoteDataSource>(
      () => PlannerRemoteDataSource(dio),
      fenix: true,
    );

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
    Get.lazyPut<ActiveGoalRepository>(
      () => ActiveGoalRepositoryImpl(Get.find<ActiveGoalLocalDataSource>()),
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
    Get.lazyPut<GetGoalCardsUseCase>(
      () => GetGoalCardsUseCase(Get.find<ActiveGoalRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetActiveGoalTasksUseCase>(
      () => GetActiveGoalTasksUseCase(Get.find<ActiveGoalRepository>()),
      fenix: true,
    );
  }
}
