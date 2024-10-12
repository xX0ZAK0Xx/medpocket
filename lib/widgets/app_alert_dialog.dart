import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';
import 'package:medpocket/widgets/app_text_style.dart';

import '../configs/colors.dart';


Future<void> appAlertDialog(
    BuildContext context,
    {
      List<Widget> actions = const <Widget>[],
      bool barrierDismissible = true,
      String? title,
      Color color = AppColors.bg,
      required Widget content
    }) async {
  final alert = CupertinoAlertDialog(
    content: content,
    actions: actions,
  );

  showDialog(
    barrierDismissible: barrierDismissible,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<void> appLoadingDialog(BuildContext context) {
  return appAlertDialog(
    barrierDismissible: false,
    context,
    content: SizedBox(
      height: 100.h,
      width: 100.w,
      child: Stack(
        children: [
          // Center the Lottie animation within the Stack
          Positioned(
            top: -10.h,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                height: 80.h, // Adjust height as needed
                child: Lottie.asset('assets/animations/loading.json'),
              ),
            ),
          ),
          // Center the text at the bottom of the dialog
          Positioned(
            bottom: 0.h, // Position it slightly above the bottom
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "Loading.....",
                style: myText(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Future<void> appErrorDialog(BuildContext context, String? message) {
  return appAlertDialog(
    context,
    content: SizedBox(
      height: 100.h,
      width: 150.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const HugeIcon(
            icon: HugeIcons.strokeRoundedAlert02,
            color: AppColors.red,
            size: 24.0,
          ),
          Text(
            message??"Something went wrong",
            style: myText(
              color: AppColors.textColorb1,
              fontSize: 12.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
