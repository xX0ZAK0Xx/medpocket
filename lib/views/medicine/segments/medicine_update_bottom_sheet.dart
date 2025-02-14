import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:medpocket/configs/app_constants.dart';
import 'package:medpocket/configs/app_routes.dart';
import 'package:medpocket/configs/app_sizes.dart';
import 'package:medpocket/configs/colors.dart';
import '../../../blocs/bloc.dart';
import '../../../models/model.dart';
import '../../../widgets/widgets.dart';

class MedicineUpdateBottomSheet extends StatefulWidget {
  const MedicineUpdateBottomSheet({super.key, required this.id});
  final String id;

  @override
  State<MedicineUpdateBottomSheet> createState() => _MedicineUpdateBottomSheetState();
}

class _MedicineUpdateBottomSheetState extends State<MedicineUpdateBottomSheet> {
  final ValueNotifier<String> typeNotifier = ValueNotifier<String>("");
  ValueNotifier<DateTimeRange?> dateRangeNotifier= ValueNotifier<DateTimeRange?>(null);
  final TextEditingController nameController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    typeNotifier.dispose();
    dateRangeNotifier.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    context.read<MedicineBloc>().add(GetSingleMedicineEvent(medicineId: widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicineBloc, MedicineState>(
      buildWhen: (previous, current) => current is GetSingleMedicineLoadingState || current is GetSingleMedicineSuccessState || current is GetSingleMedicineFailedState,
      builder: (context, state) {
        if (state is GetSingleMedicineLoadingState) {
          return Center(child: CircularProgressIndicator.adaptive());
        } else if (state is GetSingleMedicineSuccessState) {
          typeNotifier.value = state.medicine.type?.text ?? "";
          dateRangeNotifier.value = DateTimeRange(start: state.medicine.duration?.value.start??DateTime.now(), end: state.medicine.duration?.value.end??DateTime.now());
          nameController.text = state.medicine.medicineName?.text??"";

          return Form(
            key: formKey,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: AppSizes.bodyPadding),
              children: [
                // Medicine Type Selection
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
                            side: BorderSide(color: AppColors.primary)
                          ),
                          label: Text(type, style: myText(fontSize: 14.sp, fontWeight: FontWeight.bold, color: isSelected ? AppColors.white : AppColors.primary)),
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
                SizedBox(height: AppSizes.bodyPadding),
                
                // Medicine Name
                AppDecoratedTextField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  fillColor: AppColors.white,
                  labelText: "Name",
                  hintText: "Name of the medicine",
                  controller: nameController,
                  validator: (p0) => p0!.isEmpty ? "Please enter a name" : null,
                ),
                SizedBox(height: AppSizes.bodyPadding * 3),
                
                // Description
                // AppDecoratedTextField(
                //   keyboardType: TextInputType.text,
                //   textInputAction: TextInputAction.done,
                //   labelText: "Description",
                //   hintText: "Enter some description",
                //   controller: state.medicine.description ?? TextEditingController(),
                // ),
                // SizedBox(height: AppSizes.bodyPadding),
                
                // Dosage Selection
                _buildDosageSelection(state.medicine.dosage?.value),
                SizedBox(height: AppSizes.bodyPadding),
                DateRangeSelector(dateRangeNotifier: dateRangeNotifier,initalDate: DateTime(2025),),
                SizedBox(height: AppSizes.bodyPadding * 2),
                
                // Save Button,
                Row(
                  children: [
                    IconButton(onPressed: (){
                      
                    }, icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedDelete02,
                      color: AppColors.primary,
                      size: 24.0,
                    )),
                    Expanded(
                      child: AppButton(text: "Save", press: (){
                        // logger.f("after meal: ${state.medicine.dosage?.value.morning?.afterMeal??false}");
                        AppRoutes.pop(context);
                        if(formKey.currentState!.validate()){
                          context.read<MedicineBloc>().add(UpdateMedicineEvent(
                            token: context.read<AuthBloc>().token??"", 
                            medicineId: widget.id, 
                            name: nameController.text.trim(), 
                            type: typeNotifier.value, 
                            description: "", 
                            morningTake: state.medicine.dosage?.value.morning?.take??false, 
                            morningAfterMeal: state.medicine.dosage?.value.morning?.afterMeal??false, 
                            afterNoonTake: state.medicine.dosage?.value.afternoon?.take??false, 
                            afterNoonAfterMeal: state.medicine.dosage?.value.afternoon?.afterMeal??false, 
                            eveningTake: state.medicine.dosage?.value.evening?.take??false, 
                            eveningAfterMeal: state.medicine.dosage?.value.evening?.afterMeal??false, 
                            start: state.medicine.duration?.value.start??DateTime.now(),
                            end: state.medicine.duration?.value.end??DateTime.now()),
                          );
                        }
                      }),
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.bodyPadding,)
              ],
            ),
          );
        } else if (state is GetSingleMedicineFailedState) {
          return _buildErrorState(state.errorMessage);
        }
        return _buildErrorState("Something went wrong");
      },
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
    final ValueNotifier<bool> takeNotifier = ValueNotifier<bool>(dose?.take ?? false);
    final ValueNotifier<bool> afterMealNotifier = ValueNotifier<bool>(dose?.afterMeal ?? false);
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

                // SwitchListTile(
                //   title: Text("Take"),
                //   value: takeNotifier.value,
                //   onChanged: (value) => takeNotifier.value = value,
                // ),
                // SwitchListTile(
                //   title: Text("After Meal"),
                //   value: afterMealNotifier.value,
                //   onChanged: (value) => afterMealNotifier.value = value,
                // ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildErrorState(String message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HugeIcon(
          icon: HugeIcons.strokeRoundedAlertCircle,
          color: AppColors.primary,
          size: 50.0.sp,
        ),
        SizedBox(height: 20.h),
        Text(message, style: myText(fontSize: 24.sp, color: AppColors.primary)),
        SizedBox(height: 50.h),
      ],
    );
  }
}
