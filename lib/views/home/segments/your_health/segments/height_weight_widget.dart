
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../../../../blocs/bloc.dart';
import '../../../../../configs/app_sizes.dart';
import '../../../../../configs/colors.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/widgets.dart';

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
          content: Column(
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
                                value: context.read<SetupProfileBloc>().feet.clamp(0, 10),
                                // value: feet??0,
                                selectedTextStyle: myText(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 20.sp),
                                minValue: 0,
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
                                value: context.read<SetupProfileBloc>().inch.clamp(0, 11),
                                // value: inch??0,
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
          ),
          actions: [
            CupertinoActionSheetAction(
              child: Text('Save', style: myText(fontWeight: FontWeight.bold, color: AppColors.secondary, fontSize: 18.sp).copyWith(fontFamily: "Poppins"),),
              onPressed: () {
                Navigator.pop(context);
                context.read<DashboardBloc>().add(UpdateHeightWeightEvent(feet: context.read<SetupProfileBloc>().feet, inch: context.read<SetupProfileBloc>().inch, weight: context.read<SetupProfileBloc>().weight));
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