import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:today/core/init/app_initializer.dart';
import 'package:today/core/utils/app_lotties/app_lotties.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/presentation/controllers/animation/app_animation_controller.dart';
import 'package:today/presentation/routes/app_routes.dart';

class SplashController extends GetxController {
  static const _minDisplay = Duration(seconds: 4);
  static const _maxDisplay = Duration(seconds: 8);
  static const brandAnimationDuration = Duration(seconds: 3);
  static const _brandStagger = 0.11;
  static const _brandLetterWindow = 0.52;
  static const _brandTick = Duration(milliseconds: 16);

  final Completer<void> _animationCompleter = Completer<void>();
  final Completer<void> _initCompleter = Completer<void>();

  final Rx<LottieComposition?> lottieComposition = Rx<LottieComposition?>(null);
  final brandRevealProgress = 0.0.obs;

  final List<String> brandCharacters = AppTexts.appNewName.split('');

  Timer? _brandRevealTimer;

  double brandLetterProgress(int index) {
    final start = index * _brandStagger;
    final end = start + _brandLetterWindow;
    final value = brandRevealProgress.value;
    if (value <= start) return 0;
    if (value >= end) return 1;
    return Curves.easeOutCubic.transform((value - start) / (end - start));
  }

  void onBrandAnimationComplete() {
    if (!_animationCompleter.isCompleted) {
      _animationCompleter.complete();
    }
  }

  @override
  void onInit() {
    super.onInit();
    _startBrandRevealAnimation();

    AssetLottie(AppLotties.splash).load().then((composition) {
      lottieComposition.value = composition;
    });

    unawaited(_bootstrap());
    unawaited(_runSplashSequence());
  }

  @override
  void onReady() {
    super.onReady();
    FlutterNativeSplash.remove();
  }

  @override
  void onClose() {
    _brandRevealTimer?.cancel();
    super.onClose();
  }

  void _startBrandRevealAnimation() {
    final started = DateTime.now();
    _brandRevealTimer = Timer.periodic(_brandTick, (_) {
      final elapsed = DateTime.now().difference(started);
      final progress =
          elapsed.inMilliseconds / brandAnimationDuration.inMilliseconds;

      if (progress >= 1) {
        brandRevealProgress.value = 1;
        _brandRevealTimer?.cancel();
        onBrandAnimationComplete();
        return;
      }

      brandRevealProgress.value = progress;
    });
  }

  Future<void> _runSplashSequence() async {
    final stopwatch = Stopwatch()..start();

    try {
      await Future.wait<void>([
        _animationCompleter.future,
        _initCompleter.future,
        _waitForLottie(),
      ]).timeout(_maxDisplay);
    } on TimeoutException {
      // Proceed so splash never blocks indefinitely.
    }

    final remaining = _minDisplay - stopwatch.elapsed;
    if (remaining > Duration.zero) {
      await Future<void>.delayed(remaining);
    }

    if (Get.currentRoute == AppRoutes.splash) {
      await Get.find<AppAnimationController>().offAllFromSplash<void>(
        AppInitializer.initialRoute,
      );
    }
  }

  Future<void> _waitForLottie() async {
    if (lottieComposition.value != null) return;
    await lottieComposition.stream.firstWhere((c) => c != null);
  }

  Future<void> _bootstrap() async {
    try {
      await AppInitializer.init();
    } catch (_) {
      AppInitializer.initialRoute = AppRoutes.onboarding;
    } finally {
      if (!_initCompleter.isCompleted) {
        _initCompleter.complete();
      }
    }
  }
}
