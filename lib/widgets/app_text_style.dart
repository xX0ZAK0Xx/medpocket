import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpocket/configs/colors.dart';

TextStyle myText({Color color = AppColors.textColorb1, FontWeight fontWeight = FontWeight.w300, double? fontSize}){
  return TextStyle(color: color, fontWeight: fontWeight, fontSize: fontSize??14.sp);
}