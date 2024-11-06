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
  late AnimationController _animationController;
  late Animation<double> _zoomAnimation;
  late Animation<Color?> _startGradientColorAnimation;
  late Animation<Color?> _endGradientColorAnimation;

  @override
  void initState() {
    context.read<AuthBloc>().add(InitialFetchLoginDataEvent());
    super.initState();

    // Initialize the animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500), // Duration of the animation
      vsync: this,
    );

    // Zoom animation
    _zoomAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Gradient color animation
    _startGradientColorAnimation = ColorTween(
      begin: const Color.fromARGB(19, 235, 239, 243),
      end: const Color.fromARGB(113, 235, 239, 243),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _endGradientColorAnimation = ColorTween(
      begin: const Color.fromARGB(197, 235, 239, 243),
      end: const Color.fromARGB(197, 235, 239, 243),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Start the animation and navigate to the next screen when complete
  void _startAnimationAndNavigate(BuildContext context) {
    _animationController.forward().then((_) {
      AppRoutes.pushReplacement(context, const SignInScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) => current is AuthSuccessState || current is PreviousAuthErrorState,
        listener: (context, state) {
          if(state is PreviousAuthErrorState){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.errorMessage),
              duration: const Duration(seconds: 1),
            ));
          } else if(state is AuthSuccessState){
            if(state.allDone){
              AppRoutes.pushAndRemoveUntil(context, const RootScreen());
            }else{
              AppRoutes.pushAndRemoveUntil(context, const SetupProfile());
            }
          }
        },
        child: Stack(
          children: [
            // Plane image with zoom and slide animations
            Hero(
              tag: 'auth_bg_image',
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _zoomAnimation.value,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/health_bg.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Animated gradient background
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Container(
                  padding: EdgeInsets.all(AppSizes.bodyPadding),
                  width: AppSizes.width(context),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _startGradientColorAnimation.value!,
                        _endGradientColorAnimation.value!,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Column(
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
                      BlocBuilder<AuthBloc, AuthState>(
                        buildWhen: (previous, current) => current is NoPreviousDataState || current is PreviousAuthErrorState,
                        builder: (context, state) {
                          if(state is NoPreviousDataState || state is PreviousAuthErrorState){
                            return GestureDetector(
                              onTap: () {
                                _startAnimationAndNavigate(context); // Start animation
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
                            );
                          }else{
                            return SizedBox(height: 50.h,);
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}