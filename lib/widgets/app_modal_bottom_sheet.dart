import 'package:flutter/material.dart';

import '../configs/app_sizes.dart';
import '../configs/colors.dart';

void appModalBottomSheet({required BuildContext context, required Widget content, double? height}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,  // This makes the modal cover the whole screen when needed
    enableDrag: true,
    showDragHandle: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSizes.borderRadiusBig),
      ),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          // Ensure there is padding equal to the height of the keyboard
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          width: double.maxFinite,
          height: height,
          padding: EdgeInsets.symmetric(horizontal: AppSizes.bodyPadding),
          decoration: BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSizes.borderRadiusBig),
            ),
          ),
          child: SingleChildScrollView(
            child: content,
          ),
        ),
      );
    },
  );
}