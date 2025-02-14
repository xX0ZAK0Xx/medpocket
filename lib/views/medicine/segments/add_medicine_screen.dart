import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:medpocket/configs/colors.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _scanDocuments,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.camera_alt),
      ),
      appBar: AppBar(
        title: const Text('Prescription Scanner'),
      ),
      body: ValueListenableBuilder<List<Medicine>>(
        valueListenable: _medicinesWithDosage,
        builder: (context, medicines, _) {
          if (medicines.isEmpty) {
            return const Center(
              child: Text(
                "No medicines extracted yet!",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: medicines.length,
            itemBuilder: (context, index) {
              final medicine = medicines[index];
              return _buildMedicineCard(medicine, index, delete: () {
                deleteMedicine(index);
              },);
            },
          );
        },
      ),
    );
  }

  void deleteMedicine(final int index) {
    if (index >= 0 && index < _medicinesWithDosage.value.length) {
      _medicinesWithDosage.value = List.from(_medicinesWithDosage.value)..removeAt(index);
    }
  }
  

  Widget _buildMedicineCard(Medicine medicine, int index, {required VoidCallback delete}) {
    final ValueNotifier<String> typeNotifier = ValueNotifier<String>(
      medicine.type.toLowerCase() == "inj"
          ? "Injection"
          : medicine.type.toLowerCase() == "cap"
              ? "Capsule"
              : medicine.type.toLowerCase() == "drop"
                  ? "Drop"
                  : "Tablet",
    );
    final TextEditingController nameController = TextEditingController(text: medicine.name);
    ValueNotifier<DateTimeRange?> dateRangeNotifier =
        ValueNotifier<DateTimeRange?>(DateTimeRange(start: DateTime.now(), end: DateTime.now().add(Duration(days: 7))));

    final morningDose = Dose(
      take: ValueNotifier(medicine.isMorning),
      afterMeal: ValueNotifier(true),
    );
    final noonDose = Dose(
      take: ValueNotifier(medicine.isNoon),
      afterMeal: ValueNotifier(true),
    );
    final eveningDose = Dose(
      take: ValueNotifier(medicine.isEvening),
      afterMeal: ValueNotifier(true),
    );

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
          onTap: delete, // ✅ Now correctly calling the delete function
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

  /// Method to scan documents using CunningDocumentScanner
  Future<void> _scanDocuments() async {
    try {
      final pictures = await CunningDocumentScanner.getPictures(
        noOfPages: 1,
        isGalleryImportAllowed: true
      ) ?? [];
      if (pictures.isNotEmpty) {
        _pictures.value = pictures;
        _medicinesWithDosage.value = []; // Clear existing data

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

    _medicinesWithDosage.value = [..._medicinesWithDosage.value, ...medicineData];
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
