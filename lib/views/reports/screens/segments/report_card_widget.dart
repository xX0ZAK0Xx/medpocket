import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpocket/configs/app_routes.dart';
import 'package:medpocket/configs/app_sizes.dart';
import 'package:medpocket/configs/colors.dart';
import 'package:medpocket/utils/app_convert_datetime.dart';
import 'package:medpocket/widgets/widgets.dart';

import '../../../../blocs/bloc.dart';
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
        appModalBottomSheet(context: context, content: ViewReports(reportOfFolderData: widget.reportOfFolderData, folderId: widget.reportOfFolderData.folderId??"",));
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


class ViewReports extends StatelessWidget {
  const ViewReports({
    super.key,
    required this.reportOfFolderData, required this.folderId,
  });

  final ReportOfFolderData reportOfFolderData;
  final String folderId;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReportsBloc, ReportsState>(
      listener: (context, state) {
        if(state is DeleteFolderLoadingState){
          // AppRoutes.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Please wait..."),
            duration: Duration(seconds: 1),
          ));
        }else if(state is DeleteReportSuccessState){
          AppRoutes.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Report deleted successfully"),
            duration: Duration(seconds: 1),
          ));
          context.read<ReportsBloc>().add(GetAllReportEvents(token: context.read<AuthBloc>().token??"", folderId: folderId));
        }else if(state is DeleteReportFailedState){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.errorMessage),
            duration: Duration(seconds: 1),
          ));
        }
      },
      child: ListView(
        shrinkWrap: true,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  reportOfFolderData.title ?? "Untitled Report",
                  style: myText(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(onPressed: (){
                AppRoutes.pop(context);
                AppRoutes.push(
                  context,
                  CreateUpdateReportScreen(
                    reportOfFolderData: reportOfFolderData,
                    folderId: reportOfFolderData.folderId ?? "",
                  ),
                );
              }, icon: Icon(Icons.edit, color: AppColors.primary,)),
              IconButton(onPressed: (){
                appConfirmationDialog(context: context, title: "Delete the report", description: "Do you want to delete the report? Once deleted it can't be undone.", onTapYes: (){
                  context.read<ReportsBloc>().add(DeleteReportEvent(token: context.read<AuthBloc>().token??"", reportId: reportOfFolderData.id??""));
                });
              }, icon: Icon(Icons.delete, color: AppColors.primary,))
            ],
          ),
          SizedBox(height: AppSizes.bodyPadding / 2),
          Text(
            reportOfFolderData.description ?? "No description provided.",
            style: myText(),
          ),
          SizedBox(height: AppSizes.bodyPadding),
          Text(
            "Hospital Name: ${reportOfFolderData.hospitalName ?? "N/A"}",
            style: myText(),
          ),
          SizedBox(height: AppSizes.bodyPadding),
          if (reportOfFolderData.images != null && reportOfFolderData.images!.isNotEmpty)
            SizedBox(
              height: 100.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: reportOfFolderData.images!.length,
                itemBuilder: (context, index) {
                  return AppCachedNetworkImage(url: reportOfFolderData.images![index], height: 100.h, width: 100.h);
                  // return null;
                }, separatorBuilder: (BuildContext context, int index) { 
                  return SizedBox(width: AppSizes.bodyPadding,);
                },
              ),
            ),
          SizedBox(height: AppSizes.bodyPadding),
        ],
      ),
    );
  }
}
