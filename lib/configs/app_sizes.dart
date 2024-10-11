import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSizes{
  static double bodyPadding     = 10.h;
  static double preferredBottom = 10.h;
  static double borderRadius    = 5.h;
  static double borderRadiusBig    = 10.h;

  static double height(context) => MediaQuery.sizeOf(context).height;
  static double width(context)  => MediaQuery.sizeOf(context).width;
}