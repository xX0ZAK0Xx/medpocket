
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
        MedicineShiftWidget(shiftDose: widget.todaysMedicineData.morning??[], title: 'Morning',),
        
        //?Afternoon
        if(widget.todaysMedicineData.afternoon?.isNotEmpty == true)
        MedicineShiftWidget(shiftDose: widget.todaysMedicineData.afternoon??[], title: 'Noon',),
        
        //?Evening
        if(widget.todaysMedicineData.evening?.isNotEmpty == true)
        MedicineShiftWidget(shiftDose: widget.todaysMedicineData.evening??[], title: 'Evening',),
      ],
    );
  }
}

class MedicineShiftWidget extends StatelessWidget {
  const MedicineShiftWidget({
    super.key, required this.shiftDose, required this.title,
  });
  final List<MedicineData> shiftDose;
  final String title;

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
          return MedicineTile(medicine: medicine,); 
        }),
        SizedBox(height: AppSizes.bodyPadding,),
      ],
    );
  }
}


class MedicineTile extends StatefulWidget {
  final MedicineData medicine;
  const MedicineTile({super.key, required this.medicine});

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
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: hasTaken,
      builder: (context, value, child) {
        return Container(
          padding: EdgeInsets.all(AppSizes.bodyPadding),
          margin: EdgeInsets.symmetric(vertical: AppSizes.bodyPadding / 2),
          decoration: BoxDecoration(
            color: value ? Colors.white.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusBig),
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
                      color: AppColors.primary,
                      size: 24.0.sp,
                    ) : widget.medicine.type?.toLowerCase() == "capsule"
                    ? HugeIcon(
                      icon: HugeIcons.strokeRoundedMedicine02,
                      color: AppColors.primary,
                      size: 24.0.sp,
                    ) : HugeIcon(
                      icon: HugeIcons.strokeRoundedInjection,
                      color: AppColors.primary,
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
                              fontWeight: value ? FontWeight.w500 : FontWeight.w700,
                              fontSize: 16.sp,
                              color:  AppColors.primary,
                            ),
                          ),
                          Text(
                            widget.medicine.type ?? "Unknown Type",
                            style: myText(fontSize: 14.sp, color: AppColors.primary),
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
                      color: AppColors.textColorb2,
                      size: 24.0.sp,
                    ),
                    SizedBox(width: AppSizes.bodyPadding,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.medicine.afterMeal == false ? "Before" : "After", style: myText(fontWeight: value ? FontWeight.w400 : FontWeight.bold , fontSize: 18.sp, color: AppColors.textColorb1),),
                        // SizedBox(height: AppSizes.bodyPadding / 2,),
                        Text("Meal", style: myText(color: AppColors.textColorb3),)
                      ],
                    )
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  value ? Icons.undo : Icons.check,
                  color: value ? Colors.orange : Colors.green,
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
}
