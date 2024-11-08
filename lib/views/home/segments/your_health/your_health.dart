import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as mt;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:medpocket/blocs/dashboard/dashboard_bloc.dart';
import 'package:medpocket/configs/app_sizes.dart';
import 'package:medpocket/configs/colors.dart';
import 'package:medpocket/widgets/app_text_style.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../../../blocs/bloc.dart';
import '../../../../utils/utils.dart';

class YourHealth extends StatelessWidget {
  const YourHealth({super.key});


  @override
  Widget build(BuildContext context) {
    context.read<DashboardBloc>().add(GetDashboardEvent());
    return Container(
      padding: EdgeInsets.all(AppSizes.bodyPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusBig),
        color: AppColors.white,
        boxShadow: [
          AppColors.redShadow()
        ]
      ),
      child: BlocBuilder<DashboardBloc, DashboardState>(
        buildWhen: (previous, current) => current is GetDashboardSuccessState,
        builder: (context, state) {
          if(state is GetDashboardSuccessState){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Your health", style: myText(fontWeight: FontWeight.w500, color: AppColors.primary),),
                SizedBox(height: AppSizes.bodyPadding),
                Row(
                  children: [
                    HeightWeightBox(title: "Height", feet: cmToFeetInches(state.dashboardData.measurements?.height??0).foot, inch: cmToFeetInches(state.dashboardData.measurements?.height??0).inch,),
                    SizedBox(width: AppSizes.bodyPadding),
                    HeightWeightBox(title: "Weight", kg: state.dashboardData.measurements?.weight,),
                  ],
                ),
                SizedBox(height: AppSizes.bodyPadding * 2),
                Row(
                  children: [
                    BloodLevels(value: "${state.dashboardData.pressure?.highPressure}/${state.dashboardData.pressure?.lowPressure}", title: "Pressure", icon: HugeIcons.strokeRoundedBloodPressure, color: AppColors.primary.withOpacity(0.1)),
                    SizedBox(width: AppSizes.bodyPadding),
                    BloodLevels(value: "${state.dashboardData.glucose?.glucose}", title: "Glucose", icon: HugeIcons.strokeRoundedBlood, color: AppColors.secondary.withOpacity(0.2)),
                  ],
                )
              ],
            );
          }else{
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Your health", style: myText(fontWeight: FontWeight.w500, color: AppColors.primary),),
                SizedBox(height: AppSizes.bodyPadding),
                Row(
                  children: [
                    HeightWeightBox(title: "Height", feet: context.read<DashboardBloc>().feet, inch: context.read<DashboardBloc>().inch,),
                    SizedBox(width: AppSizes.bodyPadding),
                    HeightWeightBox(title: "Weight", kg: context.read<DashboardBloc>().weight,),
                  ],
                ),
                SizedBox(height: AppSizes.bodyPadding * 2),
                Row(
                  children: [
                    BloodLevels(value: "${context.read<DashboardBloc>().highPressure}/${context.read<DashboardBloc>().lowPressure}", title: "Pressure", icon: HugeIcons.strokeRoundedBloodPressure, color: AppColors.primary.withOpacity(0.1)),
                    SizedBox(width: AppSizes.bodyPadding),
                    BloodLevels(value: "${context.read<DashboardBloc>().glucose}", title: "Glucose", icon: HugeIcons.strokeRoundedBlood, color: AppColors.secondary.withOpacity(0.2)),
                  ],
                )
              ],
            );
          }
        },
      ),
    );
  }
}

class BloodLevels extends StatelessWidget {
  const BloodLevels({super.key, required this.value, required this.title, required this.icon, required this.color});
  final String value, title;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSizes.bodyPadding * 1.5),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppSizes.borderRadius)
            ),
            child: HugeIcon(icon: icon, color: AppColors.primary, size: 24.sp),
          ),
          SizedBox(width: AppSizes.bodyPadding / 2),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: myText(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 28.sp)),
              Text(title, style: myText()),
            ],
          )
        ],
      ),
    );
  }
}

