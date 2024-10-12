import 'package:flutter/material.dart';

class AppColors{
  static const primary                = Color(0xffFC345C);
  static const secondary              = Color(0xff49BEB7);
  static const seed                   = Color(0xffAFFFDF);
  static const blue                   = Color(0xff0054b3);
  static const bg                     = Color.fromARGB(255, 248, 241, 243);
  static const white                  = Color(0xffffffff);
  static const black                  = Color.fromARGB(255, 29, 29, 29);
  static const red                    = Colors.redAccent;
  static const textColorb1            = Colors.black87;
  static const textColorb2            = Colors.black54;
  static const textColorb3            = Colors.black45;
  static const textColorw1            = Colors.white70;
  static const textColorw2            = Colors.white60;
  static const textColorw3            = Colors.white54;
  static Color error(context)         => Theme.of(context).colorScheme.error;
  static BoxShadow redShadow() => BoxShadow(
    color: AppColors.primary.withOpacity(0.15),
    spreadRadius: -10,
    blurRadius: 10,
    offset: const Offset(0, 2)
  );
}