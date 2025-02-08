import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

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
              return _buildMedicineCard(medicine);
            },
          );
        },
      ),
    );
  }

  /// Creates a beautiful and unique card for each medicine
  Widget _buildMedicineCard(Medicine medicine) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              medicine.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Type: ${medicine.type}",
              style: const TextStyle(
                color: Colors.blueGrey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              // alignment: WrapAlignment.spaceBetween,
              spacing: 10,
              runAlignment: WrapAlignment.spaceBetween,
              children: [
                _buildDosageIcon(medicine.isMorning, Icons.wb_sunny, "Morning"),
                // const SizedBox(width: 12),
                _buildDosageIcon(medicine.isNoon, Icons.access_time, "Noon"),
                // const SizedBox(width: 12),
                _buildDosageIcon(medicine.isEvening, Icons.nights_stay, "Evening"),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  /// Helper function to build the dosage icons for each time of day
  Widget _buildDosageIcon(bool isTime, IconData icon, String label) {
    return isTime
        ? Row(
          mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: Colors.blue,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.blueGrey,
                ),
              ),
            ],
          )
        : const SizedBox.shrink();
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
