import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpocket/blocs/bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../configs/app_sizes.dart';
import '../../../../configs/colors.dart';
import '../../../../models/model.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/widgets.dart';
import 'blank_graph_shimmer.dart';

class PressureGlucoseGraph extends StatelessWidget {
  const PressureGlucoseGraph({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetching the day-wise data for glucose and pressure
    context.read<DashboardBloc>().add(GetDaywiseGlucoseEvent(days: 1));
    context.read<DashboardBloc>().add(GetDaywisePressureEvent(days: 1));

    return Container(
      padding: EdgeInsets.all(AppSizes.bodyPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusBig),
        color: AppColors.white,
        boxShadow: [AppColors.redShadow()],
      ),
      child: Row(
        children: [
          // Pressure Graph
          Expanded(
            child: BlocBuilder<DashboardBloc, DashboardState>(
              buildWhen: (previous, current) => current is GetDaywisePressureSuccessState,
              builder: (context, state) {
                if (state is GetDaywisePressureSuccessState) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 80.h,
                        child: _PressureGraph(pressureData: state.dayWisePressureList),
                      ),
                      Text("Todays Pressure", style: myText(color: AppColors.primary, fontWeight: FontWeight.w500),)
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      SizedBox(
                        height: 80.h,
                        child: BlankGraph(),
                      ),
                      Text("Todays Pressure", style: myText(color: AppColors.primary, fontWeight: FontWeight.w500),)
                    ],
                  );
                }
              },
            ),
          ),
          SizedBox(width: AppSizes.bodyPadding),
          // Glucose Graph
          Expanded(
            child: BlocBuilder<DashboardBloc, DashboardState>(
              buildWhen: (previous, current) => current is GetDaywiseGlucoseSuccessState,
              builder: (context, state) {
                if (state is GetDaywiseGlucoseSuccessState) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 80.h,
                        child: _GlucoseGraph(glucoseData: state.dayWiseGlucoseList),
                      ),
                      Text("Todays Glucose", style: myText(color: AppColors.primary, fontWeight: FontWeight.w500),)
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      SizedBox(
                        height: 80.h,
                        child: BlankGraph(),
                      ),
                      Text("Todays Glucose", style: myText(color: AppColors.primary, fontWeight: FontWeight.w500),)
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
FlGridData  _gridData({required bool isPressure}) => FlGridData(
    show: true, 
    drawVerticalLine: true, // Enable vertical lines
    drawHorizontalLine: true, // Enable horizontal lines
    horizontalInterval: isPressure ? 50 : 5, // Set interval for horizontal grid lines (can adjust based on your data range)
    verticalInterval: 0.4, // Set interval for vertical grid lines (adjust this too)
    getDrawingHorizontalLine: (value) {
      return FlLine(
        color: Colors.black.withOpacity(0.1), // Color for horizontal lines
        strokeWidth: 0.5, // Thickness of the horizontal lines
      );
    },
    getDrawingVerticalLine: (value) {
      return FlLine(
        color: Colors.black.withOpacity(0.1), // Color for vertical lines
        strokeWidth: 0.5, // Thickness of the vertical lines
      );
    },
);
class _PressureGraph extends StatelessWidget {
  final List<DayWisePressureData> pressureData;
  const _PressureGraph({required this.pressureData});

  @override
  Widget build(BuildContext context) {
    int maxY = pressureData
        .map((entry) => max(entry.highPressure ?? 0, entry.lowPressure ?? 0))
        .reduce(max);

    return LineChart(
      LineChartData(
        lineTouchData: _lineTouchData,
        gridData: _gridData(isPressure: true),
        titlesData: _titlesData,
        borderData: _borderData,
        lineBarsData: [
          _highPressureLineData,
          _lowPressureLineData,
        ],
        minX: 0,
        maxX: (pressureData.length - 1).toDouble(),
        maxY: maxY + 10, // Add padding to the top
        minY: 0,
      ),
    );
  }

  LineTouchData get _lineTouchData => LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((touchedSpot) {
              final index = touchedSpot.spotIndex;
              final entry = pressureData[index];
              String tooltipText = '';

              // Pressure line index: 0 for high pressure, 1 for low pressure
              switch (touchedSpot.barIndex) {
                case 0: // High Pressure
                  tooltipText = '${convertDateTime(entry.date?.add(Duration(hours: 6)), 'hh:mm:ss aa')}\nHigh: ${entry.highPressure} mmHg';
                  break;
                case 1: // Low Pressure
                  tooltipText = 'Low: ${entry.lowPressure} mmHg';
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

  FlBorderData get _borderData => FlBorderData(
        show: true,
        border: Border.all(color: Colors.black.withOpacity(0.2), width: 2),
      );

  FlTitlesData get _titlesData => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
            if (value.toInt() < pressureData.length) {
              final date = pressureData[value.toInt()].date;
              return Align(
                alignment: Alignment.center, // Center align the title
                child: Text(
                  convertDateTime(date?.add(Duration(hours: 6)), 'HH:mm'),
                  style: myText(fontSize: 10.sp, fontWeight: FontWeight.w400),
                ),
              );
            }
            return const Text('');
          }),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(isPressure: true),  // Wrap SideTitles inside AxisTitles
        ),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // Remove top titles
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // Remove right titles
      );

  LineChartBarData get _highPressureLineData => LineChartBarData(
        isCurved: true,
        color: AppColors.secondary,
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        spots: List.generate(pressureData.length, (index) {
          return FlSpot(index.toDouble(), pressureData[index].highPressure?.toDouble() ?? 0);
        }),
      );

  LineChartBarData get _lowPressureLineData => LineChartBarData(
        isCurved: true,
        color: AppColors.blue,
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        spots: List.generate(pressureData.length, (index) {
          return FlSpot(index.toDouble(), pressureData[index].lowPressure?.toDouble() ?? 0);
        }),
      );
}

class _GlucoseGraph extends StatelessWidget {
  final List<DayWiseGlucoseData> glucoseData;
  const _GlucoseGraph({required this.glucoseData});

  @override
  Widget build(BuildContext context) {
    double maxY = glucoseData
        .map((entry) => entry.glucose ?? 0)
        .reduce(max);

    return LineChart(
      LineChartData(
        lineTouchData: _lineTouchData,
        gridData: _gridData(isPressure: false),
        titlesData: _titlesData,
        borderData: _borderData,
        lineBarsData: [
          _glucoseLineData,
        ],
        minX: 0,
        maxX: (glucoseData.length - 1).toDouble(),
        maxY: maxY + 10, // Add padding to the top
        minY: 0,
      ),
    );
  }

  LineTouchData get _lineTouchData => LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((touchedSpot) {
              final index = touchedSpot.spotIndex;
              final entry = glucoseData[index];
              String tooltipText = '';

              // Glucose line index: 0
              tooltipText = '${convertDateTime(entry.date?.add(Duration(hours: 6)), 'hh:mm:ss aa')}\nGlucose: ${entry.glucose} mg/dL';

              return LineTooltipItem(
                tooltipText,
                const TextStyle(color: AppColors.seed, fontWeight: FontWeight.w400),
              );
            }).toList();
          },
        ),
      );

  FlBorderData get _borderData => FlBorderData(
        show: true,
        border: Border.all(color: Colors.black.withOpacity(0.2), width: 2),
      );

  FlTitlesData get _titlesData => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
            if (value.toInt() < glucoseData.length) {
              final date = glucoseData[value.toInt()].date;
              return Align(
                alignment: Alignment.center, // Center align the title
                child: Text(
                  convertDateTime(date?.add(Duration(hours: 6)), 'HH:mm'),
                  style: myText(fontSize: 10.sp, fontWeight: FontWeight.w400),
                ),
              );
            }
            return const Text('');
          }),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(isPressure: false),  // Wrap SideTitles inside AxisTitles
        ),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // Remove top titles
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // Remove right titles
      );

  LineChartBarData get _glucoseLineData => LineChartBarData(
        isCurved: true,
        color: AppColors.primary,
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        spots: List.generate(glucoseData.length, (index) {
          return FlSpot(index.toDouble(), glucoseData[index].glucose ?? 0);
        }),
      );
}

SideTitles leftTitles({required bool isPressure}) => SideTitles(
  showTitles: true,
  reservedSize: 25.w,  // You can adjust this based on your design requirements
  getTitlesWidget: (value, meta) {
    return Align(
      alignment: Alignment.center, // Center align the title
      child: Text(
        value.toStringAsFixed(0),  // This will display the value as an integer
        style: myText(fontSize: 10),  // Using the `myText` function for text styling
      ),
    );
  },
  interval: isPressure ? 50 : 5,  // Display a title every 50 (for pressure) or 5 (for glucose)
);
