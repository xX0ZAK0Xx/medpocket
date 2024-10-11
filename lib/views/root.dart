import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:medpocket/configs/colors.dart';
import 'package:medpocket/widgets/app_text_style.dart';
import 'package:upgrader/upgrader.dart';

import '../blocs/root/root_bloc.dart';
import 'booked_flight/booked_flight_screen.dart';
import 'flight/flight_screen.dart';
import 'ticket/ticket_screen.dart';
import 'visa/visa_screen.dart';

class RootScreen extends StatelessWidget{
  const RootScreen({super.key});

  final List<Widget> screens = const [
    VisaScreen(),
    TicketScreen(),
    FlightScreen(),
    BookedFlightScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    context.read<RootBloc>().add(RootInitialEvent());

    return WillPopScope(
      onWillPop: () async {
        // Handle back button using Bloc
        context.read<RootBloc>().add(BackNavigationEvent());
        return false; // Prevent default pop
      },
      child: Scaffold(
        body: BlocConsumer<RootBloc, RootState>(
          listener: (context, state) {
            if (state is ShowExistAlertState) {
              _showExitConfirmationDialog(context);
            }
          },
          builder: (context, state) {
            int currentIndex = context.read<RootBloc>().currentPage;
            
            return UpgradeAlert(
              child: PageTransitionSwitcher(
                transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
                  return FadeThroughTransition(
                    animation: primaryAnimation,
                    secondaryAnimation: secondaryAnimation,
                    child: child,
                  );
                },
                child: screens[currentIndex],
              ),
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<RootBloc, RootState>(
          builder: (context, state) {
            int currentIndex = context.read<RootBloc>().currentPage;
            return Container(
              height: 80.h,
              decoration: const BoxDecoration(
                color: AppColors.bg,
              ),
              child: Padding(
                padding: EdgeInsets.all(10.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: buildNavItem(
                        context,
                        currentIndex == 0,
                        icon: HugeIcons.strokeRoundedHome04,
                        label: "Home",
                        onTap: () {
                          context.read<RootBloc>().add(NavigateToHomeEvent());
                        },
                      ),
                    ),
                    Expanded(
                      child: buildNavItem(
                        context,
                        currentIndex == 1,
                        icon: HugeIcons.strokeRoundedCreditCardValidation,
                        label: "Pre-Registration",
                        onTap: () {
                          context.read<RootBloc>().add(NavigateToPreRegistrationEvent());
                        },
                      ),
                    ),
                    Expanded(
                      child: buildNavItem(
                        context,
                        currentIndex == 2,
                        icon: HugeIcons.strokeRoundedCreditCardPos,
                        label: "Payment",
                        onTap: () {
                          context.read<RootBloc>().add(NavigateToPaymentEvent());
                        },
                      ),
                    ),
                    Expanded(
                      child: buildNavItem(
                        context,
                        currentIndex == 3,
                        icon: HugeIcons.strokeRoundedUser,
                        label: "Profile",
                        onTap: () {
                          context.read<RootBloc>().add(NavigateToProfileEvent());
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Exit App"),
        content: const Text("Do you really want to close the app?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("Yes", style: myText(color: AppColors.red, fontWeight: FontWeight.w500),),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("No", style: myText(color: AppColors.primary, fontWeight: FontWeight.w500),),
          ),
        ],
      ),
    ) ?? false;
  }

  Widget buildNavItem(BuildContext context, bool isActive, {required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: isActive ? 30.w : 0.w,
            height: 1.h,
            decoration: BoxDecoration(
              color: isActive ? AppColors.secondary : Colors.transparent,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          const SizedBox(height: 5),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: isActive ? 24.r : 16.r,
            height: isActive ? 24.r : 16.r,
            child: HugeIcon(
              icon: icon,
              size: isActive ? 20.r : 16.r,
              color: isActive ? AppColors.secondary : AppColors.textColorb3,
            ),
          ),
          const SizedBox(height: 5),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: myText(
              color: isActive ? AppColors.secondary : AppColors.textColorb3,
              fontSize: 12.sp,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
            child: Text(label),
          ),
        ],
      ),
    );
  }
}
