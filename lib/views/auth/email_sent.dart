import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpocket/configs/app_routes.dart';
import 'package:medpocket/configs/app_sizes.dart';
import 'package:medpocket/widgets/widgets.dart';
import '../../configs/colors.dart';

class EmailSent extends StatelessWidget {
  const EmailSent({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: 'auth_bg_image',
        child: Stack(
          children: [
            // Background plane image with scale
            Transform.translate(
              offset: Offset(60.w, 0),
              child: Transform.scale(
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
                              children: [
                                Text(
                                  "Success",
                                  style: myText(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textColorw2,
                                    fontSize: 24.sp,
                                  ),
                                ),
                                SizedBox(height: AppSizes.bodyPadding),
                                Text(
                                  "Please check your email",
                                  style: myText(color: AppColors.textColorw1),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: AppSizes.bodyPadding/2),
                                Text(
                                  "A password reset link has been sent.",
                                  style: myText(color: AppColors.textColorw1),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
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
                              AppRoutes.pop(context); 
                              AppRoutes.pop(context); 
                            },
                            child: Container(
                              height: 80.h,
                              padding: EdgeInsets.all(AppSizes.bodyPadding),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(AppSizes.borderRadius + AppSizes.bodyPadding),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2), // Soft white border for effect
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Or", style: myText(color: AppColors.textColorw1, fontSize: 12),),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(child: Text("Do you want to go back to Sign In?", textAlign: TextAlign.center, style: myText(color: AppColors.textColorw1),)),
                                    ],
                                  )  
                                ],
                              ),
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
