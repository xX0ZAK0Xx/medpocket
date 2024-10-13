import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../configs/app_sizes.dart';
import '../configs/colors.dart';
import 'widgets.dart'; // Assuming you have a colors config

class AppDecoratedDropdown extends StatelessWidget {
  final String? selectedValue;
  final List<String> items;
  final Function(String?)? onChanged;
  final String? label;
  final bool? isRequired; // Add isRequired flag if you want to mark required fields

  const AppDecoratedDropdown({
    super.key,
    this.selectedValue,
    required this.items,
    this.onChanged,
    this.label,
    this.isRequired,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h, // Set the fixed height
      padding: EdgeInsets.symmetric(horizontal: AppSizes.bodyPadding),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 225, 228, 235),
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusBig * 1.5),
      ),
      child: Stack(
        children: [
          // Positioned label at the top-left
          if (label != null)
            Positioned(
              top: 5.h,
              left: 5.w,
              child: Row(
                children: [
                  Text(
                    label!,
                    style: myText(color:AppColors.textColorb3, fontWeight: FontWeight.w500),
                  ),
                  if (isRequired ?? false)
                    Text(
                      " *",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.red, // Assuming you have an AppColors class with 'red'
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
          // Positioned dropdown at the bottom-left
          Positioned(
            bottom: -5.h,
            left: 5.w,
            right: 5.w,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedValue,
                padding: const EdgeInsets.all(0),
                menuMaxHeight: AppSizes.height(context) * 0.4,
                onChanged: onChanged,
                items: items
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        ))
                    .toList(),
                isExpanded: true,
                style: myText(fontSize: 14.sp, fontWeight: FontWeight.w400, color: AppColors.textColorb1),
                dropdownColor: Colors.white, // Dropdown menu background color
              ),
            ),
          ),
        ],
      ),
    );
  }
}
