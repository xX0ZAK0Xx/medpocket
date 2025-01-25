import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medpocket/configs/app_routes.dart';
import 'package:medpocket/configs/colors.dart';
import 'package:medpocket/models/model.dart';

import '../../../blocs/bloc.dart';
import '../../../configs/app_sizes.dart';
import '../../../widgets/widgets.dart';
import '../../views.dart';
import 'segments/report_card_widget.dart';
import 'shimmer_single_folder.dart';

class SingleFolderScreen extends StatelessWidget {
  const SingleFolderScreen({super.key, required this.folderData});
  final FolderData folderData;

  @override
  Widget build(BuildContext context) {
    context.read<ReportsBloc>().add(GetAllReportEvents(token: context.read<AuthBloc>().token??"", folderId: folderData.id??""));
    return BlocListener<ReportsBloc, ReportsState>(
      listener: (context, state) {
        if(state is DeleteFolderLoadingState){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Please wait while we delete this folder"),
            duration: Duration(seconds: 1),
          ));
        }else if(state is DeleteFolderSuccessState){
          context.read<ReportsBloc>().add(GetAllFoldersEvent(token: context.read<AuthBloc>().token??""));
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Folder deleted successfully"),
            duration: Duration(seconds: 1),
          ));
          AppRoutes.pop(context);
        }else if(state is DeleteFolderFailedState){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.errorMessage),
            duration: Duration(seconds: 1),
          ));
        }else if(state is UpdateFolderLoadingState){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Please wait while the update is in progress"),
            duration: Duration(seconds: 1),
          ));
        }else if(state is UpdateFolderSuccessState){
          context.read<ReportsBloc>().add(GetAllFoldersEvent(token: context.read<AuthBloc>().token??""));
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Folder successfully updated"),
            duration: Duration(seconds: 1),
          ));
          AppRoutes.pop(context);
        }else if(state is UpdateFolderFailedState){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.errorMessage),
            duration: Duration(seconds: 1),
          ));
        }
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            AppRoutes.push(context, CreateUpdateReportScreen());
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text(folderData.name??""),
          actions: [
            IconButton(onPressed: (){
              TextEditingController nameController = TextEditingController(text: folderData.name??"");
              appAlertDialog(
                context, 
                actions: [
                  CupertinoDialogAction(child: Text("Cancel", style: myText(color: AppColors.textColorb3, fontWeight: FontWeight.bold).copyWith(fontFamily: 'Poppins'),), onPressed: () {
                    AppRoutes.pop(context);
                  },),
                  CupertinoDialogAction(child: Text("Add", style: myText(color: AppColors.primary, fontWeight: FontWeight.bold).copyWith(fontFamily: 'Poppins'),), onPressed: () {
                    AppRoutes.pop(context);
                    context.read<ReportsBloc>().add(UpdateFolderEvent(folderId: folderData.id??"", token: context.read<AuthBloc>().token??"", name: nameController.text.trim()));
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
            }, icon: Icon(Icons.edit, color: AppColors.primary,)),
            IconButton(onPressed: (){
              appConfirmationDialog(context: context, title: "Delete this folder forever", description: "Do you want to delete this folder? Once deleted, you can't see any reports of this folder", onTapYes: () { 
                context.read<ReportsBloc>().add(DeleteFolderEvent(token: context.read<AuthBloc>().token??"", folderId: folderData.id??""));
              });
            }, icon: Icon(Icons.delete, color: AppColors.primary,))
          ],
        ),
        body: BlocBuilder<ReportsBloc, ReportsState>(
          buildWhen: (previous, current) => current is GetAllReportLoadingState || current is GetAllReportSuccessState || current is GetAllReportFailedState,
          builder: (context, state) {
            if(state is GetAllReportLoadingState){
              // return Center(child: CircularProgressIndicator.adaptive(),);
              return ListView.builder(
                padding: EdgeInsets.all(AppSizes.bodyPadding),
                itemCount: 8,
                itemBuilder: (context, index) {
                  return ShimmerSingleFolder();
                },
              );
            }else if(state is GetAllReportFailedState){
              return Center(child: Padding(
                padding: EdgeInsets.all(AppSizes.bodyPadding),
                child: Text(state.errorMessage, style: myText(),),
              ));
            }else if(state is GetAllReportSuccessState){
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.bodyPadding),
                itemCount: state.reportList.length + 1,
                itemBuilder: (context, index) => index < state.reportList.length ? ReportCardWidget(reportOfFolderData: state.reportList[index], reversed: index%2==0,) : SizedBox(height: AppSizes.bodyPadding * 6,),
              );
            }return Center(child: Padding(
              padding: EdgeInsets.all(AppSizes.bodyPadding),
              child: Text("Something went wrong", style: myText(),),
            ));
          },
        ),
      ),
    );
  }
}