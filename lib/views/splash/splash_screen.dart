import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:medpocket/configs/app_routes.dart';
import 'package:medpocket/configs/app_sizes.dart';
import 'package:medpocket/configs/colors.dart';
import 'package:medpocket/widgets/app_text_style.dart';

import '../../blocs/bloc.dart';
import '../views.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UserAuthenticatedState) {
            // Navigate to home screen if user is already authenticated
            AppRoutes.pushAndRemoveUntil(context, const HomeScreen());
          } else if (state is FirebaseAuthSuccessState) {
            // Navigate to setup profile after successful sign up
            AppRoutes.pushAndRemoveUntil(context, const SetupProfile());
          } else if (state is FirebaseAuthFailedState) {
            // Show error message if sign up fails
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/health_bg.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: AppSizes.bodyPadding),
                      child: RichText(
                        text: TextSpan(
                          style: myText(
                              fontSize: 30,
                              fontWeight: FontWeight.w300,
                              color: AppColors.primary),
                          children: <TextSpan>[
                            const TextSpan(text: 'Track all your\n'),
                            TextSpan(
                              text: 'Health Reports\n',
                              style: myText(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary),
                            ),
                            const TextSpan(text: 'at one place'),
                          ],
                        ),
                      ),
                    ),
                    // Only show Get Started button if user is not authenticated
                    if (state is UserNotAuthenticatedState)
                      GestureDetector(
                        onTap: () {
                          context.read<AuthBloc>().add(FirebaseSignUpEvent());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                height: 50.h,
                                padding: EdgeInsets.all(AppSizes.bodyPadding),
                                decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.horizontal(
                                        left: Radius.circular(AppSizes.borderRadius))),
                                child: Center(
                                    child: Text("Get Started",
                                        style: myText(
                                          color: AppColors.bg,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold))),
                              ),
                            ),
                            Container(
                              height: 50.h,
                              padding: EdgeInsets.all(AppSizes.bodyPadding),
                              decoration: BoxDecoration(
                                  color: AppColors.bg,
                                  borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(AppSizes.borderRadius))),
                              child: Center(
                                child: HugeIcon(
                                  icon: HugeIcons.strokeRoundedFavourite,
                                  color: AppColors.primary,
                                  size: 24.0.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}