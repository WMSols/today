import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_fonts/app_fonts.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';

class AppTextStyles {
  static TextStyle headline(BuildContext context) => TextStyle(
    fontSize: AppResponsive.screenWidth(context) * 0.09,
    fontFamily: AppFonts.mainFont,
    fontWeight: FontWeight.w500,
    height: 1.1,
    color: Theme.of(context).textTheme.bodyLarge?.color,
  );

  static TextStyle heading(BuildContext context) => TextStyle(
    fontSize: AppResponsive.screenWidth(context) * 0.06,
    fontFamily: AppFonts.mainFont,
    fontWeight: FontWeight.w500,
    color: Theme.of(context).textTheme.bodyLarge?.color,
  );

  static TextStyle bodyText(BuildContext context) => TextStyle(
    fontSize: AppResponsive.screenWidth(context) * 0.04,
    fontFamily: AppFonts.mainFont,
    color: Theme.of(context).textTheme.bodyLarge?.color,
  );

  static TextStyle hintText(BuildContext context) => TextStyle(
    fontSize: AppResponsive.screenWidth(context) * 0.035,
    fontFamily: AppFonts.mainFont,
    color: AppColors.grey,
  );

  static TextStyle buttonText(BuildContext context) {
    return TextStyle(
      fontSize: AppResponsive.screenWidth(context) * 0.045,
      fontFamily: AppFonts.mainFont,
      fontWeight: FontWeight.w600,
      color: context.accentPalette.buttonFilledForeground,
    );
  }

  static TextStyle labelText(BuildContext context) => TextStyle(
    fontSize: AppResponsive.screenWidth(context) * 0.035,
    fontFamily: AppFonts.mainFont,
    color: Theme.of(context).textTheme.bodyLarge?.color,
  );

  static TextStyle errorText(BuildContext context) => TextStyle(
    fontSize: AppResponsive.screenWidth(context) * 0.035,
    fontFamily: AppFonts.mainFont,
    color: AppColors.error,
  );
}
