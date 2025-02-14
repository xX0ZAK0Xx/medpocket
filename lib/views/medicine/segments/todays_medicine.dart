
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpocket/configs/app_sizes.dart';
import 'package:medpocket/configs/colors.dart';
import 'package:medpocket/widgets/widgets.dart';

import '../../../models/model.dart';
import 'medicine_tile.dart';

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
  final ValueNotifier<int?> nextMedicineShift = ValueNotifier<int?>(null);

  @override
  void dispose() {
    firstToTake.dispose();
    nextMedicine.dispose();
    nextMedicineShift.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // findNextMedicine();
  }

  void findNextMedicine() {
    // Define the shifts in order
    List<List<MedicineData>?> shifts = [
      widget.todaysMedicineData.morning,
      widget.todaysMedicineData.afternoon,
      widget.todaysMedicineData.evening
    ];

    // Reset values before searching
    nextMedicine.value = null;
    nextMedicineShift.value = null;

    // Iterate through the shifts in order (morning -> afternoon -> evening)
    for (int shiftIndex = 0; shiftIndex < shifts.length; shiftIndex++) {
      List<MedicineData>? shift = shifts[shiftIndex];
      if (shift != null) {
        for (MedicineData medicine in shift) {
          if (!(medicine.hasTaken??false)) {
            nextMedicineShift.value = shiftIndex;
            nextMedicine.value = medicine.id;
            return; // Exit once the first untaken medicine is found
          }
        }
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    findNextMedicine();
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
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusBig * 5)    
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
        MedicineShiftWidget(shiftDose: widget.todaysMedicineData.morning??[], title: 'Morning', nextMedicine: nextMedicine, findNextMedicine: ()=>findNextMedicine(), nextMedicineShift: nextMedicineShift, shift: 0,),
        
        //?Afternoon
        if(widget.todaysMedicineData.afternoon?.isNotEmpty == true)
        MedicineShiftWidget(shiftDose: widget.todaysMedicineData.afternoon??[], title: 'Noon', nextMedicine: nextMedicine, findNextMedicine: ()=>findNextMedicine(), nextMedicineShift: nextMedicineShift, shift: 1,),
        
        //?Evening
        if(widget.todaysMedicineData.evening?.isNotEmpty == true)
        MedicineShiftWidget(shiftDose: widget.todaysMedicineData.evening??[], title: 'Evening', nextMedicine: nextMedicine, findNextMedicine: ()=>findNextMedicine(), nextMedicineShift: nextMedicineShift, shift: 2,),
      ],
    );
  }
}

class MedicineShiftWidget extends StatelessWidget {
  const MedicineShiftWidget({
    super.key, required this.shiftDose, required this.title, required this.nextMedicine, required this.findNextMedicine, required this.nextMedicineShift, required this.shift,
  });
  final List<MedicineData> shiftDose;
  final String title;
  final ValueNotifier nextMedicine, nextMedicineShift;
  final  VoidCallback findNextMedicine;
  final int shift;

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
          return MedicineTile(medicine: medicine, nextMedicine: nextMedicine, findNextMedicine: ()=>findNextMedicine(), nextMedicineShift: nextMedicineShift, shift: shift,); 
        }),
        SizedBox(height: AppSizes.bodyPadding,),
      ],
    );
  }
}
