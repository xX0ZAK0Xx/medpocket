
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../../../../blocs/bloc.dart';
import '../../../../../configs/app_sizes.dart';
import '../../../../../configs/colors.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/widgets.dart';

class BloodLevels extends StatefulWidget {
  const BloodLevels({super.key,  required this.title, required this.icon, required this.color, required this.isPressure, this.highPressure, this.lowPressure, this.glucose});
  final int? highPressure, lowPressure;
  final double? glucose;
  final String title;
  final IconData icon;
  final Color color;
  final bool isPressure;

  @override
  State<BloodLevels> createState() => _BloodLevelsState();
}

class _BloodLevelsState extends State<BloodLevels> {
  final ValueNotifier<int> highPressure = ValueNotifier<int>(0);
  final ValueNotifier<int> lowPressure = ValueNotifier<int>(0);
  final ValueNotifier<double> glucose = ValueNotifier<double>(0);

  @override
  void initState() {
    highPressure.value = widget.highPressure?? 0;
    lowPressure.value = widget.lowPressure?? 0;
    glucose.value = widget.glucose?? 0;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => showCupBottomSheet(
          context: context,
          title: 'Update blood pressure',
          content: Column(
            children: [
              SizedBox(height: AppSizes.bodyPadding,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        // SizedBox(height: AppSizes.bodyPadding * 2,),
                        Text("Upper Value",style: myText(fontWeight: FontWeight.w500, color: AppColors.secondary)),
                        ValueListenableBuilder(
                          valueListenable: highPressure,
                          builder: (context, value, child) {
                            return NumberPicker(
                              value: value == 0 ? 120 : value,
                              axis: Axis.horizontal,
                              itemCount: 3,
                              itemWidth: 50.w,
                              minValue: 0,
                              selectedTextStyle: myText(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 20.sp),
                              maxValue: 300,
                              onChanged: (value) => highPressure.value = value,
                            );
                          }
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        // SizedBox(height: AppSizes.bodyPadding * 2,),
                        Text("Lower Value",style: myText(fontWeight: FontWeight.w500, color: AppColors.secondary)),
                        ValueListenableBuilder(
                          valueListenable: lowPressure,
                          builder: (context, value, child) {
                            return NumberPicker(
                              value: value == 0 ? 80 : value,
                              axis: Axis.horizontal,
                              itemCount: 3,
                              itemWidth: 50.w,
                              minValue: 0,
                              selectedTextStyle: myText(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 20.sp),
                              maxValue: 200,
                              onChanged: (value) => lowPressure.value = value,
                            );
                          }
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            CupertinoActionSheetAction(
              child: Text('Save', style: myText(fontWeight: FontWeight.bold, color: AppColors.secondary, fontSize: 18.sp).copyWith(fontFamily: "Poppins"),),
              onPressed: () {
                Navigator.pop(context);
                context.read<DashboardBloc>().add(UpdateBloodPressureEvent(high: highPressure.value, low: lowPressure.value));
              },
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppSizes.bodyPadding * 1.5),
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(AppSizes.borderRadius)
              ),
              child: HugeIcon(icon: widget.icon, color: AppColors.primary, size: 24.sp),
            ),
            SizedBox(width: AppSizes.bodyPadding / 2),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.glucose == null ? '${widget.highPressure}/${widget.lowPressure}' : '${widget.glucose}', style: myText(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 28.sp)),
                Text(widget.title, style: myText()),
              ],
            )
          ],
        ),
      ),
    );
  }
}