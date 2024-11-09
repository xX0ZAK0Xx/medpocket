import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpocket/configs/app_routes.dart';
import 'package:medpocket/configs/app_sizes.dart';
import 'package:medpocket/utils/app_validations.dart';
import 'package:medpocket/views/views.dart';
import 'package:medpocket/widgets/widgets.dart';

import '../../blocs/bloc.dart';
import '../../configs/colors.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({super.key});

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) => current is PasswordResetSuccessState,
        listener: (context, state) {
          if (state is AuthLoadingState) {
            ScaffoldMessenger.of(context).showSnackBar(AppSnackbar.loadingSnackbar(title: "Loading", message: "Please wait..."));
          } else if (state is PasswordResetSuccessState){
            AppRoutes.push(context, const EmailSent());
          }
        },
        child: Hero(
              tag: 'auth_bg_image',
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
                                      child: Form(
                                        key: formKey,
                                        child: Column(
                                          children: [
                                            AppTextField(
                                              textInputAction: TextInputAction.next,
                                              labelText: "Email", 
                                              hintText: "Enter your email", 
                                              keyboardType: TextInputType.emailAddress, 
                                              controller: emailController,
                                              isRequired: true,
                                              labelColor: AppColors.textColorw1,
                                              hintColor: AppColors.textColorw3,
                                              fillColor: AppColors.bg.withOpacity(0.1),
                                              textColor: AppColors.textColorw1,
                                              validator: (p0) => p0!.isEmpty ? "Please enter your email" : !emailValidate(p0) ? "Please enter a valid email" : null,
                                            ),
                                            SizedBox(height: AppSizes.bodyPadding,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                InkWell(
                                                  onTap: () => AppRoutes.pop(context),
                                                  child: Text("Back to sign in", style: myText(fontWeight: FontWeight.w500, color: AppColors.textColorw2, fontSize: 12.sp),),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    AppButton(text: "Send OTP", press: (){
                                      if(formKey.currentState!.validate()){
                                        // AppRoutes.push(context, const VerifyOTP());
                                        context.read<AuthBloc>().add(PasswordResetEvent(email: emailController.text.trim()));
                                      }
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
