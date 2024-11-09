import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class BlankGraph extends StatelessWidget {
  const BlankGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(5, (index) {
            // Generate random heights for the bars
            double height = Random().nextDouble() * 150 + 50; // Random height between 50 and 200
            return Container(
              width: 10.w,
              height: height,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8),
              ),
            );
          }),
        ),
      ),
    );
  }
}
