import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medpocket/configs/app_routes.dart';
import 'package:medpocket/configs/colors.dart';
import 'package:medpocket/models/model.dart';

import '../../../blocs/bloc.dart';
import '../../../widgets/widgets.dart';

class SingleFolderScreen extends StatelessWidget {
  const SingleFolderScreen({super.key, required this.folderData});
  final FolderData folderData;

  @override
  Widget build(BuildContext context) {
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
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(folderData.name??""),
            actions: [
              IconButton(onPressed: (){
                appConfirmationDialog(context: context, title: "Delete this folder forever", description: "Do you want to delete this folder? Once deleted, you can't see any reports of this folder", onTapYes: () { 
                  context.read<ReportsBloc>().add(DeleteFolderEvent(token: context.read<AuthBloc>().token??"", folderId: folderData.id??""));
                });
              }, icon: Icon(Icons.delete, color: AppColors.primary,))
            ],
          ),
        ),
    );
  }
}