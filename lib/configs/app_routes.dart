import 'package:flutter/cupertino.dart';

class AppRoutes{
  static pushReplacement(context,page)    => Navigator.pushReplacement(context, CupertinoPageRoute(builder: (_)=> page));
  static push(context,page)               => Navigator.push(context, CupertinoPageRoute(builder: (_)=> page));
  static pushAndRemoveUntil(context,page) => Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (_)=> page), (route) => false);
  static pop(context)                     =>Navigator.pop(context);
}