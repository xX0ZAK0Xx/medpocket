import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpocket/configs/colors.dart';
import 'package:medpocket/widgets/app_text_style.dart';

void showCupBottomSheet({
  required BuildContext context,
  required String title,
  required Widget content,
  required List<CupertinoActionSheetAction> actions,
  CupertinoActionSheetAction? cancelAction,
}) {
  showCupertinoModalPopup(
    context: context,
    builder: (_) => CupertinoActionSheet(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, fontFamily: "Poppins")),
      message: content,
      actions: actions,
      cancelButton: cancelAction ?? CupertinoActionSheetAction(
        child: Text('Cancel', style: myText(color: AppColors.red, fontWeight: FontWeight.w800, fontSize: 16.sp),),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ),
  );
}
