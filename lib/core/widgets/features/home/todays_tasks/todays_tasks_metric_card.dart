import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/widgets/common/app_section_card.dart';

class TodaysTasksMetricCard extends StatelessWidget {
  const TodaysTasksMetricCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final onCard = context.onSectionCardColor;

    return SizedBox.expand(
      child: AppSectionCard(
        paddingHorizontal: 0.03,
        paddingVertical: 0.008,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSectionCardHeader(
                      icon: icon,
                      title: label,
                      iconColor: onCard,
                      iconSizeFactor: 0.5,
                      titleFontSize: 8,
                    ),
                    SizedBox(height: AppResponsive.scaleSize(context, 2)),
                    Text(
                      value,
                      style: AppTextStyles.heading(context).copyWith(
                        color: onCard,
                        fontWeight: FontWeight.w700,
                        fontSize: AppResponsive.scaleSize(context, 20),
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
