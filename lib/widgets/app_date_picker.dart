/*
Company application details controller
@Author Soton Ahmed <soton.m360ict@gmail.com>
Start Date: 28-11-2023
Last Update: 28-11-2023
*/

import 'package:flutter/material.dart';


Future<DateTime?> appDatePicker(BuildContext context, {DateTime? startDate,DateTime? lastDate,}) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: startDate?? DateTime.now(),
    firstDate: startDate?? DateTime.now().subtract(const Duration(days: 360 * 70)),
    lastDate: lastDate ?? DateTime.now().add(const Duration(days: 365 * 20)),
  );

  if (pickedDate != null) {
    return pickedDate;
  } else {
    return null;
  }
}