
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:medpocket/configs/app_constants.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../../../../blocs/bloc.dart';
import '../../../../../configs/app_sizes.dart';
import '../../../../../configs/colors.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/widgets.dart';

class BloodLevels extends StatefulWidget {
  const BloodLevels({super.key,  required this.title, required this.icon, required this.color, required this.isPressure, this.highPressure, this.lowPressure, this.glucose, this.lastChecked});
  final int? highPressure, lowPressure;
  final double? glucose;
  final String title;
  final IconData icon;
  final Color color;
  final bool isPressure;
  final DateTime? lastChecked;

  @override
  State<BloodLevels> createState() => _BloodLevelsState();
}

class _BloodLevelsState extends State<BloodLevels> {
  final ValueNotifier<int> highPressure = ValueNotifier<int>(0);
  final ValueNotifier<int> lowPressure = ValueNotifier<int>(0);
  final ValueNotifier<double> glucose = ValueNotifier<double>(0);
  final ValueNotifier<double> progress = ValueNotifier<double>(1.0);
  // ignore: unused_field
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    highPressure.value = widget.highPressure?? 0;
    lowPressure.value = widget.lowPressure?? 0;
    glucose.value = widget.glucose?? 0;
    if (widget.lastChecked != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeProgress();  // Set initial progress after the first frame
        _startTimer();          // Start periodic updates
      });
    }
  }

  void _initializeProgress() {
    logger.e('time: widget.lastChecked!: ${widget.lastChecked!}');
    logger.e('time: now!: ${DateTime.now()}');
    final elapsed =  DateTime.now().difference(widget.lastChecked!).inMinutes;
    final maxInterval = 6 * 60; // 6 hours in minutes

    // Calculate progress using milliseconds and clamp it between 0.0 and 1.0
    progress.value = (1 - (elapsed / maxInterval).clamp(0.0, 1.0)).toDouble();

    logger.i("time: elapsed: $elapsed minutes"); // Convert to minutes for readability
    logger.d("time: Initial progress: ${progress.value}");
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 10), (timer) {
      _initializeProgress();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => updatePresGlu(context),
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.glucose == null
                                ? '${widget.highPressure}/${widget.lowPressure}'
                                : '${widget.glucose}',
                            style: myText(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 24.sp),
                          ),
                        ],
                      ),
                      ValueListenableBuilder(
                        valueListenable: progress,
                        builder: (context, value, child) {
                          return value==0? Positioned(
                            top: -15,
                            right: -15,
                            child: IconButton(
                              onPressed: (){
                                showCupBottomSheet(
                                  context: context,
                                  title: "",
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "⏰ Reminder!",
                                        style: myText(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.secondary,
                                        ).copyWith(fontFamily: "Poppins"),
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        "It’s been more than 6 hours since you last updated your ${widget.title}. Please check your ${widget.title} again to stay on track.",
                                        textAlign: TextAlign.center,
                                        style: myText(fontSize: 16.sp, color: AppColors.textColorb3).copyWith(fontFamily: "Poppins"),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    CupertinoActionSheetAction(
                                      child: Text(
                                        'Click here to update',
                                        style: myText(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.secondary,
                                          fontSize: 18.sp,
                                        ).copyWith(fontFamily: "Poppins"),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        updatePresGlu(context);
                                      },
                                    ),
                                  ],
                                );

                              },
                              icon: HugeIcon(
                                icon: HugeIcons.strokeRoundedAlertCircle,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                          ):SizedBox.shrink();
                        }
                      )
                    ],
                  ),
                  Text(widget.title, style: myText()),
                  if (widget.lastChecked != null)
                    ValueListenableBuilder(
                      valueListenable: progress,
                      builder: (context, value, child) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              flex: (progress.value * 100).toInt(),
                              child: Container(
                                height: 4.0.h, // Adjust height as needed
                                decoration: BoxDecoration(
                                  color: AppColors.primary, // Foreground color
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    bottomLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(value == 1.0 ? 4.0 : 0.0),
                                    bottomRight: Radius.circular(value == 1.0 ? 4.0 : 0.0),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 100 - (progress.value * 100).toInt(),
                              child: Container(
                                height: 4.0.h, // Same height as the progress container
                                decoration: BoxDecoration(
                                  color: AppColors.secondary.withOpacity(0.3), // Background color
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(4.0),
                                    bottomRight: Radius.circular(4.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void updatePresGlu(BuildContext context) {
    return showCupBottomSheet(
        context: context,
        title: 'Update ${widget.title}',
        content: Column(
          children: [
            SizedBox(height: AppSizes.bodyPadding,),
            if(widget.glucose == null)
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
            )
            else
            Column(
              children: [
                Text("Glucose (mmol/L)",style: myText(fontWeight: FontWeight.w500, color: AppColors.secondary)),
                ValueListenableBuilder<double>(
                  valueListenable: glucose,
                  builder: (context, value, child) {
                    // Split the integer and decimal parts
                    final parts = value.toStringAsFixed(1).split('.');
                    final integerPart = parts[0];
                    final decimalPart = parts[1];

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DecimalNumberPicker(
                          value: value == 0 ? 6 : value,
                          axis: Axis.horizontal,
                          itemCount: 5,
                          decimalPlaces: 1,
                          itemWidth: 70.w,
                          minValue: 0,
                          maxValue: 30,
                          selectedTextStyle: myText(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 20.sp),
                          onChanged: (newValue) => glucose.value = newValue,
                        ),
                        SizedBox(height: 8), // Spacer for readability
                        RichText(
                          text: TextSpan(
                            style: myText(fontSize: 20.sp),
                            children: [
                              TextSpan(
                                text: integerPart,
                                style:myText(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 24.sp)
                              ),
                              TextSpan(
                                text: '.',
                                style:myText(color: AppColors.textColorb3, fontWeight: FontWeight.w600, fontSize: 24.sp)
                              ),
                              TextSpan(
                                text: decimalPart,
                                style:myText(color: AppColors.blue, fontWeight: FontWeight.w500, fontSize: 24.sp)
                              ),
                              TextSpan(
                                text: ' mmol/L',
                                style: myText()
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                )
              ],
            )
          ],
        ),
        actions: [
          CupertinoActionSheetAction(
            child: Text('Save', style: myText(fontWeight: FontWeight.bold, color: AppColors.secondary, fontSize: 18.sp).copyWith(fontFamily: "Poppins"),),
            onPressed: () {
              Navigator.pop(context);
              if(widget.glucose != null){
                context.read<DashboardBloc>().add(UpdateGlucoseEvent(glucose: glucose.value== 0 ? 6.0 : glucose.value));
              }else{
                context.read<DashboardBloc>().add(UpdateBloodPressureEvent(high: highPressure.value == 0 ? 120 : highPressure.value, low: lowPressure.value == 0 ? 80 : lowPressure.value));
              }
            },
          ),
        ],
      );
  }
}