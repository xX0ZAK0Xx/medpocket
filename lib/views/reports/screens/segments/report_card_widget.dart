import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpocket/configs/app_routes.dart';
import 'package:medpocket/configs/app_sizes.dart';
import 'package:medpocket/configs/colors.dart';
import 'package:medpocket/utils/app_convert_datetime.dart';
import 'package:medpocket/widgets/app_text_style.dart';

import '../../../../models/model.dart';
import '../../../views.dart';
import 'report_carousel.dart';

class ReportCardWidget extends StatefulWidget {
  const ReportCardWidget({
    super.key, required this.reportOfFolderData, required this.reversed,
  });
  final ReportOfFolderData reportOfFolderData;
  final bool reversed;

  @override
  State<ReportCardWidget> createState() => _ReportCardWidgetState();
}

class _ReportCardWidgetState extends State<ReportCardWidget> {
  final ValueNotifier<int> carouselIndex= ValueNotifier<int>(0);

  @override
  void dispose() {
    carouselIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppRoutes.push(context, CreateUpdateReportScreen(reportOfFolderData: widget.reportOfFolderData, folderId: widget.reportOfFolderData.folderId??"",));
      },
      child: Container(
        padding: EdgeInsets.all(AppSizes.bodyPadding),
        margin: EdgeInsets.only(bottom: AppSizes.bodyPadding),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusBig),
        ),
        child: Row(
          children: [
            HotelCarouselImages(carouselIndex: carouselIndex, reportOfFolderData: widget.reportOfFolderData, reverse: widget.reversed,),
            SizedBox(width: AppSizes.bodyPadding,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(widget.reportOfFolderData.title??"", style: myText(fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis,)),
                    ],
                  ),
                  SizedBox(height: AppSizes.bodyPadding / 2,),
                  Row(
                    children: [
                      Expanded(child: Text(widget.reportOfFolderData.hospitalName??"", style: myText(fontWeight: FontWeight.w400, fontSize: 12.sp), maxLines: 1, overflow: TextOverflow.ellipsis,)),
                    ],
                  ),
                  SizedBox(height: AppSizes.bodyPadding / 3,),
                  Text(convertDateTime(widget.reportOfFolderData.createdAt, 'dd MMM, yyyy'), style: myText(fontSize: 10.sp),),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}