
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:medpocket/configs/app_sizes.dart';
import 'package:medpocket/configs/colors.dart';
import 'package:medpocket/widgets/widgets.dart';

import '../../../models/model.dart';

class TodaysMedicineList extends StatelessWidget {
  const TodaysMedicineList({
    super.key, required this.todaysMedicineData,
  });
  final TodaysMedicineData todaysMedicineData;

  @override
  Widget build(BuildContext context) {
    int todaysTotal = (todaysMedicineData.afternoon?.length??0) + (todaysMedicineData.morning?.length??0) + (todaysMedicineData.evening?.length??0);
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
        if(todaysMedicineData.morning?.isNotEmpty == true)
        MedicineShiftWidget(shiftDose: todaysMedicineData.morning??[], title: 'Morning',),
        
        //?Afternoon
        if(todaysMedicineData.afternoon?.isNotEmpty == true)
        MedicineShiftWidget(shiftDose: todaysMedicineData.afternoon??[], title: 'Noon',),
        
        //?Evening
        if(todaysMedicineData.evening?.isNotEmpty == true)
        MedicineShiftWidget(shiftDose: todaysMedicineData.evening??[], title: 'Evening',),
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
          return Slidable(
            // Specify a key if the Slidable is dismissible.
            key: const ValueKey(0),

            // The start action pane is the one at the left or the top side.
            startActionPane: ActionPane(
              // A motion is a widget used to control how the pane animates.
              motion: const ScrollMotion(),

              // A pane can dismiss the Slidable.
              dismissible: DismissiblePane(onDismissed: () {}),

              // All actions are defined in the children parameter.
              children: [
                // A SlidableAction can have an icon and/or a label.
                SlidableAction(
                  onPressed: (context) {
                    
                  },
                  backgroundColor: Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
                SlidableAction(
                  onPressed: (context) {
                    
                  },
                  backgroundColor: Color(0xFF21B7CA),
                  foregroundColor: Colors.white,
                  icon: Icons.share,
                  label: 'Share',
                ),
              ],
            ),

            // The end action pane is the one at the right or the bottom side.
            endActionPane: ActionPane(
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  // An action can be bigger than the others.
                  flex: 2,
                  onPressed: (context) {
                    
                  },
                  backgroundColor: Color(0xFF7BC043),
                  foregroundColor: Colors.white,
                  icon: Icons.archive,
                  label: 'Archive',
                ),
                SlidableAction(
                  onPressed: (context) {
                    
                  },
                  backgroundColor: Color(0xFF0392CF),
                  foregroundColor: Colors.white,
                  icon: Icons.save,
                  label: 'Save',
                ),
              ],
            ),

            // The child of the Slidable is what the user sees when the
            // component is not dragged.
            child: const ListTile(title: Text('Slide me')),
          );
        })
      ],
    );
  }
}
