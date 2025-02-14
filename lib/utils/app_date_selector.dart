import 'package:flutter/material.dart';

Future<void> selectDateRange({required BuildContext context, required ValueNotifier<DateTimeRange?> notifier, DateTime? firstDate, DateTime? lastDate}) async {
  DateTimeRange? selectedRange = await showDateRangePicker(
    context: context,
    initialDateRange: notifier.value ?? DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(const Duration(days: 1)),
    ),
    firstDate:firstDate ?? DateTime(1900),
    lastDate:lastDate ?? DateTime.now(),
  );

  notifier.value = selectedRange;
}

Future<void> selectDate({required BuildContext context, required ValueNotifier notifier, DateTime? firstDate, DateTime? lastDate}) async {
  DateTime? selectedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate:firstDate ?? DateTime(1900),
    lastDate:lastDate ?? DateTime.now(),
  );
  
  notifier.value = selectedDate;
}