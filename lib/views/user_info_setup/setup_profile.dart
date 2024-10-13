import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpocket/utils/utils.dart';
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
    imageBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Setup Profile")),
        body: ListView(
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
                            Icon(Icons.camera_alt, size: 50.sp, color: Colors.grey),
                            SizedBox(height: AppSizes.bodyPadding),
                            Text("Profile Photo", style: myText()),
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
                      ),
                      SizedBox(height: AppSizes.bodyPadding * 2),
                      AppDecoratedTextField(
                        textInputAction: TextInputAction.next,
                        labelText: "Age",
                        hintText: "Enter your age",
                        keyboardType: TextInputType.number,
                        controller: ageController,
                      ),
                      SizedBox(height: AppSizes.bodyPadding * 2),
                      AppDecoratedTextField(
                        textInputAction: TextInputAction.next,
                        labelText: "Phone Number",
                        hintText: "Enter your phone number",
                        keyboardType: TextInputType.phone,
                        controller: phoneNumberController,
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
                    buildWhen: (previous, current) => current is ChangeHeightState,
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Height (cm)",
                              style: myText(fontWeight: FontWeight.w500)),
                          NumberPicker(
                            haptics: true,
                            itemCount: 4,
                            value: setupProfileBloc.height,
                            selectedTextStyle: myText(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 20.sp),
                            minValue: 100,
                            maxValue: 220,
                            onChanged: (value) => setupProfileBloc.add(ChangeHeightEvent(height: value)),
                          ),
                          Text(cmToFeetInch(setupProfileBloc.height.toDouble()))
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
                    return NumberPicker(
                      value: setupProfileBloc.weight,
                      axis: Axis.horizontal,
                      itemCount: 4,
                      minValue: 30,
                      selectedTextStyle: myText(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 20.sp),
                      maxValue: 150,
                      onChanged: (value) => setupProfileBloc.add(ChangeWeightEvent(weight: value)),
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
                // Handle form submission
              },
              text: "Save Profile",
            ),
          ],
        ));
  }
}