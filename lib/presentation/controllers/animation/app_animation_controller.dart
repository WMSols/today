import 'package:flutter/animation.dart';
import 'package:get/get.dart';

import 'package:today/presentation/routes/app_pages.dart';
import 'package:today/presentation/routes/app_routes.dart';

/// App-level route transitions and navigation helpers.
class AppAnimationController extends GetxController {
  static const _splashExitTransition = Transition.rightToLeft;
  static const _splashExitDuration = Duration(milliseconds: 400);
  static const _splashExitCurve = Curves.easeInOutCubic;

  GetPage<dynamic>? _pageFor(String name) {
    for (final page in AppPages.pages) {
      if (page.name == name) return page;
    }
    return null;
  }

  /// Clears the stack and opens [MainAppScreen] with [MainAppBinding].
  Future<T?>? offAllToMainApp<T>() => offAllFromSplash<T>(AppRoutes.mainApp);

  /// Replaces the stack after splash with a horizontal slide transition.
  Future<T?>? offAllFromSplash<T>(String routeName) {
    final page = _pageFor(routeName);
    if (page == null) {
      return Get.offAllNamed<T>(routeName);
    }

    return Get.offAll<T>(
      page.page,
      routeName: routeName,
      binding: page.binding,
      transition: _splashExitTransition,
      duration: _splashExitDuration,
      curve: _splashExitCurve,
    );
  }
}
