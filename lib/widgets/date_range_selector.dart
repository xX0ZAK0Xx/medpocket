
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../configs/app_sizes.dart';
import '../../../configs/colors.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';

class DateRangeSelector extends StatelessWidget {
  const DateRangeSelector({
    super.key,
    required this.dateRangeNotifier, this.label1, this.hint1, this.label2, this.hint2, this.initalDate,
  });
  final String? label1, hint1, label2, hint2;
  final DateTime? initalDate;

  final ValueNotifier<DateTimeRange?> dateRangeNotifier;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await selectDateRange(
          context: context,
          notifier: dateRangeNotifier,
          firstDate: initalDate ?? DateTime.now(),
          lastDate: DateTime(2050),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppSizes.bodyPadding, horizontal:  AppSizes.bodyPadding * 2),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.borderRadius * 10),
        ),
        constraints: BoxConstraints(
          minHeight: 60.h, 
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label1 ?? "From", style: myText(color: AppColors.textColorb3, fontSize: 12.sp, fontWeight: FontWeight.w500),),
                SizedBox(height: AppSizes.bodyPadding / 2,),
                ValueListenableBuilder(
                  valueListenable: dateRangeNotifier,
                  builder: (_, value, __) {
                    return Text(convertDateTime(value?.start, 'dd MMM, yyyy')?? hint1 ?? "Select Start Date", style: myText(),);
                  }
                ),
              ],
            ),
            HugeIcon(
              icon: HugeIcons.strokeRoundedArrowLeftRight,
              color: AppColors.primary,
              size: 24.0.sp,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(label2 ?? "To", style: myText(color: AppColors.textColorb3, fontSize: 12.sp, fontWeight: FontWeight.w500),),
                SizedBox(height: AppSizes.bodyPadding / 2,),
                ValueListenableBuilder(
                  valueListenable: dateRangeNotifier,
                  builder: (_, value, __) {
                    return Text(convertDateTime(value?.end, 'dd MMM, yyyy')?? hint2 ?? "Select Start Date", style: myText(),);
                  }
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
