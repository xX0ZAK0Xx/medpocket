import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:medpocket/blocs/bloc.dart';
import 'package:medpocket/configs/app_sizes.dart';
import 'package:medpocket/configs/colors.dart';

import '../../../../widgets/widgets.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<SetupProfileBloc>().add(GetProfileEvent());
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
                BlocBuilder<SetupProfileBloc, SetupProfileState>(
                  buildWhen: (previous, current) => current is GetProfileSuccessState,
                  builder: (context, state) {
                    if(state is GetProfileSuccessState){
                      return Container(
                        width: 60.r,
                        height: 60.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: 
                                state.data.imageUrl != null && state.data.imageUrl != '' ?
                                 NetworkImage('${state.data.imageUrl}') :
                                const AssetImage('assets/images/avatar.png') as ImageProvider,
                            fit: BoxFit.cover,
                            onError: (error, stackTrace) {
                              const AssetImage('assets/images/avatar.png');
                            },
                          ),
                        ),
                      );
                    }
                    return Container(
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
                    );
                  },
                ),
                SizedBox(width: AppSizes.bodyPadding,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome back", style: myText(fontSize: 16.sp),),
                      BlocBuilder<SetupProfileBloc, SetupProfileState>(
                        buildWhen: (previous, current) => current is GetProfileSuccessState,
                        builder: (context, state) {
                          if(state is GetProfileSuccessState){
                            return Text(state.data.name??"",maxLines: 1, overflow: TextOverflow.ellipsis, style: myText(fontSize: 20.sp, fontWeight: FontWeight.w500, color: AppColors.primary),);
                          }
                          return Text("",maxLines: 1, overflow: TextOverflow.ellipsis, style: myText(fontSize: 20.sp, fontWeight: FontWeight.w500, color: AppColors.primary),);
                        },
                      ),
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