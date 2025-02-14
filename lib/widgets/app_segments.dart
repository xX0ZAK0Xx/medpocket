import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../configs/colors.dart';

Widget buildSegment(String text, bool isSelected, {Color selectedTextColor = AppColors.textColorb1, Color textColor = AppColors.bg}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14.sp,
        color: isSelected ? selectedTextColor : textColor,
      ),
    ),
  );
}
