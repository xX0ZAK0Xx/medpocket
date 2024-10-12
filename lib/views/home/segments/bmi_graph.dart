import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:medpocket/blocs/show_bmi/show_bmi_bloc.dart';
import 'package:medpocket/utils/app_convert_datetime.dart';

import '../../../configs/app_sizes.dart';
import '../../../configs/colors.dart';
import '../../../widgets/widgets.dart';
import 'dart:math';

class BmiGraph extends StatelessWidget {
  final List<double> heightsInInches = [68.9, 69.1, 69.1, 69.1, 69.3]; // Heights in inches
  final List<double> weightsInKg = [65, 63, 66, 60, 68]; // Weights in kg
  final List<DateTime> entryDates = [
    DateTime(2023, 10, 1),
    DateTime(2023, 10, 2),
    DateTime(2023, 10, 3),
    DateTime(2023, 10, 4),
    DateTime(2023, 10, 5)
  ];

  BmiGraph({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ShowBmiBloc>().add(ToggleDateRangeEvent(index: 0));
    // Calculate BMI values
    List<double> bmiValues = List.generate(heightsInInches.length, (index) {
      double heightInM = _convertInchesToMeters(heightsInInches[index]);
      return weightsInKg[index] / pow(heightInM, 2);
    });

    // Calculate BMI statistics
    double averageBmi = bmiValues.reduce((a, b) => a + b) / bmiValues.length;
    double minBmi = bmiValues.reduce(min);
    double maxBmi = bmiValues.reduce(max);

    // Determine maxY based on the maximum height or weight value
    double maxY = max(
      heightsInInches.reduce(max),
      weightsInKg.reduce(max),
    );

    return Container(
      padding: EdgeInsets.all(AppSizes.bodyPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusBig),
        color: AppColors.white,
        boxShadow: [AppColors.redShadow()],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "BMI",
                style: myText(fontWeight: FontWeight.w500, color: AppColors.primary),
              ),
              BlocBuilder<ShowBmiBloc, ShowBmiState>(
                builder: (context, state) {
                  if(state is ToggleDateRangeState){
                    return Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            context.read<ShowBmiBloc>().add(ToggleDateRangeEvent(index: 0));
                          },
                          child: Text("7D", style: myText(fontWeight: FontWeight.bold, color: state.index == 0 ? AppColors.primary : AppColors.lightPink, fontSize: 14)),
                        ),
                        SizedBox(width: AppSizes.bodyPadding * 2,),
                        GestureDetector(
                          onTap: (){
                            context.read<ShowBmiBloc>().add(ToggleDateRangeEvent(index: 1));
                          },
                          child: Text("15D", style: myText(fontWeight: FontWeight.bold, color: state.index == 1 ? AppColors.primary : AppColors.lightPink, fontSize: 14)),
                        ),
                        SizedBox(width: AppSizes.bodyPadding * 2,),
                        GestureDetector(
                          onTap: (){
                            context.read<ShowBmiBloc>().add(ToggleDateRangeEvent(index: 2));
                          },
                          child: Text("1M", style: myText(fontWeight: FontWeight.bold, color: state.index == 2 ? AppColors.primary : AppColors.lightPink, fontSize: 14)),
                        ),
                        SizedBox(width: AppSizes.bodyPadding,)
                      ],
                    );
                  }else{
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
          SizedBox(height: AppSizes.bodyPadding),
          // Display BMI statistics
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BmiValues(averageBmi: averageBmi, title: 'Average', icon: HugeIcons.strokeRoundedChartAverage, color: AppColors.primary.withOpacity(0.1),),
              BmiValues(averageBmi: minBmi, title: 'Minimum', icon: HugeIcons.strokeRoundedArrowDown05, color: AppColors.blue.withOpacity(0.1),),
              BmiValues(averageBmi: maxBmi, title: 'Maximum', icon: HugeIcons.strokeRoundedArrowUp05, color: AppColors.secondary.withOpacity(0.1),),
            ],
          ),
          SizedBox(height: AppSizes.bodyPadding * 2),
          SizedBox(
            height: 250.h,
            child: _LineChart(
              heightsInInches: heightsInInches,
              weightsInKg: weightsInKg,
              bmiValues: bmiValues,
              entryDates: entryDates,
              maxY: maxY,
            ),
          ),
          Row(
            children: [
              const ColorMeaning(color: AppColors.secondary, value: 'Height',),
              SizedBox(width: AppSizes.bodyPadding,),
              const ColorMeaning(color: AppColors.blue, value: 'Weight',),
              SizedBox(width: AppSizes.bodyPadding,),
              const ColorMeaning(color: AppColors.primary, value: 'BMI',),
            ],
          )
        ],
      ),
    );
  }

  // Convert inches to meters for BMI calculation
  double _convertInchesToMeters(double inches) {
    return inches * 0.0254;
  }
}
class ColorMeaning extends StatelessWidget {
  const ColorMeaning({super.key, required this.value, required this.color});
  final String value;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Expanded(child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color
          ),
        ),
        SizedBox(width: AppSizes.bodyPadding / 2,),
        Text(value, style: myText(),),
      ],
    ));
  }
}
class BmiValues extends StatelessWidget {
  const BmiValues({
    super.key,
    required this.averageBmi, required this.title, required this.icon, required this.color,
  });

