import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:medpocket/blocs/show_bmi/show_bmi_bloc.dart';
import 'package:medpocket/utils/app_convert_datetime.dart';

import '../../../../configs/app_sizes.dart';
import '../../../../configs/colors.dart';
import '../../../../widgets/widgets.dart';
import 'dart:math';

import 'bmi_class.dart';

class BmiGraph extends StatelessWidget {

  const BmiGraph({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ShowBmiBloc>().add(ToggleDateRangeEvent(index: 0));
    // Calculate maxY based on the maximum height or weight value
    double maxY = bmiEntries.map((entry) => max(entry.height, entry.weight)).reduce(max);

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
          // BMI Title and Date Range Selector (same as before)
          _buildBmiStatistics(),
          SizedBox(height: AppSizes.bodyPadding * 2),
          
          // Make the graph scrollable horizontally
          SizedBox(
            height: 200.h,
            child: SizedBox(
              // width: bmiEntries.length * 100.w, // Adjust width based on the data length
              child: _LineChart(
                bmiEntries: bmiEntries,
                maxY: maxY,
              ),
            ),
          ),

          Row(
            children: [
              const ColorMeaning(color: AppColors.secondary, value: 'Height'),
              SizedBox(width: AppSizes.bodyPadding),
              const ColorMeaning(color: AppColors.blue, value: 'Weight'),
              SizedBox(width: AppSizes.bodyPadding),
              const ColorMeaning(color: AppColors.primary, value: 'BMI'),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBmiStatistics() {
    // Calculate BMI statistics (average, min, max)
    double averageBmi = bmiEntries.map((entry) => entry.bmi).reduce((a, b) => a + b) / bmiEntries.length;
    double minBmi = bmiEntries.map((entry) => entry.bmi).reduce(min);
    double maxBmi = bmiEntries.map((entry) => entry.bmi).reduce(max);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BmiValues(averageBmi: averageBmi, title: 'Average', icon: HugeIcons.strokeRoundedChartAverage, color: AppColors.primary.withOpacity(0.1)),
        BmiValues(averageBmi: minBmi, title: 'Minimum', icon: HugeIcons.strokeRoundedArrowDown05, color: AppColors.blue.withOpacity(0.1)),
        BmiValues(averageBmi: maxBmi, title: 'Maximum', icon: HugeIcons.strokeRoundedArrowUp05, color: AppColors.secondary.withOpacity(0.1)),
      ],
    );
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
  final List<BmiEntry> bmiEntries;
  final double maxY;

  const _LineChart({
    required this.bmiEntries,
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
        maxX: (bmiEntries.length - 1).toDouble(),
        maxY: maxY + 10, // Add some padding
        minY: 0,
      );

  FlGridData get gridData => const FlGridData(show: true);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border.all(color: Colors.black.withOpacity(0.2), width: 2),
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          fitInsideVertically: true, // Ensures tooltip fits inside the chart area
          fitInsideHorizontally: true,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((touchedSpot) {
              final index = touchedSpot.spotIndex;
              final entry = bmiEntries[index];
              String tooltipText;

              // Determine which line was touched by checking the barIndex
              switch (touchedSpot.barIndex) {
                case 0: // Height line
                  tooltipText = '${convertDateTime(entry.date, 'dd MMM, yyyy')}\n\nHeight: ${_convertInchesToFeetInches(entry.height)}';
                  break;
                case 1: // Weight line
                  tooltipText = 'Weight: ${entry.weight.toStringAsFixed(1)} kg';
                  break;
                case 2: // BMI line
                  tooltipText = 'BMI: ${entry.bmi.toStringAsFixed(2)}';
                  break;
                default:
                  tooltipText = '';
              }

              return LineTooltipItem(
                tooltipText,
                const TextStyle(color: AppColors.seed, fontWeight: FontWeight.w400),
              );
            }).toList();
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
        dotData: const FlDotData(show: true),
        spots: List.generate(bmiEntries.length, (index) {
          return FlSpot(index.toDouble(), bmiEntries[index].height);
        }),
      );

  LineChartBarData get weightLineData => LineChartBarData(
        isCurved: true,
        color: AppColors.blue,
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: true),
        spots: List.generate(bmiEntries.length, (index) {
          return FlSpot(index.toDouble(), bmiEntries[index].weight);
        }),
      );

  LineChartBarData get bmiLineData => LineChartBarData(
        isCurved: true,
        color: AppColors.primary,
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: true),
        spots: List.generate(bmiEntries.length, (index) {
          return FlSpot(index.toDouble(), bmiEntries[index].bmi);
        }),
      );

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 40,
        getTitlesWidget: (value, meta) {
          // Ensure index is within bounds
          if (value.toInt() >= 0 && value.toInt() < bmiEntries.length) {
            final date = bmiEntries[value.toInt()].date;
            return RotatedBox(
              quarterTurns: 3,
              child: Text(
                convertDateTime(date, 'dd MMM'),
                textAlign: TextAlign.center,
                style: myText(fontSize: 10.sp),
              ),
            );
          }
          return const Text('');
        },
        interval: 1, // Change this to 1 to take 1 unit of space
      );
}

SideTitles leftTitles() => SideTitles(
      showTitles: true,
      reservedSize: 25.w,
      getTitlesWidget: (value, meta) {
        return Text(value.toStringAsFixed(0), style: myText(fontSize: 10));
      },
      interval: 10,
    );

String _convertInchesToFeetInches(double inches) {
  int totalInches = inches.round();
  int feet = totalInches ~/ 12;
  int remainingInches = totalInches % 12;
  return "${feet}ft ${remainingInches}in";
}