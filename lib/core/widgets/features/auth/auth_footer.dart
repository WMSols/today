import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';

class AuthFooter extends StatelessWidget {
  const AuthFooter({super.key});

  static final Uri _wmsolsUri = Uri.parse('https://www.wmsols.com/');

  Future<void> _openWebsite() async {
    await launchUrl(_wmsolsUri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = AppTextStyles.hintText(context).copyWith(
      color: AppColors.white.withValues(alpha: 0.7),
      fontWeight: FontWeight.w500,
      fontSize: AppResponsive.screenWidth(context) * 0.03,
    );
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: baseStyle,
          children: [
            const TextSpan(text: 'Powered by '),
            TextSpan(
              text: 'WMSols',
              style: baseStyle.copyWith(
                color: AppColors.white,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w700,
              ),
              recognizer: TapGestureRecognizer()..onTap = _openWebsite,
            ),
            const TextSpan(text: ' for your daily growth'),
          ],
        ),
      ),
    );
  }
}
