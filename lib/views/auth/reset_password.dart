import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:medpocket/configs/app_routes.dart';
import 'package:medpocket/configs/app_sizes.dart';
import 'package:medpocket/widgets/widgets.dart';

import '../../blocs/bloc.dart';
import '../../configs/colors.dart';
import '../views.dart';

class ResetPass extends StatefulWidget {
  const ResetPass({super.key});

  @override
  State<ResetPass> createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  final TextEditingController passwordController1 = TextEditingController();
  final TextEditingController passwordController2 = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final passwordBloc1 = PasswordBloc();
  final passwordBloc2 = PasswordBloc();

  @override
  void dispose() {
    super.dispose();
    passwordController1.dispose();
    passwordController2.dispose();
    formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) => current is AuthLoadingState || current is ResetPassFailedState || current is ResetPassSuccessState,
        listener: (context, state) {
          if(state is AuthLoadingState){
            appLoadingDialog(context);
          } else if(state is ResetPassFailedState){
            AppRoutes.pop(context);
            appErrorDialog(context, state.errorMessage);
          } else if(state is ResetPassSuccessState){
            AppRoutes.pop(context);
            AppRoutes.pushAndRemoveUntil(context, const SignInScreen());
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
                                  child: Form(
                                    key: formKey,
                                    child: Column(
                                      children: [
                                        BlocBuilder<PasswordBloc, PasswordState>(
                                          bloc: passwordBloc1,
                                          builder: (context, state) {
                                            return AppTextField(
                                              obscureText: !passwordBloc1.passwordVisible,
                                              textInputAction: TextInputAction.next,
                                              labelText: "Password",
                                              hintText: "Enter your password",
                                              keyboardType: TextInputType.text,
                                              controller: passwordController1,
                                              labelColor: AppColors.textColorw1,
                                              hintColor: AppColors.textColorw3,
                                              fillColor: AppColors.bg.withOpacity(0.1),
                                              textColor: AppColors.textColorw1,
                                              isRequired: true,
                                              suffixIcon: GestureDetector(
                                                onTap: () {
                                                  passwordBloc1.add(TogglePasswordEvent());
                                                },
                                                child: HugeIcon(
                                                  icon: passwordBloc1.passwordVisible
                                                      ? HugeIcons.strokeRoundedView
                                                      : HugeIcons.strokeRoundedViewOff,
                                                  color: AppColors.textColorw1,
                                                  size: 24.0.r,
                                                ),
                                              ),
                                              validator: (p0) => p0!.isEmpty ? "Please Enter Password" : null,
                                            );
                                          },
                                        ),
                                        SizedBox(height: AppSizes.bodyPadding,),
                                        BlocBuilder<PasswordBloc, PasswordState>(
                                          bloc: passwordBloc2,
                                          builder: (context, state) {
                                            return AppTextField(
                                              obscureText: !passwordBloc2.passwordVisible,
                                              textInputAction: TextInputAction.done,
                                              labelText: "Confirm Password",
                                              hintText: "Re-Enter your password",
                                              keyboardType: TextInputType.text,
                                              controller: passwordController2,
                                              labelColor: AppColors.textColorw1,
                                              hintColor: AppColors.textColorw3,
                                              fillColor: AppColors.bg.withOpacity(0.1),
                                              textColor: AppColors.textColorw1,
                                              isRequired: true,
                                              suffixIcon: GestureDetector(
                                                onTap: () {
                                                  passwordBloc2.add(TogglePasswordEvent());
                                                },
                                                child: HugeIcon(
                                                  icon: passwordBloc2.passwordVisible
                                                      ? HugeIcons.strokeRoundedView
                                                      : HugeIcons.strokeRoundedViewOff,
                                                  color: AppColors.textColorw1,
                                                  size: 24.0.r,
                                                ),
                                              ),
                                              validator: (p0) => p0!.isEmpty ? "Please Re-Enter Password" : passwordController1.text != passwordController2.text ? "Passwords doesnt match" : null,
                                            );
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
                                ),
                                AppButton(text: "Reset Password", press: (){
                                  if(formKey.currentState!.validate()){
                                    context.read<AuthBloc>().add(ResetPasswordEvent(password: passwordController2.text.trim()));
                                  }
                                }, color: AppColors.bg, txtColor: AppColors.textColorb1,)
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
