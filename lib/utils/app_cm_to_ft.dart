
String cmToFeetInch(double cm) {
  double totalInches = cm / 2.54;

  int feet = (totalInches / 12).floor();

  double inches = totalInches % 12;

  return "$feet ft ${(inches).toStringAsFixed(2)} in";
}
