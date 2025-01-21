import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpocket/configs/app_routes.dart';
import 'package:medpocket/configs/app_sizes.dart';
import 'package:medpocket/configs/colors.dart';
import 'package:medpocket/views/reports/segments/report_folder_widget.dart';
import 'package:medpocket/widgets/app_alert_dialog.dart';
import 'package:medpocket/widgets/app_decorated_text_field.dart';
import 'package:medpocket/widgets/app_text_style.dart';

import '../../blocs/bloc.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    context.read<ReportsBloc>().add(GetAllFoldersEvent(token: context.read<AuthBloc>().token??""));
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reports'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          TextEditingController nameController = TextEditingController();
          appAlertDialog(
            context, 
            actions: [
              CupertinoDialogAction(child: Text("Cancel", style: myText(color: AppColors.textColorb3, fontWeight: FontWeight.bold).copyWith(fontFamily: 'Poppins'),), onPressed: () {
                AppRoutes.pop(context);
              },),
              CupertinoDialogAction(child: Text("Add", style: myText(color: AppColors.primary, fontWeight: FontWeight.bold).copyWith(fontFamily: 'Poppins'),), onPressed: () {
                AppRoutes.pop(context);
                context.read<ReportsBloc>().add(CreateFolderEvent(token: context.read<AuthBloc>().token??"", name: nameController.text.trim()));
              },)
            ],
            content: Material(
              child: Row(
                children: [
                  Expanded(
                    child: AppDecoratedTextField(
                      textInputAction: TextInputAction.done, 
                      labelText: 'Name', 
                      hintText: 'Enter the folder name', 
                      keyboardType: TextInputType.text, 
                      controller: nameController,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      body: BlocConsumer<ReportsBloc, ReportsState>(
        listener: (context, state) {
          if(state is CreateFolderLoadingState){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Please Wait"),
              duration: Duration(seconds: 1),
            ));
          }else if(state is CreateFolderSuccessState){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Folder created successfully"),
              duration: Duration(seconds: 1),
            ));
            context.read<ReportsBloc>().add(GetAllFoldersEvent(token: context.read<AuthBloc>().token??""));
          }else if(state is CreateFolderFailedState){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Failed to create a new folder"),
              duration: Duration(seconds: 1),
            ));
          }
        },
        buildWhen: (previous, current) => current is GetAllFolderLoadingState || current is GetAllFolderSuccessState || current is GetAllFolderFailedState,
        builder: (context, state) {
          if(state is GetAllFolderLoadingState){
            return Center(child: CircularProgressIndicator.adaptive(),);
          }else if(state is GetAllFolderSuccessState){
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: AppSizes.bodyPadding / 2, 
                crossAxisSpacing: AppSizes.bodyPadding / 2,
                mainAxisExtent: 130.h
              ),
              padding: EdgeInsets.all(AppSizes.bodyPadding),
              itemCount: state.folderList.length,
              itemBuilder: (context, index) {
                return ReportFolderWidget(folderData: state.folderList[index]);
              },
            );
          }else if(state is GetAllFolderFailedState){
            return Center(child: Padding(
              padding: EdgeInsets.all(AppSizes.bodyPadding),
              child: Text(state.errorMessage, style: myText(),),
            ));
          }
          return Center(child: Padding(
            padding: EdgeInsets.all(AppSizes.bodyPadding),
            child: Text("Something went wrong", style: myText(),),
          ));
        },
      )
    );
  }
}
