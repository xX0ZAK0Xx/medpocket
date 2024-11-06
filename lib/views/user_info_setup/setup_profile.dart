import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpocket/configs/app_constants.dart';
import 'package:medpocket/configs/app_routes.dart';
import 'package:medpocket/utils/app_calculate_age.dart';
import 'package:medpocket/utils/utils.dart';
import 'package:medpocket/views/root.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../blocs/bloc.dart';
import '../../configs/app_sizes.dart';
import '../../configs/colors.dart';
import '../../widgets/widgets.dart';

class SetupProfile extends StatefulWidget {
  const SetupProfile({super.key});

  @override
  State<SetupProfile> createState() => _SetupProfileState();
}

class _SetupProfileState extends State<SetupProfile> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final ValueNotifier<DateTime?> dobNotifier = ValueNotifier(null);
  final formKey = GlobalKey<FormState>();

  // String selectedBloodGroup = 'A+';
  // String selectedGender = 'Male';
  // int height = 160;
  // int weight = 60;

  late ImageBloc imageBloc;
  late SetupProfileBloc setupProfileBloc;

  @override
  void initState() {
    super.initState();
    imageBloc = ImageBloc();
    setupProfileBloc = context.read<SetupProfileBloc>();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    ageController.dispose();
    phoneNumberController.dispose();
    dobNotifier.dispose();
    imageBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Setup Profile")),
      body: BlocListener<SetupProfileBloc, SetupProfileState>(
        listenWhen: (previous, current) => current is CreateSetupProfileFailedState || current is CreateSetupProfileLoadingState || current is CreateSetupProfileSuccessState,
        listener: (context, state) {
          if(state is CreateSetupProfileLoadingState){
            appLoadingDialog(context);
          }else if(state is CreateSetupProfileFailedState){
            AppRoutes.pop(context);
            appErrorDialog(context, state.errorMessage);
          }else if(state is CreateSetupProfileSuccessState){
            AppRoutes.pop(context);
            AppRoutes.pushAndRemoveUntil(context, RootScreen());            
          }
        },
        child: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.all(AppSizes.bodyPadding),
            children: [
              // Image Picker
              BlocBuilder<ImageBloc, ImageState>(
                bloc: imageBloc,
                builder: (context, state) {
                  return GestureDetector(
                    onTap: () => showImageSourceSheet(context, imageBloc, "profile"),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusBig),
                      child: Container(
                        height: 250.h,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          border: Border.all(color: state is ImageNotSelectState ? AppColors.red : Colors.grey),
                          borderRadius: BorderRadius.circular(AppSizes.borderRadiusBig),
                        ),
                        child: imageBloc.resizedImagePath.isNotEmpty
                          ? Image.file(
                              File(imageBloc.resizedImagePath), 
                              fit: BoxFit.cover,
                            )
                          : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt, size: 50.sp, color: state is ImageNotSelectState ? AppColors.red : Colors.grey),
                              SizedBox(height: AppSizes.bodyPadding),
                              Text("Profile Photo", style: myText(color: state is ImageNotSelectState ? AppColors.red : Colors.grey)),
                            ],
                          ),
                      ),
                    ),
                  );
                },
              ),
          
              SizedBox(
                height: AppSizes.bodyPadding * 2,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        AppDecoratedTextField(
                          textInputAction: TextInputAction.next,
                          labelText: "Full Name",
                          hintText: "Enter your full name",
                          keyboardType: TextInputType.text,
                          controller: fullNameController,
                          validator: (p0) => p0!.isEmpty ? "Please enter your full name" : null,
                        ),
                        SizedBox(height: AppSizes.bodyPadding * 2),
                        ValueListenableBuilder(
                          valueListenable: dobNotifier,
                          builder: (context, value, child) {
                            return Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: AppDecoratedTextField(
                                    readOnly: true,
                                    textInputAction: TextInputAction.next,
                                    labelText: "Date of Birth",
                                    hintText: "Select your date of birth",
                                    keyboardType: TextInputType.number,
                                    controller: TextEditingController(text: convertDateTime(value, 'dd MMM, yyyy')),
                                    onTap: () async{
                                        DateTime? selectedDate = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime(2000),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime.now(),
                                        );
                                        if (selectedDate != null) {
                                          dobNotifier.value = selectedDate;
                                        }
                                      },
                                      validator: (p0) => p0!.isEmpty ? "Please enter Date of Birth" : null,
                                  ),
                                ),
                                SizedBox(width: AppSizes.bodyPadding),
                                Expanded(
                                  flex: 1,
                                  child: AppDecoratedTextField(
                                    readOnly: true,
                                    textInputAction: TextInputAction.next,
                                    labelText: "Age",
                                    hintText: "",
                                    keyboardType: TextInputType.number,
                                    controller: TextEditingController(text: calculateAge(dobNotifier.value??DateTime.now()).toString()),
                                  ),
                                ),
                              ],
                            );
                          }
                        ),
                        SizedBox(height: AppSizes.bodyPadding * 2),
                        AppDecoratedTextField(
                          textInputAction: TextInputAction.next,
                          labelText: "Phone Number",
                          hintText: "Enter your phone number",
                          keyboardType: TextInputType.phone,
                          controller: phoneNumberController,
                          validator: (p0) => p0!.isEmpty ? "Please enter a phone number" : !isValidPhoneNumber(p0) ? "Please enter a valid phone number" : null,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: AppSizes.bodyPadding,
                  ),
                  Expanded(
                    flex: 1,
                    child: BlocBuilder<SetupProfileBloc, SetupProfileState>(
                      buildWhen: (previous, current) => current is ChangeFeetState || current is ChangeInchState,
                      builder: (context, state) {
                        return Column(
                          children: [
                            Text("Height",style: myText(fontWeight: FontWeight.w500)),
                            SizedBox(height: AppSizes.bodyPadding,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Feet",style: myText(fontWeight: FontWeight.w500, color: AppColors.secondary)),
                                    NumberPicker(
                                      itemCount: 3,
                                      value: setupProfileBloc.feet,
                                      selectedTextStyle: myText(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 20.sp),
                                      minValue: 2,
                                      maxValue: 10,
                                      onChanged: (value) => setupProfileBloc.add(ChangeFeetEvent(feet: value)),
                                      itemWidth: 30.w,
                                      itemHeight: 60.h,
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Inch",style: myText(fontWeight: FontWeight.w500, color: AppColors.secondary)),
                                    NumberPicker(
                                      itemWidth: 30.w,
                                      itemHeight: 60.h,
                                      itemCount: 3,
                                      value: setupProfileBloc.inch,
                                      selectedTextStyle: myText(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 20.sp),
                                      minValue: 0,
                                      maxValue: 11,
                                      onChanged: (value) => setupProfileBloc.add(ChangeInchEvent(inch: value)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.bodyPadding * 2),
          
              // Number Picker for Weight
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Weight (kg)", style: myText(fontWeight: FontWeight.w500)),
                  BlocBuilder<SetupProfileBloc, SetupProfileState>(
                    buildWhen: (previous, current) => current is ChangeWeightState,
                    builder: (context, state) {
                      return FittedBox(
                        child: NumberPicker(
                          value: setupProfileBloc.weight,
                          axis: Axis.horizontal,
                          itemCount: 5,
                          minValue: 30,
                          selectedTextStyle: myText(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 20.sp),
                          maxValue: 150,
                          onChanged: (value) => setupProfileBloc.add(ChangeWeightEvent(weight: value)),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: AppSizes.bodyPadding * 2),
              Row(
                children: [
                  Expanded(
                    child: BlocBuilder<SetupProfileBloc, SetupProfileState>(
                      buildWhen: (previous, current) => current is SelectBloodGroupState,
                      builder: (context, state) {
                        return AppDecoratedDropdown(
                          label: "Blood Group",
                          isRequired: true,
                          selectedValue: setupProfileBloc.bloodGroup,
                          items: const [
                            'A+',
                            'A-',
                            'B+',
                            'B-',
                            'AB+',
                            'AB-',
                            'O+',
                            'O-'
                          ],
                          onChanged: (value) {
                            setupProfileBloc.add(SelecteBloodGroupEvent(bloodGroup: value!));
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(width: AppSizes.bodyPadding),
                  Expanded(
                    child: BlocBuilder<SetupProfileBloc, SetupProfileState>(
                      buildWhen: (previous, current) => current is SelectGenderState,
                      builder: (context, state) {
                        return AppDecoratedDropdown(
                          label: "Gender",
                          isRequired: true,
                          selectedValue: setupProfileBloc.gender,
                          items: const ['Male', 'Female', 'Other'],
                          onChanged: (value) {
                            setupProfileBloc.add(SelecteGenderEvent(gender: value!));
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.bodyPadding * 2),
              // Save Button
              AppButton(
                press: () {
                  if(formKey.currentState!.validate()){
                    imageBloc.add(ValidateImageEvent());
                    if(imageBloc.resizedImagePath.isNotEmpty){
                      logger.d("hello");
                      context.read<SetupProfileBloc>().add(
                        CreateSetupProfileEvent(
                          fullName: fullNameController.text.trim(), 
                          phoneNumber: phoneNumberController.text.trim(), 
                          bloodGroup: setupProfileBloc.bloodGroup, 
                          dateOfBirth: convertDateTime(dobNotifier.value, 'yyyy-MM-dd'), 
                          gender: setupProfileBloc.gender, 
                          image: imageBloc.resizedImagePath, 
                          height: feetInchesToCm(foot: setupProfileBloc.feet, inch: setupProfileBloc.inch), 
                          weight: setupProfileBloc.weight,
                        )
                      );
                    }
                  }
                },
                text: "Save Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}