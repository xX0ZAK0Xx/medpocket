import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpocket/configs/app_sizes.dart';
import 'package:medpocket/widgets/app_shimmer.dart';

import '../../../configs/colors.dart';

class ShimmerSingleFolder extends StatelessWidget {
  const ShimmerSingleFolder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.bodyPadding),
      margin: EdgeInsets.only(bottom: AppSizes.bodyPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusBig),
      ),
      child: Row(
        children: [
          ShimmerContainer(height: 70.r, width: 70.r),
          SizedBox(width: AppSizes.bodyPadding,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerContainer(height: 20.h, width: 150.w,),
              SizedBox(height: AppSizes.bodyPadding/2,),
              ShimmerContainer(height: 15.h, width: 100.w,),
              SizedBox(height: AppSizes.bodyPadding/3,),
              ShimmerContainer(height: 15.h, width: 60.w,),
            ],
          )
        ],
      ),
    );
  }
}