  final double averageBmi;
  final String title;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSizes.bodyPadding / 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppSizes.borderRadius)
            ),
            child: Icon(icon),
          ),
          SizedBox(width: AppSizes.bodyPadding / 2,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                averageBmi.toStringAsFixed(2),
                style: myText(color: AppColors.secondary, fontWeight: FontWeight.bold),
              ),
              Text(
                title,
                style: myText(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LineChart extends StatelessWidget {
  final List<double> heightsInInches;
  final List<double> weightsInKg;
  final List<double> bmiValues;
  final List<DateTime> entryDates;
  final double maxY;

  const _LineChart({
    required this.heightsInInches,
    required this.weightsInKg,
    required this.bmiValues,
    required this.entryDates,
    required this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData1,
      duration: const Duration(milliseconds: 700),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: (entryDates.length - 1).toDouble(),
        maxY: maxY + 10, // Add some padding to avoid touching the edges
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {

            final index = touchedSpots.first.spotIndex;
            final heightInInches = heightsInInches[index];
            final heightFtIn = _convertInchesToFeetInches(heightInInches);
            final weightKg = weightsInKg[index];
            final bmi = bmiValues[index].toStringAsFixed(2);

            return [
              LineTooltipItem(
                'Height: $heightFtIn\nWeight: ${weightKg.toStringAsFixed(1)} kg\nBMI: $bmi',
                const TextStyle(color: AppColors.seed, fontWeight: FontWeight.bold),
              ),
              // Return null for the other spots to avoid duplication
              if (touchedSpots.length > 1) null,
              if (touchedSpots.length > 2) null,
            ];
          },
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        heightLineData,
        weightLineData,
        bmiLineData,
      ];

  LineChartBarData get heightLineData => LineChartBarData(
        isCurved: true,
        color: AppColors.secondary,
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        spots: List.generate(heightsInInches.length, (index) {
          return FlSpot(index.toDouble(), heightsInInches[index]);
        }),
      );

  LineChartBarData get weightLineData => LineChartBarData(
        isCurved: true,
        color: AppColors.blue,
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        spots: List.generate(weightsInKg.length, (index) {
          return FlSpot(index.toDouble(), weightsInKg[index]);
        }),
      );

  LineChartBarData get bmiLineData => LineChartBarData(
        isCurved: true,
        color: AppColors.primary,
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        spots: List.generate(bmiValues.length, (index) {
          return FlSpot(index.toDouble(), bmiValues[index]);
        }),
      );

  SideTitles leftTitles() => SideTitles(
        showTitles: true,
        reservedSize: 40,
        getTitlesWidget: (value, meta) {
          return Text(value.toStringAsFixed(0), style: const TextStyle(fontSize: 10));
        },
        interval: 10,
      );

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 40,
        getTitlesWidget: (value, meta) {
          final date = entryDates[value.toInt()];
          return Text(
            convertDateTime(date, 'dd MMM\nyyyy'),
            textAlign: TextAlign.center,
            style: myText(fontSize: 10.sp),
          );
        },
        interval: 1,
      );

  FlGridData get gridData => const FlGridData(show: true);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border.all(color: Colors.black.withOpacity(0.2), width: 2),
      );

  String _convertInchesToFeetInches(double inches) {
    int totalInches = inches.round();
    int feet = totalInches ~/ 12;
    int remainingInches = totalInches % 12;
    return "${feet}ft ${remainingInches}in";
  }
}
