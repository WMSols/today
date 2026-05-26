import 'package:flutter/animation.dart';
import 'package:get/get.dart';

import 'package:today/presentation/routes/app_pages.dart';
import 'package:today/presentation/routes/app_routes.dart';

/// App-level route transitions and navigation helpers.
class AppAnimationController extends GetxController {
  /// Push: new screen enters from the right; pop reverses (exits to the right).
  static const pushTransition = Transition.rightToLeft;
  static const pushDuration = Duration(milliseconds: 400);
  static const pushCurve = Curves.easeInOutCubic;

  static GetPage<dynamic>? pageFor(String name) {
    for (final page in AppPages.pages) {
      if (page.name == name) return page;
    }
    return null;
  }

  /// Horizontal slide push (e.g. detail screens opened from home).
  static Future<T?>? pushNamed<T>(String routeName, {dynamic arguments}) {
    final page = pageFor(routeName);
    if (page == null) {
      return Get.toNamed<T>(routeName, arguments: arguments);
    }

    return Get.to<T>(
      page.page,
      routeName: routeName,
      binding: page.binding,
      arguments: arguments,
      transition: pushTransition,
      duration: pushDuration,
      curve: pushCurve,
    );
  }

  /// Clears the stack and opens [MainAppScreen] with [MainAppBinding].
  Future<T?>? offAllToMainApp<T>() => offAllFromSplash<T>(AppRoutes.mainApp);

  /// Replaces the stack after splash with a horizontal slide transition.
  Future<T?>? offAllFromSplash<T>(String routeName) {
    final page = pageFor(routeName);
    if (page == null) {
      return Get.offAllNamed<T>(routeName);
    }

    return Get.offAll<T>(
      page.page,
      routeName: routeName,
      binding: page.binding,
      transition: pushTransition,
      duration: pushDuration,
      curve: pushCurve,
    );
  }
}
