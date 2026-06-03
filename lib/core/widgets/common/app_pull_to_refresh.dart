import 'dart:async' show unawaited;

import 'package:flutter/material.dart';

import 'package:today/core/theme/app_accent_color.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/widgets/feedback/app_refresh_indicator.dart';
import 'package:today/core/widgets/feedback/app_refresh_progress_bar.dart';

/// Pull-to-refresh: Lottie while pulling; thin lavender line while loading.
///
/// [child] must be a scrollable with [BouncingScrollPhysics] and
/// [AlwaysScrollableScrollPhysics].
class AppPullToRefresh extends StatefulWidget {
  const AppPullToRefresh({
    super.key,
    required this.onRefresh,
    required this.child,
    this.triggerDistance,
    this.refreshingBarHeight,
    this.maxPullDistance,
    this.indicatorSize,
    this.headerTransitionDuration,
  });

  final Future<void> Function() onRefresh;
  final Widget child;
  final double? triggerDistance;
  final double? refreshingBarHeight;
  final double? maxPullDistance;
  final double? indicatorSize;
  final Duration? headerTransitionDuration;

  @override
  State<AppPullToRefresh> createState() => _AppPullToRefreshState();
}

class _AppPullToRefreshState extends State<AppPullToRefresh>
    with SingleTickerProviderStateMixin {
  static const Duration _snapDuration = Duration(milliseconds: 320);
  static const Curve _snapCurve = Curves.easeOutCubic;

  late final AnimationController _snapController;
  late final Animation<double> _snapAnimation;
  double _offset = 0;
  double _snapBegin = 0;
  double _snapEnd = 0;
  double _maxPullExtent = 0;
  bool _isRefreshing = false;
  bool _scrollEndInProgress = false;

  @override
  void initState() {
    super.initState();
    _snapController = AnimationController(vsync: this, duration: _snapDuration);
    _snapAnimation = CurvedAnimation(parent: _snapController, curve: _snapCurve)
      ..addListener(_onSnapTick);
  }

  @override
  void dispose() {
    _snapController.dispose();
    super.dispose();
  }

  Duration get _headerTransitionDuration =>
      widget.headerTransitionDuration ?? const Duration(milliseconds: 260);

  double _triggerDistance(BuildContext context) =>
      widget.triggerDistance ?? AppResponsive.scaleSize(context, 72);

  double _refreshingBarHeight(BuildContext context) =>
      widget.refreshingBarHeight ?? AppResponsive.scaleSize(context, 3);

  double _maxPullDistance(BuildContext context) =>
      widget.maxPullDistance ?? AppResponsive.scaleSize(context, 120);

  double get _displayOffset => _snapController.isAnimating
      ? _snapBegin + (_snapEnd - _snapBegin) * _snapAnimation.value
      : _offset;

  bool get _useHoldTranslate => _isRefreshing || _snapController.isAnimating;

  Color get _refreshBackground => AppAccentColor.lavendar.color;

  void _onSnapTick() {
    if (_snapController.isAnimating) {
      setState(() {});
    }
  }

  Future<void> _animateTo(double target) async {
    if ((target - _offset).abs() < 0.5) {
      setState(() => _offset = target);
      return;
    }
    _snapBegin = _offset;
    _snapEnd = target;
    _snapController.reset();
    await _snapController.forward();
    if (!mounted) return;
    setState(() => _offset = target);
  }

  double _pullOffsetFromMetrics(ScrollMetrics metrics) {
    if (metrics.pixels > 0) return 0;
    return (-metrics.pixels).clamp(0.0, _maxPullDistance(context));
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (_isRefreshing) return false;

    if (notification is ScrollStartNotification) {
      _maxPullExtent = 0;
      return false;
    }

    if (notification is ScrollUpdateNotification ||
        notification is OverscrollNotification) {
      final pull = _pullOffsetFromMetrics(notification.metrics);
      if (pull > _maxPullExtent) {
        _maxPullExtent = pull;
      }
      if (pull != _offset) {
        setState(() => _offset = pull);
      }
      return false;
    }

    if (notification is ScrollEndNotification) {
      unawaited(_onScrollEnd());
      return false;
    }

    return false;
  }

  Future<void> _onScrollEnd() async {
    if (_isRefreshing || _scrollEndInProgress) return;
    _scrollEndInProgress = true;

    try {
      final trigger = _triggerDistance(context);
      final releaseExtent = _maxPullExtent > _offset ? _maxPullExtent : _offset;

      if (releaseExtent >= trigger) {
        await _startRefresh();
      } else if (_offset > 0) {
        await _animateTo(0);
      }
    } finally {
      _maxPullExtent = 0;
      _scrollEndInProgress = false;
    }
  }

  Future<void> _startRefresh() async {
    if (_isRefreshing) return;
    setState(() => _isRefreshing = true);

    final barHeight = _refreshingBarHeight(context);
    await _animateTo(barHeight);

    try {
      await widget.onRefresh();
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
        await _animateTo(0);
      }
    }
  }

  Widget _buildScrollChild(BuildContext context) {
    final scrollChild = NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Material(
        type: MaterialType.transparency,
        color: Colors.transparent,
        child: widget.child,
      ),
    );

    if (!_useHoldTranslate) {
      return scrollChild;
    }

    return Transform.translate(
      offset: Offset(0, _displayOffset),
      child: scrollChild,
    );
  }

  Widget _headerTransition(Widget child, Animation<double> animation) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.12),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }

  Widget _buildPullHeader({
    required double indicatorOpacity,
    required double indicatorScale,
  }) {
    final easedOpacity = Curves.easeOut.transform(
      indicatorOpacity.clamp(0.0, 1.0),
    );
    return ColoredBox(
      color: _refreshBackground,
      child: SizedBox(
        width: double.infinity,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Opacity(
            opacity: easedOpacity,
            child: Transform.scale(
              scale: indicatorScale,
              child: AppRefreshIndicator(size: widget.indicatorSize ?? 40),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRefreshingHeader() {
    return SizedBox(
      width: double.infinity,
      child: const Align(
        alignment: Alignment.bottomCenter,
        child: AppRefreshProgressBar(),
      ),
    );
  }

  Widget _buildHeaderContent({
    required double indicatorOpacity,
    required double indicatorScale,
  }) {
    return AnimatedSwitcher(
      duration: _headerTransitionDuration,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          fit: StackFit.expand,
          alignment: Alignment.bottomCenter,
          children: [...previousChildren, ?currentChild],
        );
      },
      transitionBuilder: _headerTransition,
      child: _isRefreshing
          ? KeyedSubtree(
              key: const ValueKey<String>('refreshing_header'),
              child: _buildRefreshingHeader(),
            )
          : KeyedSubtree(
              key: const ValueKey<String>('pull_header'),
              child: _buildPullHeader(
                indicatorOpacity: indicatorOpacity,
                indicatorScale: indicatorScale,
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayOffset = _displayOffset;
    final topInset = MediaQuery.paddingOf(context).top;
    final backgroundHeight = displayOffset + topInset;
    final trigger = _triggerDistance(context);
    final pullProgress = (displayOffset / trigger).clamp(0.0, 1.0);
    final indicatorOpacity = pullProgress;
    final indicatorScale = 0.5 + (0.5 * pullProgress);
    final headerFadeOpacity = _isRefreshing
        ? 1.0
        : (displayOffset / AppResponsive.scaleSize(context, 20)).clamp(
            0.0,
            1.0,
          );
    final showHeader = displayOffset > 0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (showHeader)
          Positioned(
            top: -topInset,
            left: 0,
            right: 0,
            height: backgroundHeight,
            child: Opacity(
              opacity: headerFadeOpacity,
              child: ClipRect(
                child: SizedBox(
                  width: double.infinity,
                  height: backgroundHeight,
                  child: _buildHeaderContent(
                    indicatorOpacity: indicatorOpacity,
                    indicatorScale: indicatorScale,
                  ),
                ),
              ),
            ),
          ),
        Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.transparent,
            scaffoldBackgroundColor: Colors.transparent,
          ),
          child: _buildScrollChild(context),
        ),
      ],
    );
  }
}
