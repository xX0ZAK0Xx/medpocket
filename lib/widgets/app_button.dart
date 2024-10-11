import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpocket/configs/app_sizes.dart';
import 'package:medpocket/widgets/app_text_style.dart';

import '../configs/colors.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.press,
    this.width,
    this.color = AppColors.primary,
    this.txtColor,
    this.radius,
  });

  final String? text;
  final VoidCallback press;
  final Color? color;
  final Color? txtColor;
  final double? width;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(color), // Set background color
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius ?? AppSizes.borderRadius), // Set border radius
                ),
              ),
              padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h)), // Set padding
            ),
            onPressed: press,
            child: Text(
              text ?? "",
              style: myText(
                color: txtColor ?? AppColors.textColorw1,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
