import 'package:flutter/material.dart';
import 'package:medpocket/configs/app_sizes.dart';
import 'package:medpocket/views/home/segments/header/home_header.dart';
import 'package:medpocket/views/home/segments/your_health/your_health.dart';

import '../views.dart';
import 'segments/bmi/bmi_graph.dart';

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
              const HomeHeader(),
              SizedBox(height: AppSizes.bodyPadding * 2),
              Expanded(child: ListView(
                children: [
                  const YourHealth(),
                  SizedBox(height: AppSizes.bodyPadding),
                  PressureGlucoseGraph(),
                  SizedBox(height: AppSizes.bodyPadding),
                  const BmiGraph(),
                ],
              ))
            ],
          ),
        ),
      )
    );
  }
}
