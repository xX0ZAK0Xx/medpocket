import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:medpocket/configs/app_routes.dart';
import 'package:medpocket/configs/app_sizes.dart';
import 'package:medpocket/widgets/widgets.dart';
import '../../configs/colors.dart';
import '../../utils/utils.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});
  final String url = "sup.m360ict@gmail.com";
  final String phone = "01958398339";
  final String address = "Block#H, House#74, Banani, Dhaka";
  final String addressLink = "https://maps.app.goo.gl/G8SUDZRS7hnLKFfa9";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: 'plane_image',
        child: Stack(
          children: [
            // Background plane image with scale
            Transform.scale(
              scale: 1.5,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/health_bg.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Frosted glass effect container
            Container(
              width: AppSizes.width(context),
              padding: EdgeInsets.all(AppSizes.bodyPadding),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(113, 235, 239, 243),
                    Color.fromARGB(197, 235, 239, 243),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadius + AppSizes.bodyPadding),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Adjust the blur intensity
                        child: Container(
                          height: 300.h,
                          width: double.maxFinite,
                          padding: EdgeInsets.all(AppSizes.bodyPadding),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.8), 
                            borderRadius: BorderRadius.circular(AppSizes.borderRadius + AppSizes.bodyPadding),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2), // Soft white border for effect
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Get in Touch", style: myText(fontWeight: FontWeight.w700, color: AppColors.textColorw2, fontSize: 24.sp),),
                                SizedBox(height: AppSizes.bodyPadding,),
                                Text("For resister and other queries, please contact us through the following contact details.", style: myText(color: AppColors.textColorw1), textAlign: TextAlign.center,),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: ()=> launchEmail(email: url),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            HugeIcon(
                                              icon: HugeIcons.strokeRoundedMail01,
                                              color: AppColors.textColorw1,
                                              size: 16.0.sp,
                                            ),
                                            SizedBox(width: AppSizes.bodyPadding,),
                                            Text(url,style: myText(color: AppColors.textColorw1).copyWith(decoration: TextDecoration.underline, decorationColor: AppColors.textColorw2), textAlign: TextAlign.center,),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: AppSizes.bodyPadding / 2,),
                                      GestureDetector(
                                        onTap: ()=> launchCall(phoneNumber: phone),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            HugeIcon(
                                              icon: HugeIcons.strokeRoundedCall02,
                                              color: AppColors.textColorw1,
                                              size: 16.0.sp,
                                            ),
                                            SizedBox(width: AppSizes.bodyPadding,),
                                            Text(phone,style: myText(color: AppColors.textColorw1).copyWith(decoration: TextDecoration.underline, decorationColor: AppColors.textColorw2), textAlign: TextAlign.center,),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: AppSizes.bodyPadding / 2,),
                                      GestureDetector(
                                        onTap: ()=> launchUrlSite(url: addressLink),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            HugeIcon(
                                              icon: HugeIcons.strokeRoundedMapsSquare01,
                                              color: AppColors.textColorw1,
                                              size: 16.0.sp,
                                            ),
                                            SizedBox(width: AppSizes.bodyPadding,),
                                            Text(address,style: myText(color: AppColors.textColorw1).copyWith(decoration: TextDecoration.underline, decorationColor: AppColors.textColorw2), textAlign: TextAlign.center,),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // New Ripple Effect for 'Create New Account' Container
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadius + AppSizes.bodyPadding),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Adjust the blur intensity
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(AppSizes.borderRadius + AppSizes.bodyPadding),
                            splashColor: Colors.white.withOpacity(0.8), // Ripple color
                            onTap: () {
                            },
                            child: Container(
                              height: 80.h,
                              padding: EdgeInsets.all(AppSizes.bodyPadding * 2),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(AppSizes.borderRadius + AppSizes.bodyPadding),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2), // Soft white border for effect
                                ),
                              ),
                              child: AppButton(text: "Back to Sign In", press: (){
                                AppRoutes.pop(context);
                              }, color: AppColors.bg, txtColor: AppColors.textColorb1,)
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
