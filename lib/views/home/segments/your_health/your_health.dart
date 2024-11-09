import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:medpocket/configs/app_sizes.dart';
import 'package:medpocket/configs/colors.dart';
import 'package:medpocket/widgets/app_snackbar.dart';
import 'package:medpocket/widgets/app_text_style.dart';

import '../../../../blocs/bloc.dart';
import '../../../../models/model.dart';
import '../../../../utils/utils.dart';
import 'segments/blood_level_widget.dart';
import 'segments/height_weight_widget.dart';

class YourHealth extends StatelessWidget {
  const YourHealth({super.key});


  @override
  Widget build(BuildContext context) {
    context.read<DashboardBloc>().add(GetDashboardEvent());
    return Container(
      padding: EdgeInsets.all(AppSizes.bodyPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusBig),
        color: AppColors.white,
        boxShadow: [
          AppColors.redShadow()
        ]
      ),
      child: BlocConsumer<DashboardBloc, DashboardState>(
        listenWhen: (previous, current) => current is UpdateHeightWeightFailedState || current is UpdateHeightWeightSuccessState || current is UpdateBloodPressureSuccessState || current is UpdateBloodPressureFailedState || current is UpdateGlucoseFailedState || current is UpdateGlucoseSuccessState,
        listener: (context, state) {
          // if (state is UpdateHeightWeightLoadingState) {
          //   ScaffoldMessenger.of(context).showSnackBar(AppSnackbar.loadingSnackbar(title: "Updating", message: "Updating height and weight..."));
          // } else 
          if (state is UpdateHeightWeightFailedState) {
            ScaffoldMessenger.of(context).showSnackBar(AppSnackbar.failedSnackbar(title: "Sorry", message: "${state.errorMessage}. Please try again later."));
          } else if (state is UpdateHeightWeightSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(AppSnackbar.successSnackbar(title: "Congrats", message: "Height and weight updated successfully!"));
            
            context.read<DashboardBloc>().add(GetDashboardEvent());
          } else if (state is UpdateBloodPressureFailedState) {
            ScaffoldMessenger.of(context).showSnackBar(AppSnackbar.failedSnackbar(title: "Sorry", message: "${state.errorMessage}. Please try again later."));
          } else if (state is UpdateBloodPressureSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(AppSnackbar.successSnackbar(title: "Congrats", message: "Blood pressure updated successfully!"));

            context.read<DashboardBloc>().add(GetDashboardEvent());
          } else if (state is UpdateGlucoseFailedState) {
            ScaffoldMessenger.of(context).showSnackBar(AppSnackbar.failedSnackbar(title: "Sorry", message: "${state.errorMessage}. Please try again later."));
          } else if (state is UpdateGlucoseSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(AppSnackbar.successSnackbar(title: "Congrats", message: "Glucose Level updated successfully!"));

            context.read<DashboardBloc>().add(GetDashboardEvent());
          }
        },
        buildWhen: (previous, current) => current is GetDashboardSuccessState,
        builder: (context, state) {
          if(state is GetDashboardSuccessState){
            final Height height = cmToFeetInches(state.dashboardData.measurements?.height??0);
            context.read<SetupProfileBloc>().feet = height.foot;
            // context.read<SetupProfileBloc>().feet = 15;
            context.read<SetupProfileBloc>().inch = height.inch;
            context.read<SetupProfileBloc>().weight = state.dashboardData.measurements?.weight??0;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Your health", style: myText(fontWeight: FontWeight.w500, color: AppColors.primary),),
                SizedBox(height: AppSizes.bodyPadding),
                Row(
                  children: [
                    HeightWeightBox(title: "Height", feet: height.foot, inch: height.inch,),
                    SizedBox(width: AppSizes.bodyPadding),
                    HeightWeightBox(title: "Weight", kg: state.dashboardData.measurements?.weight,),
                  ],
                ),
                SizedBox(height: AppSizes.bodyPadding * 2),
                Row(
                  children: [
                    BloodLevels(
                      key: ValueKey("pressure${state.dashboardData.pressure?.data}"),
                      highPressure: state.dashboardData.pressure?.highPressure,
                      lowPressure:  state.dashboardData.pressure?.lowPressure, 
                      title: "Pressure", 
                      icon: HugeIcons.strokeRoundedBloodPressure, 
                      color: AppColors.primary.withOpacity(0.1), 
                      isPressure: true,
                      lastChecked: state.dashboardData.pressure?.data,
                    ),
                    SizedBox(width: AppSizes.bodyPadding),
                    // BloodLevels(glucose: state.dashboardData.gluco,se?.glucose, title: "Glucose", icon: HugeIcons.strokeRoundedBlood, color: AppColors.secondary.withOpacity(0.2), isPressure: false,lastChecked: state.dashboardData.glucose?.date,)
                    BloodLevels(
                      key: ValueKey("glucose${state.dashboardData.glucose?.date}"),
                      glucose: state.dashboardData.glucose?.glucose,
                      title: "Glucose",
                      icon: HugeIcons.strokeRoundedBlood,
                      color: AppColors.secondary.withOpacity(0.2),
                      isPressure: false,
                      lastChecked: state.dashboardData.glucose?.date,
                    ),
                  ],
                )
              ],
            );
          }else{
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Your health", style: myText(fontWeight: FontWeight.w500, color: AppColors.primary),),
                SizedBox(height: AppSizes.bodyPadding),
                Row(
                  children: [
                    HeightWeightBox(title: "Height", feet: context.read<DashboardBloc>().feet, inch: context.read<DashboardBloc>().inch,),
                    SizedBox(width: AppSizes.bodyPadding),
                    HeightWeightBox(title: "Weight", kg: context.read<DashboardBloc>().weight,),
                  ],
                ),
                SizedBox(height: AppSizes.bodyPadding * 2),
                Row(
                  children: [
                    BloodLevels(highPressure: context.read<DashboardBloc>().highPressure, lowPressure: context.read<DashboardBloc>().lowPressure, title: "Pressure", icon: HugeIcons.strokeRoundedBloodPressure, color: AppColors.primary.withOpacity(0.1), isPressure: true,),
                    SizedBox(width: AppSizes.bodyPadding),
                    BloodLevels(glucose: context.read<DashboardBloc>().glucose, title: "Glucose", icon: HugeIcons.strokeRoundedBlood, color: AppColors.secondary.withOpacity(0.2), isPressure: false),
                  ],
                )
              ],
            );
          }
        },
      ),
    );
  }
}