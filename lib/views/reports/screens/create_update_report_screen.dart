import 'package:flutter/material.dart';

import '../../../models/model.dart';

class CreateUpdateReportScreen extends StatelessWidget {
  const CreateUpdateReportScreen({super.key, this.reportOfFolderData});
  final ReportOfFolderData? reportOfFolderData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(reportOfFolderData != null ? "Update Report" : "Create Report"),
      ),
    );
  }
}