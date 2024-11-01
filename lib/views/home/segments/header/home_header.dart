import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:medpocket/configs/app_sizes.dart';
import 'package:medpocket/configs/colors.dart';

import '../../../../widgets/widgets.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.bodyPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30.r + AppSizes.bodyPadding),
        boxShadow: [
          AppColors.redShadow()
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 60.r,
                  height: 60.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: 
                          // profileData.photo != null && profileData.photo != ''
                          // ? NetworkImage('${profileData.photo}') : 
                          const AssetImage('assets/images/avatar.png') as ImageProvider,
                      fit: BoxFit.cover,
                      onError: (error, stackTrace) {
                        const AssetImage('assets/images/avatar.png');
                      },
                    ),
                  ),
                ),
                SizedBox(width: AppSizes.bodyPadding,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome back", style: myText(fontSize: 16.sp),),
                      Text("Md. Zayed Oyshik",maxLines: 1, overflow: TextOverflow.ellipsis, style: myText(fontSize: 20.sp, fontWeight: FontWeight.w500, color: AppColors.primary),),
                    ],
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              
            },
            child: Container(
              padding: EdgeInsets.all(AppSizes.bodyPadding),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 0.5, color: AppColors.primary),
              ),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedNotification03,
                color: AppColors.primary,
                size: 20.0.sp,
              )
            ),
          )
        ],
      )
    );
  }
}