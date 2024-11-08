import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
