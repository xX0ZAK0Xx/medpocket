import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:medpocket/blocs/bloc.dart';
import 'package:medpocket/configs/app_sizes.dart';
import 'package:medpocket/widgets/app_button.dart';
import 'package:medpocket/widgets/app_decorated_text_field.dart';
import 'package:medpocket/widgets/app_text_style.dart';

import '../../../configs/colors.dart';
import '../../../models/model.dart';
import '../../../utils/utils.dart';

class CreateUpdateReportScreen extends StatefulWidget {
  const CreateUpdateReportScreen({super.key, this.reportOfFolderData});
  final ReportOfFolderData? reportOfFolderData;

  @override
  State<CreateUpdateReportScreen> createState() => _CreateUpdateReportScreenState();
}

class _CreateUpdateReportScreenState extends State<CreateUpdateReportScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController hospitalController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  ImageBloc imageBloc = ImageBloc();
  bool previousData = false;

  @override
  void initState() {
    if(widget.reportOfFolderData != null){
      titleController.text = widget.reportOfFolderData?.title ?? "";
      descriptionController.text = widget.reportOfFolderData?.description ?? "";
      hospitalController.text = widget.reportOfFolderData?.hospitalName ?? "";
      if(widget.reportOfFolderData?.images?.isNotEmpty == true){
        previousData = true;
        imageBloc.onlineImage= true;
        imageBloc.resizedMultiImagesPath = widget.reportOfFolderData?.images?.map((photo){
          return photo;
        }).toList() ?? [];
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    hospitalController.dispose();
    imageBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reportOfFolderData != null ? "Update Report" : "Create Report"),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSizes.bodyPadding),
        physics: ClampingScrollPhysics(),
        children: [
          Text("Report Images", style: myText(fontWeight: FontWeight.bold, fontSize: 16.sp),),
          SizedBox(height: AppSizes.bodyPadding,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<ImageBloc, ImageState>(
                bloc: imageBloc,
                builder: (context, state) {
                  //No image is selected
                    return Wrap(
                      spacing: AppSizes.bodyPadding,
                      runSpacing: AppSizes.bodyPadding,
                      children: [
                        if(imageBloc.resizedMultiImagesPath.isEmpty)
                          Container(
                            padding: EdgeInsets.all(AppSizes.bodyPadding / 2),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(204, 225, 228, 235),
                              borderRadius: BorderRadius.circular(AppSizes.borderRadius)
                            ),
                            child: HugeIcon(
                              icon: HugeIcons.strokeRoundedImage01,
                              color: AppColors.black.withOpacity(0.1),
                              size: 40.0.sp,
                            ),
                          )
                        else
                          ...imageBloc.resizedMultiImagesPath.asMap().entries.map((entry) {
                            int index = entry.key;
                            String image = entry.value;
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                                  child: SizedBox(
                                    height: 50.sp,
                                    width: 50.sp,
                                    child: imageBloc.onlineImage ? Image.network(image, fit: BoxFit.cover) : Image.file(File(image), fit: BoxFit.cover),
                                  ),
                                ),
                                Positioned(
                                  right: -5,
                                  bottom: -5,
                                  child: InkWell(
                                    onTap: () => imageBloc.add(DeleteImageEvent(index)),
                                    child: CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Colors.red,
                                      child: Icon(Icons.close, color: Colors.white, size: 12.sp),
                                    ),
                                  ),
                                )
                              ],
                            );
                          }
                        ),
                        // SizedBox(width: AppSizes.bodyPadding,),
                        InkWell(
                          onTap: () => showImageSourceSheet(context, imageBloc, "report", multiImage: true),
                          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                          child: Container(
                            height: 50.sp,
                            width: 50.sp,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                              color: Color.fromARGB(204, 225, 228, 235),
                            ),
                            child: Icon(Icons.add, color: AppColors.grey, size: 24.sp),
                          ),
                        )
                      ],
                    );
                },
              ),
            ],
          ),

          SizedBox(height: AppSizes.bodyPadding * 2,),
          AppDecoratedTextField(
            textInputAction: TextInputAction.next, 
            labelText: "Title", 
            hintText: "Give a title of the report", 
            keyboardType: TextInputType.text, 
            controller: titleController,
            validator: (p0) => p0!.isEmpty ? "Please enter a title" : null,
          ),
          SizedBox(height: AppSizes.bodyPadding,),
          AppDecoratedTextField(
            textInputAction: TextInputAction.next, 
            labelText: "Hospital", 
            hintText: "e.g. Popular Diagnostic Center", 
            keyboardType: TextInputType.text, 
            controller: titleController,
            validator: (p0) => p0!.isEmpty ? "Please enter a hospital name" : null,
          ),
          SizedBox(height: AppSizes.bodyPadding,),
          AppDecoratedTextField(
            textInputAction: TextInputAction.newline, 
            labelText: "Description", 
            hintText: "Write a few lines about it.", 
            keyboardType: TextInputType.multiline, 
            controller: descriptionController,
            maxLines: 5,
          ),
          SizedBox(height: AppSizes.bodyPadding * 4,),
          BlocConsumer<ReportsBloc, ReportsState>(
            listenWhen: (previous, current) => current is CreateReportFailedState || current is CreateReportLoadingState || current is CreateReportSuccessState,
            listener: (context, state) {
              if(state is CreateReportFailedState){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.errorMessage),
                  duration: Duration(seconds: 1),
                ));
              }else if(state is CreateReportLoadingState){
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Please wait"),
                  duration: Duration(seconds: 1),
                ));
              }else if(state is CreateReportSuccessState){
                previousData = true;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Report ${widget.reportOfFolderData != null ? "updated" : "created"} successfully"),
                  duration: Duration(seconds: 1),
                ));
              }
            },
            buildWhen: (previous, current) => current is CreateReportFailedState || current is CreateReportLoadingState || current is CreateReportSuccessState,
            builder: (context, state) {
              return AppButton(
                press: () {
                  if(imageBloc.resizedMultiImagesPath.isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Please select at least one image"),
                      duration: Duration(seconds: 1),
                    ));
                  }else{
                    context.read<ReportsBloc>().add(
                      CreateReportEvent(
                        token: context.read<AuthBloc>().token??"", 
                        folderId: widget.reportOfFolderData?.folderId??"", 
                        title: titleController.text.trim(), 
                        description: descriptionController.text.trim(), 
                        hospitalName: hospitalController.text.trim(), 
                        images: imageBloc.resizedMultiImagesPath)
                    );
                  }
                },
                text: "Submit",
              );
            },
          )
        ],
      ),
    );
  }
}


