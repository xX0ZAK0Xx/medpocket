import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../configs/app_routes.dart';
import '../configs/app_sizes.dart';
import '../configs/colors.dart';
import 'widgets.dart';


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

  showCupertinoDialog(
    barrierDismissible: barrierDismissible,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<void> appConfirmationDialog({required BuildContext context, required String title, required String description, required VoidCallback onTapYes}) {
  return appAlertDialog(
    context, 
    actions: [
      CupertinoDialogAction(child: Text("No", style: myText(color: AppColors.textColorb3, fontWeight: FontWeight.bold).copyWith(fontFamily: 'Poppins'),), onPressed: () {
        AppRoutes.pop(context);
      },),
      CupertinoDialogAction(child: Text("Yes", style: myText(color: AppColors.primary, fontWeight: FontWeight.bold).copyWith(fontFamily: 'Poppins'),), onPressed: () {
        AppRoutes.pop(context);
        onTapYes();
      },)
    ],
    content: Column(
      children: [
        Text(title, style: myText(fontSize: 16.sp, fontWeight: FontWeight.bold).copyWith(fontFamily: "Poppins"), textAlign: TextAlign.center),
        SizedBox(height: AppSizes.bodyPadding * 2,),
        Text(description, textAlign: TextAlign.center, style: myText().copyWith(fontFamily: "Poppins"),)
      ],
    )
  );
}