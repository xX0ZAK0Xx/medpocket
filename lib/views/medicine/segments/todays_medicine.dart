
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:medpocket/configs/app_sizes.dart';
import 'package:medpocket/configs/colors.dart';
import 'package:medpocket/widgets/widgets.dart';

import '../../../models/model.dart';

class TodaysMedicineList extends StatefulWidget {
  const TodaysMedicineList({
    super.key, required this.todaysMedicineData,
  });
  final TodaysMedicineData todaysMedicineData;

  @override
  State<TodaysMedicineList> createState() => _TodaysMedicineListState();
}

class _TodaysMedicineListState extends State<TodaysMedicineList> {
  final ValueNotifier<int?> firstToTake = ValueNotifier<int?>(null);
  final ValueNotifier<String?> nextMedicine= ValueNotifier<String?>(null);

  @override
  void initState() {
    super.initState();
    findNextMedicine();
  }

  void findNextMedicine() {
    List<MedicineData> allMedicines = [
      ...(widget.todaysMedicineData.morning ?? []),
      ...(widget.todaysMedicineData.afternoon ?? []),
      ...(widget.todaysMedicineData.evening ?? [])
    ];

    // Find the first medicine where `hasTaken` is false
    int? nextIndex = allMedicines.indexWhere((medicine) => medicine.hasTaken == false);

    // Update the notifier
    nextMedicine.value = nextIndex != -1 ? allMedicines[nextIndex].id : null; 
  }


  @override
  Widget build(BuildContext context) {
    int todaysTotal = (widget.todaysMedicineData.afternoon?.length??0) + (widget.todaysMedicineData.morning?.length??0) + (widget.todaysMedicineData.evening?.length??0);
    return ListView(
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: AppSizes.bodyPadding),
      children: [
        Container(
          padding: EdgeInsets.all(AppSizes.bodyPadding),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffff512f), Color(0xffdd2476)],
              stops: [0, 1],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusBig)    
          ),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
            style: myText(color: AppColors.white, fontWeight: FontWeight.w500),
            children: [
              TextSpan(text: "You have "),
              TextSpan(text: "$todaysTotal", style: myText(fontWeight: FontWeight.w900, fontSize: 20.sp, color: AppColors.white)),
              TextSpan(text: " Medicine(s) today"),
            ]
          )),
        ),
        SizedBox(height: AppSizes.bodyPadding,),
        //?Morning,
        if(widget.todaysMedicineData.morning?.isNotEmpty == true)
        MedicineShiftWidget(shiftDose: widget.todaysMedicineData.morning??[], title: 'Morning', nextMedicine: nextMedicine, findNextMedicine: ()=>findNextMedicine(),),
        
        //?Afternoon
        if(widget.todaysMedicineData.afternoon?.isNotEmpty == true)
        MedicineShiftWidget(shiftDose: widget.todaysMedicineData.afternoon??[], title: 'Noon', nextMedicine: nextMedicine, findNextMedicine: ()=>findNextMedicine()),
        
        //?Evening
        if(widget.todaysMedicineData.evening?.isNotEmpty == true)
        MedicineShiftWidget(shiftDose: widget.todaysMedicineData.evening??[], title: 'Evening', nextMedicine: nextMedicine, findNextMedicine: ()=>findNextMedicine()),
      ],
    );
  }
}

class MedicineShiftWidget extends StatelessWidget {
  const MedicineShiftWidget({
    super.key, required this.shiftDose, required this.title, required this.nextMedicine, required this.findNextMedicine,
  });
  final List<MedicineData> shiftDose;
  final String title;
  final ValueNotifier nextMedicine;
  final  VoidCallback findNextMedicine;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: myText(fontWeight: FontWeight.bold, fontSize: 18.sp, color: AppColors.primary),),
            Text("Total: ${shiftDose.length}", style: myText(color: AppColors.blue, fontWeight: FontWeight.w500),)
          ],
        ),
        SizedBox(height: AppSizes.bodyPadding,),
        ...shiftDose.map((medicine){
          if(nextMedicine.value == null && medicine.hasTaken == true){
            //make it the next to take 
          }
          return MedicineTile(medicine: medicine, nextMedicine: nextMedicine, findNextMedicine: ()=>findNextMedicine(),); 
        }),
        SizedBox(height: AppSizes.bodyPadding,),
      ],
    );
  }
}


class MedicineTile extends StatefulWidget {
  final MedicineData medicine;
  final ValueNotifier nextMedicine;
  final VoidCallback findNextMedicine;
  const MedicineTile({super.key, required this.medicine, required this.nextMedicine, required this.findNextMedicine});

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
    return ValueListenableBuilder(
      valueListenable: widget.nextMedicine,
      builder: (_, nextId, __) {
        return ValueListenableBuilder<bool>(
          valueListenable: hasTaken,
          builder: (context, takenValue, child) {
            bool isNextToTake = widget.medicine.id == nextId;
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
                  IconButton(
                    icon: Icon(
                      takenValue ? Icons.undo : Icons.check,
                      color: takenValue ? Colors.orange : Colors.green,
                      size: 26,
                    ),
                    onPressed: _toggleTaken,
                  ),
                ],
              ),
            );
          },
        );
      }
    );
  }
}
