import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medpocket/blocs/auth/auth_bloc.dart';
import 'package:medpocket/configs/app_routes.dart';
import 'package:medpocket/views/splash/splash_screen.dart';

import '../../widgets/widgets.dart';

class BookedFlightScreen extends StatelessWidget {
  const BookedFlightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booked Flight Details'),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if(state is LogoutSuccessState){
            AppRoutes.pushAndRemoveUntil(context, const SplashScreen());
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppButton(text: "Log Out", press: (){
                context.read<AuthBloc>().add(LogoutEvent());
              })
            ],
          ),
        ),
      ),
    );
  }
}
