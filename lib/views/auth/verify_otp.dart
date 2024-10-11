import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpocket/configs/app_routes.dart';
import 'package:medpocket/configs/app_sizes.dart';
import 'package:medpocket/widgets/widgets.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import '../../blocs/bloc.dart';
import '../../configs/app_constants.dart';
import '../../configs/colors.dart';
import '../views.dart';

class VerifyOTP extends StatelessWidget {
  const VerifyOTP({super.key, required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    String otp ="";
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) => current is AuthLoadingState || current is VerifyOtpSuccessState || current is VerifyOtpFailedState,
        listener: (context, state) {
          if(state is AuthLoadingState){
            appLoadingDialog(context);
          } else if(state is VerifyOtpFailedState){
            AppRoutes.pop(context);
            appErrorDialog(context, state.errorMessage);
          } else if(state is VerifyOtpSuccessState){
            AppRoutes.pop(context);
            AppRoutes.pushReplacement(context, const ResetPass());
          }
        },
        child: Hero(
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
                            padding: EdgeInsets.all(AppSizes.bodyPadding),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.8), 
                              borderRadius: BorderRadius.circular(AppSizes.borderRadius + AppSizes.bodyPadding),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2), // Soft white border for effect
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Wrapping the form fields with Material to ensure proper rendering
                                Material(
                                  color: Colors.transparent,
                                  child: Column(
                                    children: [
                                      OtpTextField(
                                        alignment: Alignment.center,
                                        autoFocus: true,
                                        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                                        borderWidth: 0.5,
                                        numberOfFields: 6,
                                        borderColor: const Color.fromARGB(255, 128, 128, 128),
                                        showFieldAsBox: true,
                                        enabledBorderColor: const Color.fromARGB(255, 141, 141, 141),
                                        cursorColor: AppColors.bg,
                                        focusedBorderColor: AppColors.bg,
                                        textStyle: const TextStyle(color: Colors.white),
                                        onCodeChanged: (value) {
                                          otp = value;
                                        },
                                        onSubmit: (String verificationCode) {
                                          logger.i("otp: $verificationCode");
                                          // otpBloc.otp = verificationCode;
                                          context.read<AuthBloc>().add(VerifyOTPEvent(email: email.trim(), otp: verificationCode.trim()));
                                        },
                                      ),
                                      SizedBox(height: AppSizes.bodyPadding,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: (){
                                              AppRoutes.pop(context);
                                              AppRoutes.pop(context);
                                            }, 
                                            child: Text("Back to sign in", style: myText(fontWeight: FontWeight.w500, color: AppColors.textColorw2, fontSize: 12.sp),),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                AppButton(text: "Verify", press: (){
                                  // AppRoutes.pushReplacement(context, const ResetPass());
                                  context.read<AuthBloc>().add(VerifyOTPEvent(email: email.trim(), otp: otp.trim()));
                                }, color: AppColors.bg, txtColor: AppColors.textColorb1,
                                )
                              ],
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
                                AppRoutes.push(context, const SignUp());
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
                                        Expanded(child: Text("Do you want to create a new account?", textAlign: TextAlign.center, style: myText(color: AppColors.textColorw1),)),
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
      ),
    );
  }
}
