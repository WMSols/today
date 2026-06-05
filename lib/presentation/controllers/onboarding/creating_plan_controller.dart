import 'dart:async';

import 'package:get/get.dart';

import 'package:today/core/storage/initial_plan_storage.dart';
import 'package:today/presentation/routes/app_routes.dart';
import 'package:today/presentation/routes/route_arguments.dart';

class CreatingPlanController extends GetxController {
  CreatingPlanController(this._storage, {required this.flow});

  final InitialPlanStorage _storage;
  final CreatingPlanFlow flow;

  static const initialFlowDelay = Duration(seconds: 5);

  bool get isInitialFlow => flow == CreatingPlanFlow.initial;

  static CreatingPlanFlow flowFromArguments(dynamic args) {
    if (args is Map &&
        args[CreatingPlanRouteArgs.flow] == CreatingPlanFlow.initial.name) {
      return CreatingPlanFlow.initial;
    }
    return CreatingPlanFlow.planner;
  }

  @override
  void onInit() {
    super.onInit();
    if (isInitialFlow) {
      unawaited(_runInitialFlow());
    }
  }

  Future<void> _runInitialFlow() async {
    await Future<void>.delayed(initialFlowDelay);
    if (isClosed) return;
    await _storage.setInitialPlanFlowCompleted();
    if (isClosed) return;
    await Get.offAllNamed<void>(
      AppRoutes.auth,
      arguments: {AuthRouteArgs.openSignup: true},
    );
  }
}
