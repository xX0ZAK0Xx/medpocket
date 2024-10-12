import 'package:flutter/material.dart';
import 'package:medpocket/configs/app_sizes.dart';
import 'package:medpocket/views/home/segments/home_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.bodyPadding),
          child: Column(
            children: [
              SizedBox(height: AppSizes.bodyPadding,),
              const HomeHeader()
            ],
          ),
        ),
      )
    );
  }
}
