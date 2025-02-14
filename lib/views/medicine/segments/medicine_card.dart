import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../configs/app_constants.dart';
import '../../../configs/app_sizes.dart';
import '../../../configs/colors.dart';
import '../../../models/model.dart';
import '../../../widgets/widgets.dart';

class MedicineCard extends StatefulWidget {
  const MedicineCard({super.key, required this.medicine, required this.index, required this.delete});

  final Medicine medicine; 
  final int index;
  final VoidCallback delete;

  @override
  State<MedicineCard> createState() => _MedicineCardState();
}

class _MedicineCardState extends State<MedicineCard> {
  final ValueNotifier<String> typeNotifier = ValueNotifier<String>("");
  final TextEditingController nameController = TextEditingController();
  ValueNotifier<DateTimeRange?> dateRangeNotifier = ValueNotifier<DateTimeRange?>(null);
  Dose morningDose = Dose();
  Dose noonDose = Dose();
  Dose eveningDose = Dose();

  @override
  void initState() {
    typeNotifier.value = widget.medicine.type.toLowerCase() == "inj"
          ? "Injection"
          : widget.medicine.type.toLowerCase() == "cap"
              ? "Capsule"
              : widget.medicine.type.toLowerCase() == "drop"
                  ? "Drop"
                  : "Tablet";

    nameController.text = widget.medicine.name;
    dateRangeNotifier.value = DateTimeRange(start: DateTime.now(), end: DateTime.now().add(Duration(days: 7)));
    morningDose.take?.value = widget.medicine.isMorning;
    morningDose.afterMeal?.value = true;
    noonDose.take?.value = widget.medicine.isNoon;
    noonDose.afterMeal?.value = true;
    eveningDose.take?.value = widget.medicine.isEvening;
    eveningDose.afterMeal?.value = true;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
            left: AppSizes.bodyPadding,
            right: AppSizes.bodyPadding,
            bottom: AppSizes.bodyPadding,
          ),
          margin: EdgeInsets.only(top: AppSizes.bodyPadding),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary),
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusBig * 3),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSizes.bodyPadding / 3),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                alignment: WrapAlignment.spaceEvenly,
                children: AppConstants.medicineTypes.map((type) {
                  return ValueListenableBuilder(
                    valueListenable: typeNotifier,
                    builder: (_, value, __) {
                      final bool isSelected = value == type;
                      return ChoiceChip(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.bodyPadding * 4),
                          side: BorderSide(color: AppColors.primary),
                        ),
                        label: Text(type,
                            style: myText(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? AppColors.white : AppColors.primary)),
                        selected: isSelected,
                        selectedColor: AppColors.primary,
                        showCheckmark: false,
                        onSelected: (selected) {
                          typeNotifier.value = selected ? type : "";
                        },
                      );
                    },
                  );
                }).toList(),
              ),
              AppDecoratedTextField(
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                fillColor: AppColors.bg,
                labelText: "Name",
                hintText: "Name of the medicine",
                controller: nameController,
                validator: (p0) => p0!.isEmpty ? "Please enter a name" : null,
              ),
              SizedBox(height: AppSizes.bodyPadding),
              _buildDosageSelection(
                Dosage(
                  morning: morningDose,
                  afternoon: noonDose,
                  evening: eveningDose,
                ),
              ),
              SizedBox(height: AppSizes.bodyPadding),
              Text("Duration", style: myText(fontSize: 16.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 8.h),
              DateRangeSelector(
                dateRangeNotifier: dateRangeNotifier,
                initalDate: DateTime(2025),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: widget.delete, // ✅ Now correctly calling the delete function
          child: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusBig * 6),
            ),
            padding: EdgeInsets.all(AppSizes.bodyPadding),
            child: Text(
              "Delete",
              textAlign: TextAlign.center,
              style: myText(fontWeight: FontWeight.bold, fontSize: 14.sp, color: AppColors.white),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildDosageSelection(Dosage? dosage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Dosage", style: myText(fontSize: 16.sp, fontWeight: FontWeight.bold)),
        SizedBox(height: 8.h),
        Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildDoseToggle("Morning", dosage?.morning),
            _buildDoseToggle("Afternoon", dosage?.afternoon),
            _buildDoseToggle("Evening", dosage?.evening),
          ],
        ),
      ],
    );
  }

  Widget _buildDoseToggle(String time, Dose? dose) {
    final ValueNotifier<bool> takeNotifier = dose?.take??ValueNotifier(false);
    final ValueNotifier<bool> afterMealNotifier = dose?.afterMeal ?? ValueNotifier<bool>(false);
    return ValueListenableBuilder(
      valueListenable: takeNotifier,
      builder: (_, takeValue, __) {
        return GestureDetector(
          onTap: () => takeNotifier.value = !takeValue,
          child: Container(
            padding: EdgeInsets.all(AppSizes.bodyPadding ),
            margin: EdgeInsets.only(bottom:  AppSizes.bodyPadding),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                AppColors.redShadow()
              ],
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusBig * 4)
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ChoiceChip(
                  shape: CircleBorder(
                    side: BorderSide(color: AppColors.primary)
                  ),
                  label: Text(takeValue ? "1" : "0", style: myText(fontSize: 14.sp, fontWeight: FontWeight.bold, color: takeValue ? AppColors.white : AppColors.primary)),
                  selected: takeValue,
                  backgroundColor: AppColors.white,
                  selectedColor: AppColors.primary,
                  showCheckmark: false,
                  onSelected: (selected) {
                    takeNotifier.value = selected;
                  },
                ),
                Expanded(child: Text(time, style: myText(fontSize: 14.sp, fontWeight: FontWeight.w500))),
                ValueListenableBuilder(
                  valueListenable: afterMealNotifier,
                  builder: (_, afterMealValue, __) {
                    return CupertinoSlidingSegmentedControl(
                      backgroundColor: AppColors.bg,
                      thumbColor: takeValue ?AppColors.primary : AppColors.grey,
                      groupValue: afterMealValue,
                      children: {
                        false : buildSegment("Before\nMeal", afterMealValue == false, selectedTextColor: AppColors.white, textColor: AppColors.primary),
                        true : buildSegment("After\nMeal", afterMealValue == true, selectedTextColor: AppColors.white, textColor: AppColors.primary),
                      },
                      onValueChanged: (value) {
                        if(takeValue){
                          afterMealNotifier.value = value ?? false;
                        }
                      },
                    );
                  },
                ),
                SizedBox(width: AppSizes.bodyPadding,)
              ],
            ),
          ),
        );
      }
    );
  }
}


class Medicine {
  final String type;
  final String name;
  final bool isMorning, isNoon, isEvening;

  Medicine({
    required this.type,
    required this.name,
    required this.isMorning,
    required this.isNoon,
    required this.isEvening,
  });
}
