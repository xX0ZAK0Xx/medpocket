import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:medpocket/configs/app_sizes.dart';
import 'package:medpocket/configs/colors.dart';
import 'package:medpocket/widgets/app_text_style.dart';

class YourHealth extends StatelessWidget {
  const YourHealth({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.bodyPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusBig),
        color: AppColors.white,
        boxShadow: [
          AppColors.redShadow()
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Your health", style: myText(fontWeight: FontWeight.w500, color: AppColors.primary),),
          SizedBox(height: AppSizes.bodyPadding,),
          Row(children: [
            const HeightWeightBox(title: "Height", value: "5ft 10in",),
            SizedBox(width: AppSizes.bodyPadding,),
            const HeightWeightBox(title: "Weight", value: "65 kg",),
          ],),
          SizedBox(height: AppSizes.bodyPadding * 2,),
          Row(
            children: [
              BloodLevels(value: "125/75", title: "Pressure", icon: HugeIcons.strokeRoundedBloodPressure, color: AppColors.primary.withOpacity(0.1)),
              SizedBox(width: AppSizes.bodyPadding,),
              BloodLevels(value: "5.5", title: "Glucose", icon: HugeIcons.strokeRoundedBlood, color: AppColors.secondary.withOpacity(0.2)),
              SizedBox(width: AppSizes.bodyPadding,),
              BloodLevels(value: "98%", title: "Oxigen", icon: HugeIcons.strokeRoundedDroplet, color: AppColors.blue.withOpacity(0.1))
            ],
          )
        ],
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
            padding: EdgeInsets.all(AppSizes.bodyPadding / 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppSizes.borderRadius)
              // shape: BoxShape.circle
            ),
            child: HugeIcon(icon: icon, color: AppColors.primary, size: 24.sp,),
          ),
          SizedBox(width: AppSizes.bodyPadding / 2,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: myText(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 18.sp),),
              Text(title, style: myText(),),
          ],)
        ],
      ),
    );
  }
}

class HeightWeightBox extends StatelessWidget {
  const HeightWeightBox({super.key, required this.value, required this.title});
  final String value, title;

  @override
  Widget build(BuildContext context) {
    final regExp = RegExp(r'(\d+\.?\d*)\s*([a-zA-Z]+)?');
    final matches = regExp.allMatches(value);

    return Expanded(
      child: Container(
        height: 80.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          border: Border.all(width: 0.2, color: AppColors.primary),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            RichText(
              text: TextSpan(
                children: matches.map((match) {
                  final numericPart = match.group(1) ?? ''; // The numeric part
                  final unitPart = match.group(2) ?? ''; // The unit part

                  return [
                    TextSpan(
                      text: numericPart,
                      style: myText(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    TextSpan(
                      text: '$unitPart ',
                      style: myText(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primary.withOpacity(0.5),
                      ),
                    ),
                  ];
                }).expand((span) => span).toList(),
              ),
            ),
            Text(
              title,
              style: myText(fontSize: 18.sp, color: AppColors.primary, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
