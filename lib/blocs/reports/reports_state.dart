part of 'reports_bloc.dart';

sealed class ReportsState {}

final class ReportsInitial extends ReportsState {}

//!Folders
//?Create Folder State
final class CreateFolderLoadingState extends ReportsState {}
final class CreateFolderSuccessState extends ReportsState {}
final class CreateFolderFailedState extends ReportsState {
  final String errorMessage;

  CreateFolderFailedState({required this.errorMessage});
}

//?Update Folder State
final class UpdateFolderLoadingState extends ReportsState {}
final class UpdateFolderSuccessState extends ReportsState {}
final class UpdateFolderFailedState extends ReportsState {
  final String errorMessage;

  UpdateFolderFailedState({required this.errorMessage});
}

//?Delete Folder State
final class DeleteFolderLoadingState extends ReportsState {}
final class DeleteFolderSuccessState extends ReportsState {}
final class DeleteFolderFailedState extends ReportsState {
  final String errorMessage;

  DeleteFolderFailedState({required this.errorMessage});
}

//?Get all folders
final class GetAllFolderLoadingState extends ReportsState {}
final class GetAllFolderSuccessState extends ReportsState {
  final List<FolderData> folderList;

  GetAllFolderSuccessState({required this.folderList});
}
final class GetAllFolderFailedState extends ReportsState {
  final String errorMessage;

  GetAllFolderFailedState({required this.errorMessage});
}

//!Reports
//?Create Report State
final class CreateReportLoadingState extends ReportsState {}
final class CreateReportSuccessState extends ReportsState {}
final class CreateReportFailedState extends ReportsState {
  final String errorMessage;

  CreateReportFailedState({required this.errorMessage});
}
//?Update Report State 
final class UpdateReportLoadingState extends ReportsState {}
final class UpdateReportSuccessState extends ReportsState {}
final class UpdateReportFailedState extends ReportsState {
  final String errorMessage;

  UpdateReportFailedState({required this.errorMessage});
}
//?Delete Report State
final class DeleteReportLoadingState extends ReportsState{}
final class DeleteReportSuccessState extends ReportsState{}
final class DeleteReportFailedState extends ReportsState{
  final String errorMessage;

  DeleteReportFailedState({required this.errorMessage});
}
//?Get all Report State
final class GetAllReportLoadingState extends ReportsState {}
final class GetAllReportSuccessState extends ReportsState {
  final List<ReportOfFolderData> reportList;

  GetAllReportSuccessState({required this.reportList});
}
final class GetAllReportFailedState extends ReportsState {
  final String errorMessage;

  GetAllReportFailedState({required this.errorMessage});
}