class HeightWeightBox extends StatelessWidget {
  const HeightWeightBox({super.key, this.kg, required this.title,  this.feet, this.inch});
  final String title;
  final int? feet, inch, kg;

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: GestureDetector(
        onTap: () => showCupBottomSheet(
          context: context,
          title: 'Update Height and Weight',
          content: mt.Material(
            child: Column(
              children: [
                SizedBox(height: AppSizes.bodyPadding,),
                BlocBuilder<SetupProfileBloc, SetupProfileState>(
                  buildWhen: (previous, current) => current is ChangeFeetState || current is ChangeInchState,
                  builder: (context, state) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Feet",style: myText(fontWeight: FontWeight.w500, color: AppColors.secondary)),
                                NumberPicker(
                                  axis: Axis.horizontal,
                                  itemCount: 5,
                                  value: context.read<SetupProfileBloc>().feet,
                                  selectedTextStyle: myText(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 20.sp),
                                  minValue: 2,
                                  maxValue: 10,
                                  onChanged: (value) => context.read<SetupProfileBloc>().add(ChangeFeetEvent(feet: value)),
                                  itemWidth: 30.w,
                                  itemHeight: 20.h,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Inch",style: myText(fontWeight: FontWeight.w500, color: AppColors.secondary)),
                                NumberPicker(
                                  itemWidth: 30.w,
                                  axis: Axis.horizontal,
                                  itemHeight: 20.h,
                                  itemCount: 5,
                                  value: context.read<SetupProfileBloc>().inch,
                                  selectedTextStyle: myText(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 20.sp),
                                  minValue: 0,
                                  maxValue: 11,
                                  onChanged: (value) => context.read<SetupProfileBloc>().add(ChangeInchEvent(inch: value)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: AppSizes.bodyPadding * 2,),
                        Text("Weight (kg)",style: myText(fontWeight: FontWeight.w500, color: AppColors.secondary)),
                        BlocBuilder<SetupProfileBloc, SetupProfileState>(
                          buildWhen: (previous, current) => current is ChangeWeightState,
                          builder: (context, state) {
                            return NumberPicker(
                              value: context.read<SetupProfileBloc>().weight,
                              axis: Axis.horizontal,
                              itemCount: 5,
                              itemWidth: 70.w,
                              minValue: 30,
                              selectedTextStyle: myText(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 20.sp),
                              maxValue: 150,
                              onChanged: (value) => context.read<SetupProfileBloc>().add(ChangeWeightEvent(weight: value)),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            )
          ),
          actions: [
            CupertinoActionSheetAction(
              child: Text('Save', style: myText(fontWeight: FontWeight.bold, color: AppColors.secondary, fontSize: 18.sp).copyWith(fontFamily: "Poppins"),),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(AppSizes.bodyPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
            border: Border.all(width: 0.2, color: AppColors.primary),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if(feet != null)
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$feet',
                      style: myText(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    TextSpan(
                      text: 'ft ',
                      style: myText(
                        fontWeight: FontWeight.w400,
                        color: AppColors.primary.withOpacity(0.5),
                      ),
                    ),
                    TextSpan(
                      text: '$inch',
                      style: myText(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    TextSpan(
                      text: 'in',
                      style: myText(
                        fontWeight: FontWeight.w400,
                        color: AppColors.primary.withOpacity(0.5),
                      ),
                    ),
                  ]
                ),
              )
              else
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$kg',
                      style: myText(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    TextSpan(
                      text: 'kg',
                      style: myText(
                        fontWeight: FontWeight.w400,
                        color: AppColors.primary.withOpacity(0.5),
                      ),
                    ),
                  ]
                ),
              ),
              Text(
                title,
                style: myText(fontSize: 16.sp, color: AppColors.primary, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
