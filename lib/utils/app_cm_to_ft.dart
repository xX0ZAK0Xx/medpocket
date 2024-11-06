
import '../models/model.dart';

String cmToFeetInch(double cm) {
  double totalInches = cm / 2.54;

  int feet = (totalInches / 12).floor();

  double inches = totalInches % 12;

  return "$feet ft ${(inches).toStringAsFixed(2)} in";
}

Height cmToFeetInches(double cm) {
  double totalInches = cm / 2.54; // Convert cm to inches
  int feet = (totalInches ~/ 12); // Calculate feet
  int inches = (totalInches % 12).round(); // Calculate remaining inches
  return Height(foot: feet, inch: inches);
}

double feetInchesToCm({required int foot, required int inch}) {
  double totalInches = ((foot * 12) + inch).toDouble(); // Convert feet and inches to total inches
  return double.tryParse((totalInches * 2.54).toStringAsFixed(2))??0; // Convert inches to cm
}