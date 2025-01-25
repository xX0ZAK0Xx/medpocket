import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../configs/app_sizes.dart';
import '../configs/colors.dart';
import 'widgets.dart';

class AppNothingToDisplay extends StatelessWidget {
  const AppNothingToDisplay({
    super.key, this.message,
  });
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(AppSizes.bodyPadding),
      padding: EdgeInsets.all(AppSizes.bodyPadding),
      decoration: BoxDecoration(
        color: AppColors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusBig)
      ),
      child: Row(
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedAlertCircle,
            color: AppColors.red,
            size: 24.0,
          ),
          SizedBox(width: AppSizes.bodyPadding),
          Expanded(
            child: Text(
              message ?? "Nothing to display",
              style: myText(color: AppColors.red, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
