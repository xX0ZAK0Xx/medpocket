
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:medpocket/views/medicine/segments/medicine_update_bottom_sheet.dart';

import '../../../configs/app_sizes.dart';
import '../../../configs/colors.dart';
import '../../../models/model.dart';
import '../../../widgets/widgets.dart';

class MedicineTile extends StatefulWidget {
  final MedicineData medicine;
  final ValueNotifier nextMedicine, nextMedicineShift;
  final VoidCallback findNextMedicine;
  final int shift;
  const MedicineTile({super.key, required this.medicine, required this.nextMedicine, required this.findNextMedicine, required this.nextMedicineShift, required this.shift});

  @override
  MedicineTileState createState() => MedicineTileState();
}

class MedicineTileState extends State<MedicineTile> {
  late ValueNotifier<bool> hasTaken;

  @override
  void initState() {
    super.initState();
    hasTaken = ValueNotifier(widget.medicine.hasTaken ?? false);
  }

  void _toggleTaken() {
    hasTaken.value = !hasTaken.value;
    
    // Update hasTaken in the actual model
    widget.medicine.hasTaken = hasTaken.value;

    // Find and update next medicine
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.nextMedicine.value = null; // Reset first
      widget.findNextMedicine(); // Find new next medicine
    });
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => appModalBottomSheet(context: context, content: MedicineUpdateBottomSheet(id: widget.medicine.id??"",)),
      child: ValueListenableBuilder(
        valueListenable: widget.nextMedicine,
        builder: (_, nextId, __) {
          return ValueListenableBuilder<bool>(
            valueListenable: hasTaken,
            builder: (context, takenValue, child) {
              bool isNextToTake = widget.medicine.id == nextId && widget.nextMedicineShift.value == widget.shift;
              return Container(
                padding: EdgeInsets.all(AppSizes.bodyPadding * (isNextToTake?2:1)),
                margin: EdgeInsets.symmetric(vertical: AppSizes.bodyPadding / 2),
                decoration: BoxDecoration(
                  gradient: isNextToTake 
                    ? LinearGradient(
                      colors: [
                        Color(0xffdd2476),
                        Color(0xffff512f),
                      ],
                      stops: [0, 1],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ) : null, // Only apply gradient if it's the next medicine
                  color: isNextToTake ? null : (hasTaken.value ? Colors.white.withOpacity(0.1) : Colors.white),      
                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusBig * (isNextToTake?8:1)),
                  // boxShadow: [
                  //   AppColors.redShadow()
                  // ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          widget.medicine.type?.toLowerCase() == "tablet" 
                          ? HugeIcon(
                            icon: HugeIcons.strokeRoundedMedicineBottle02,
                            color: isNextToTake ? AppColors.white : AppColors.primary,
                            size: 24.0.sp,
                          ) : widget.medicine.type?.toLowerCase() == "capsule"
                          ? HugeIcon(
                            icon: HugeIcons.strokeRoundedMedicine02,
                            color: isNextToTake ? AppColors.white : AppColors.primary,
                            size: 24.0.sp,
                          ) : HugeIcon(
                            icon: HugeIcons.strokeRoundedInjection,
                            color: isNextToTake ? AppColors.white : AppColors.primary,
                            size: 24.0.sp,
                          ),
                          SizedBox(width: AppSizes.bodyPadding),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.medicine.medicineName ?? "Unknown Medicine",
                                  // " kfSGF AEUGAW FOIUAWG FfsIU faius fiau if",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: myText(
                                    fontWeight: takenValue ? FontWeight.w500 : FontWeight.w700,
                                    fontSize: 16.sp,
                                    color:  isNextToTake ? AppColors.white : AppColors.primary,
                                  ),
                                ),
                                Text(
                                  widget.medicine.type ?? "Unknown Type",
                                  style: myText(fontSize: 14.sp, color: isNextToTake ? AppColors.white : AppColors.primary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedDish02,
                            color: isNextToTake ? AppColors.white : AppColors.primary,
                            size: 24.0.sp,
                          ),
                          SizedBox(width: AppSizes.bodyPadding,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.medicine.afterMeal == false ? "Before" : "After", style: myText(fontWeight: takenValue ? FontWeight.w400 : FontWeight.bold , fontSize: 18.sp, color: isNextToTake ? AppColors.white : AppColors.primary),),
                              // SizedBox(height: AppSizes.bodyPadding / 2,),
                              Text("Meal", style: myText(color: isNextToTake ? AppColors.white : AppColors.primary),)
                            ],
                          )
                        ],
                      ),
                    ),
                    isNextToTake 
                    ? IconButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(AppColors.white)
                        ),
                        icon: Icon(
                          takenValue ? Icons.undo : Icons.check,
                          color: AppColors.secondary,
                          size: 26,
                        ),
                        onPressed: _toggleTaken,
                      )
                    : hasTaken.value == true 
                      ? IconButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(AppColors.primary)
                        ),
                        icon: Icon(
                          takenValue ? Icons.undo : Icons.check,
                          color: Colors.white,
                          size: 26,
                        ),
                        onPressed: _toggleTaken,
                      ) : SizedBox.shrink()
                  ],
                ),
              );
            },
          );
        }
      ),
    );
  }
}
