import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:lottie/lottie.dart';
import 'package:medpocket/configs/app_routes.dart';
import 'package:medpocket/configs/colors.dart';

import '../../../blocs/bloc.dart';
import '../../../configs/app_constants.dart';
import '../../../configs/app_sizes.dart';
import '../../../models/model.dart';
import '../../../widgets/widgets.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final ValueNotifier<List<String>> _pictures = ValueNotifier([]);
  final ValueNotifier<List<Medicine>> _medicinesWithDosage = ValueNotifier([]);

  @override
  void dispose() {
    _pictures.dispose();
    _medicinesWithDosage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MedicineBloc, MedicineState>(
      listener: (context, state) {
        if(state is CreateMedicineLoadingState){
          appAlertDialog(
            barrierDismissible: false,
            context, content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/animations/loading.json'),
              SizedBox(height: AppSizes.bodyPadding,),
              Text("Please wait", style: myText(color: AppColors.primary, fontSize: 14.sp, fontWeight: FontWeight.w500),)
            ],
          ));
        } else if (state is CreateMedicineSuccessState){
          context.read<MedicineBloc>().add(GetTodaysMedicineEvent(token: context.read<AuthBloc>().token??""));
          context.read<MedicineBloc>().add(GetAllMedicineEvent(token: context.read<AuthBloc>().token??""));
          AppRoutes.pop(context);
          AppRoutes.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Medicines added successfully"),
            duration: Duration(seconds: 1),
          ));
        } else if(state is CreateMedicineFailedState){
          AppRoutes.pop(context);
          appAlertDialog(
            barrierDismissible: false,
            actions: [
              CupertinoDialogAction(child: Text("Close"), onPressed: (){
                AppRoutes.pop(context);
              },)
            ],
            context, content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Failed", style: myText(color: AppColors.primary, fontSize: 18.sp, fontWeight: FontWeight.bold),),
              SizedBox(height: AppSizes.bodyPadding * 2,),
              Text(state.errorMessage, style: myText(color: AppColors.textColorb2, fontSize: 14.sp, fontWeight: FontWeight.w500),),
            ],
          ));
        }
      },
      child: Scaffold(
          bottomNavigationBar: ValueListenableBuilder(
            valueListenable: _medicinesWithDosage,
            builder: (_, value, __) {
              return value.isNotEmpty ? GestureDetector(
                onTap: () {
                  context.read<MedicineBloc>().add(CreateMedicineEvent(token: context.read<AuthBloc>().token??"", medicineList: value.map((medicine) => MedicineDataFull(
                    dosage: Dosage(morning: medicine.morningDose, afternoon: medicine.noonDose, evening: medicine.eveningDose),
                    duration: MedicineDuration(start: ValueNotifier(medicine.dateRangeNotifier.value?.start.subtract(Duration(days: 1))), end: ValueNotifier(medicine.dateRangeNotifier.value?.end.add(Duration(days: 1)))),
                    medicineName: medicine.nameController,
                    type: TextEditingController(text: medicine.type.toLowerCase() == "tab" ? "Tablet" : medicine.type.toLowerCase() == "cap" ? "Capsule" : medicine.type.toLowerCase() == "inj" ? "Injection" : medicine.type.toLowerCase() == "drop" ? "Drop" : medicine.type),
                    // userId: id,
                  )).toList()));
                },
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.all(AppSizes.bodyPadding*1.5),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                  ),
                  child: Text("Submit", textAlign: TextAlign.center, style: myText(color: AppColors.white, fontSize: 24.sp, fontWeight: FontWeight.bold),),
                ),
              ) : SizedBox.shrink();
            }
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: _scanDocuments,
                // backgroundColor: Colors.blue,
                child: const Icon(Icons.camera_alt),
              ),
              // SizedBox(height: 16), // Space between buttons
              // FloatingActionButton(
              //   onPressed: _addManualMedicine,
              //   backgroundColor: Colors.green,
              //   child: const Icon(Icons.add),
              // ),
            ],
          ),
          appBar: AppBar(
            title: const Text('Prescription Scanner'),
          ),
          body: ValueListenableBuilder<List<Medicine>>(
            valueListenable: _medicinesWithDosage,
            builder: (context, medicines, _) {
              if (medicines.isEmpty) {
                return Center(
                  child: InkWell(
                    onTap: _addManualMedicine,
                    child: Container(
                      padding: EdgeInsets.all(AppSizes.bodyPadding),
                      width: 250.w,
                      height: 150.h,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, size: 30.sp, color: AppColors.primary),
                            SizedBox(height: AppSizes.bodyPadding,),
                            Text(
                              "Add a medicine",
                              style: myText(fontSize: 16.sp, color: AppColors.primary),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
    
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: medicines.isNotEmpty ? medicines.length + 1 : medicines.length,
                itemBuilder: (context, index) {
                  if(index < medicines.length){
                    final medicine = medicines[index];
                    return _buildMedicineCard(medicine, index, delete: () {
                      deleteMedicine(index);
                    },);
                  }else {
                    return GestureDetector(
                      onTap: _addManualMedicine,
                      child: Container(
                        margin: EdgeInsets.only(top: AppSizes.bodyPadding),
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(AppSizes.borderRadiusBig * 6),
                        ),
                        padding: EdgeInsets.all(AppSizes.bodyPadding),
                        child: Text(
                          "Add another",
                          textAlign: TextAlign.center,
                          style: myText(fontWeight: FontWeight.bold, fontSize: 14.sp, color: AppColors.white),
                        ),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
    );
  }

  void deleteMedicine(final int index) {
    if (index >= 0 && index < _medicinesWithDosage.value.length) {
      // Dispose of the medicine's resources
      _medicinesWithDosage.value[index].dispose();
      // Remove the medicine from the list
      _medicinesWithDosage.value = List.from(_medicinesWithDosage.value)..removeAt(index);
    }
  }

  void _addManualMedicine() {
    // Add an empty Medicine object to the list
    _medicinesWithDosage.value = [
      ..._medicinesWithDosage.value,
      Medicine(
        type: "TAB", // Default type
        name: "", // Empty name
        isMorning: false,
        isNoon: false,
        isEvening: false,
      ),
    ];
  }

  Widget _buildMedicineCard(Medicine medicine, int index, {required VoidCallback delete}) {
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
                    valueListenable: medicine.typeNotifier,
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
                          medicine.typeNotifier.value = selected ? type : "";
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
                controller: medicine.nameController,
                validator: (p0) => p0!.isEmpty ? "Please enter a name" : null,
              ),
              SizedBox(height: AppSizes.bodyPadding),
              _buildDosageSelection(
                Dosage(
                  morning: medicine.morningDose,
                  afternoon: medicine.noonDose,
                  evening: medicine.eveningDose,
                ),
              ),
              SizedBox(height: AppSizes.bodyPadding),
              Text("Duration", style: myText(fontSize: 16.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 8.h),
              DateRangeSelector(
                dateRangeNotifier: medicine.dateRangeNotifier,
                initalDate: DateTime(2025),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: delete,
          child: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusBig * 6),
              border: Border.all(color: AppColors.primary),
            ),
            padding: EdgeInsets.all(AppSizes.bodyPadding),
            child: Text(
              "Delete",
              textAlign: TextAlign.center,
              style: myText(fontWeight: FontWeight.bold, fontSize: 14.sp, color: AppColors.primary),
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
                        }else{
                          takeNotifier.value = true;
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

  /// Method to scan documents using CunningDocumentScanner
  Future<void> _scanDocuments() async {
    try {
      final pictures = await CunningDocumentScanner.getPictures(
        noOfPages: 1,
        isGalleryImportAllowed: true,
      ) ?? [];

      if (pictures.isNotEmpty) {
        _pictures.value = pictures;

        // Process each scanned image for text and extract medicines with dosages
        for (String picture in pictures) {
          String extractedText = await _extractTextFromImage(picture);
          _processExtractedText(extractedText);
        }
      }
    } catch (e) {
      debugPrint("Error scanning documents: $e");
    }
  }

  /// Extract text from an image using Google ML Kit
  Future<String> _extractTextFromImage(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    String extractedText = "";
    try {
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);
      extractedText = recognizedText.text;
    } catch (e) {
      debugPrint("Error recognizing text: $e");
    } finally {
      textRecognizer.close();
    }
    return extractedText;
  }

  /// Process the extracted text to find medicines and dosages
  void _processExtractedText(String text) {
    final medicineRegex = RegExp(
      r'\b(TAB|CAP|INJ|DROP|SYRUP|SPRAY)\.?\s+([A-Z0-9\s\.\+\-]+)\b',
      caseSensitive: false,
    );
    final dosageRegex = RegExp(r'\b[0-1]\s*\+\s*[0-1]\s*\+\s*[0-1]\b');

    final lines = text.split('\n');
    final medicines = <String>[];
    final types = <String>[];
    final dosages = <String>[];

    for (String line in lines) {
      line = line.trim();
      if (medicineRegex.hasMatch(line)) {
        final match = medicineRegex.firstMatch(line);
        if (match != null) types.add(match.group(1)!);
        if (match != null) medicines.add(match.group(2)!);
      }
      if (dosageRegex.hasMatch(line)) {
        final match = dosageRegex.firstMatch(line);
        if (match != null) dosages.add(match.group(0)!);
      }
    }

    final medicineData = <Medicine>[];
    for (int i = 0; i < medicines.length; i++) {
      String dosage = ((i < dosages.length) ? dosages[i] : "").replaceAll(" ", "");
      List dayDose = dosage.split("+");
      bool isMorning = dayDose[0] == "1" ? true : false;
      bool isNoon = dayDose[1] == "1" ? true : false;
      bool isEvening = dayDose[2] == "1" ? true : false;
      medicineData.add(Medicine(
        isMorning: isMorning,
        isNoon: isNoon,
        isEvening: isEvening,
        type: types[i],
        name: medicines[i],
      ));
    }

    // Append new medicines to the existing list
    _medicinesWithDosage.value = [..._medicinesWithDosage.value, ...medicineData];
  }
}

class Medicine {
  final String type;
  final String name;
  final bool isMorning, isNoon, isEvening;

  // Add controllers and notifiers
  final TextEditingController nameController;
  final ValueNotifier<String> typeNotifier;
  final ValueNotifier<DateTimeRange?> dateRangeNotifier;
  final Dose morningDose;
  final Dose noonDose;
  final Dose eveningDose;

  Medicine({
    required this.type,
    required this.name,
    required this.isMorning,
    required this.isNoon,
    required this.isEvening,
  })  : nameController = TextEditingController(text: name),
        typeNotifier = ValueNotifier<String>(type.toLowerCase() == "inj" ? "Injection" : type.toLowerCase() == "cap" ? "Capsule" : type.toLowerCase() == "drop" ? "Drop" : "Tablet"),
        dateRangeNotifier = ValueNotifier<DateTimeRange?>(
          DateTimeRange(
            start: DateTime.now(),
            end: DateTime.now().add(Duration(days: 7)),
          ),
        ),
        morningDose = Dose(
          take: ValueNotifier(isMorning),
          afterMeal: ValueNotifier(true),
        ),
        noonDose = Dose(
          take: ValueNotifier(isNoon),
          afterMeal: ValueNotifier(true),
        ),
        eveningDose = Dose(
          take: ValueNotifier(isEvening),
          afterMeal: ValueNotifier(true),
        );

  // Dispose method to clean up resources
  void dispose() {
    nameController.dispose();
    typeNotifier.dispose();
    dateRangeNotifier.dispose();
    morningDose.take?.dispose();
    morningDose.afterMeal?.dispose();
    noonDose.take?.dispose();
    noonDose.afterMeal?.dispose();
    eveningDose.take?.dispose();
    eveningDose.afterMeal?.dispose();
  }
}