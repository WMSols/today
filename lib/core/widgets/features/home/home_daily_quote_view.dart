import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';

class HomeDailyQuoteView extends StatelessWidget {
  const HomeDailyQuoteView({
    super.key,
    required this.quote,
    required this.author,
  });

  final String quote;
  final String author;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppResponsive.screenWidth(context) * 0.8,
      child: Column(
        children: [
          Text(
            '"$quote"',
            textAlign: TextAlign.center,
            style: AppTextStyles.headline(context).copyWith(
              color: AppColors.grey,
              fontSize: AppResponsive.scaleSize(context, 19),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppResponsive.scaleSize(context, 8)),
          Text(
            '\u2014 ${author.toUpperCase()}',
            style: AppTextStyles.labelText(context).copyWith(
              color: AppColors.grey,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w600,
              fontSize: AppResponsive.scaleSize(context, 6),
            ),
          ),
        ],
      ),
    );
  }
}
