import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:today/core/utils/app_lotties/app_lotties.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';

/// AI typing row: typing Lottie + rotating status phrases (Gemini-style).
class PlannerChatTypingIndicator extends StatefulWidget {
  const PlannerChatTypingIndicator({super.key, required this.textColor});

  final Color textColor;

  @override
  State<PlannerChatTypingIndicator> createState() =>
      _PlannerChatTypingIndicatorState();
}

class _PlannerChatTypingIndicatorState
    extends State<PlannerChatTypingIndicator> {
  static const _phraseInterval = Duration(milliseconds: 2200);
  static const _fadeDuration = Duration(milliseconds: 450);

  int _phraseIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(_phraseInterval, (_) {
      if (!mounted) return;
      setState(() {
        _phraseIndex = (_phraseIndex + 1) % AppTexts.chatTypingPhrases.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final phrase = AppTexts.chatTypingPhrases[_phraseIndex];
    final lottieSize = AppResponsive.scaleSize(context, 28);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final typingLottie = isDark
        ? AppLotties.typingWhite
        : AppLotties.typingBlack;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: lottieSize,
          height: lottieSize,
          child: Lottie.asset(typingLottie, fit: BoxFit.contain, repeat: true),
        ),
        SizedBox(width: AppResponsive.scaleSize(context, 8)),
        Flexible(
          child: AnimatedSwitcher(
            duration: _fadeDuration,
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Text(
              phrase,
              key: ValueKey<String>(phrase),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyText(context).copyWith(
                color: widget.textColor,
                fontWeight: FontWeight.w500,
                fontSize: AppResponsive.scaleSize(context, 12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
