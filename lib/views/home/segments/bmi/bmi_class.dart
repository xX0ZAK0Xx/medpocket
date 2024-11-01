import 'dart:math';

class BmiEntry {
  final double height;
  final double weight;
  final double bmi;
  final DateTime date;

  BmiEntry({required this.height, required this.weight, required this.bmi, required this.date});
}

final List<BmiEntry> bmiEntries = [
  BmiEntry(
    height: 68.9,
    weight: 65,
    bmi: 65 / pow(68.9 * 0.0254, 2),
    date: DateTime(2023, 10, 1),
  ),
  BmiEntry(
    height: 69.1,
    weight: 63,
    bmi: 63 / pow(69.1 * 0.0254, 2),
    date: DateTime(2023, 10, 2),
  ),
  BmiEntry(
    height: 70.0,
    weight: 68,
    bmi: 68 / pow(70.0 * 0.0254, 2),
    date: DateTime(2023, 10, 3),
  ),
  BmiEntry(
    height: 67.5,
    weight: 70,
    bmi: 70 / pow(67.5 * 0.0254, 2),
    date: DateTime(2023, 10, 4),
  ),
  BmiEntry(
    height: 66.0,
    weight: 66,
    bmi: 66 / pow(66.0 * 0.0254, 2),
    date: DateTime(2023, 10, 5),
  ),
  BmiEntry(
    height: 68.2,
    weight: 60,
    bmi: 60 / pow(68.2 * 0.0254, 2),
    date: DateTime(2023, 10, 6),
  ),
  BmiEntry(
    height: 69.5,
    weight: 72,
    bmi: 72 / pow(69.5 * 0.0254, 2),
    date: DateTime(2023, 10, 7),
  ),
  BmiEntry(
    height: 71.0,
    weight: 75,
    bmi: 75 / pow(71.0 * 0.0254, 2),
    date: DateTime(2023, 10, 8),
  ),
  BmiEntry(
    height: 67.9,
    weight: 64,
    bmi: 64 / pow(67.9 * 0.0254, 2),
    date: DateTime(2023, 10, 9),
  ),
  BmiEntry(
    height: 68.7,
    weight: 67,
    bmi: 67 / pow(68.7 * 0.0254, 2),
    date: DateTime(2023, 10, 10),
  ),
  BmiEntry(
    height: 69.8,
    weight: 69,
    bmi: 69 / pow(69.8 * 0.0254, 2),
    date: DateTime(2023, 10, 11),
  ),
  BmiEntry(
    height: 70.5,
    weight: 73,
    bmi: 73 / pow(70.5 * 0.0254, 2),
    date: DateTime(2023, 10, 12),
  ),
  BmiEntry(
    height: 66.8,
    weight: 65,
    bmi: 65 / pow(66.8 * 0.0254, 2),
    date: DateTime(2023, 10, 13),
  ),
  BmiEntry(
    height: 71.2,
    weight: 74,
    bmi: 74 / pow(71.2 * 0.0254, 2),
    date: DateTime(2023, 10, 14),
  ),
  BmiEntry(
    height: 68.4,
    weight: 61,
    bmi: 61 / pow(68.4 * 0.0254, 2),
    date: DateTime(2023, 10, 15),
  ),
  // BmiEntry(
  //   height: 67.2,
  //   weight: 62,
  //   bmi: 62 / pow(67.2 * 0.0254, 2),
  //   date: DateTime(2023, 10, 16),
  // ),
  // BmiEntry(
  //   height: 70.1,
  //   weight: 71,
  //   bmi: 71 / pow(70.1 * 0.0254, 2),
  //   date: DateTime(2023, 10, 17),
  // ),
  // BmiEntry(
  //   height: 66.9,
  //   weight: 60,
  //   bmi: 60 / pow(66.9 * 0.0254, 2),
  //   date: DateTime(2023, 10, 18),
  // ),
  // BmiEntry(
  //   height: 69.0,
  //   weight: 70,
  //   bmi: 70 / pow(69.0 * 0.0254, 2),
  //   date: DateTime(2023, 10, 19),
  // ),
  // BmiEntry(
  //   height: 68.6,
  //   weight: 63,
  //   bmi: 63 / pow(68.6 * 0.0254, 2),
  //   date: DateTime(2023, 10, 20),
  // ),
];
