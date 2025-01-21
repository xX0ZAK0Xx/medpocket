import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpocket/configs/app_sizes.dart';
import 'package:medpocket/models/model.dart';
import 'package:medpocket/widgets/app_text_style.dart';

class ReportFolderWidget extends StatelessWidget {
  const ReportFolderWidget({super.key, required this.folderData});
  final FolderData folderData;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        children: [
          Image.asset("assets/images/folder.png", height: 80.h,),
          SizedBox(height: AppSizes.bodyPadding / 2,),
          Text(folderData.name??"", textAlign: TextAlign.center, style: myText(), maxLines: 2, overflow: TextOverflow.ellipsis)
        ],
      ),
    );
  }
}