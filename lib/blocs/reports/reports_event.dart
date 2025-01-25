part of 'reports_bloc.dart';

sealed class ReportsEvent {}

//!Folders
class CreateFolderEvent extends ReportsEvent {
  final String token, name;

  CreateFolderEvent({required this.token, required this.name});
}
class UpdateFolderEvent extends ReportsEvent {
  final String token, name, folderId;

  UpdateFolderEvent({required this.token, required this.name, required this.folderId});
}
class DeleteFolderEvent extends ReportsEvent{
  final String token;
  final String folderId;

  DeleteFolderEvent({required this.token, required this.folderId});
}
class GetAllFoldersEvent extends ReportsEvent{
  final String token;

  GetAllFoldersEvent({required this.token});
}

//!Reports
class CreateReportEvent extends ReportsEvent{
  final String token, folderId, title, description, hospitalName;
  final List<ImageData> images;

  CreateReportEvent({required this.token, required this.folderId, required this.title, required this.description, required this.hospitalName, required this.images});
}
class DeleteReportEvent extends ReportsEvent {
  final String token, reportId;

  DeleteReportEvent({required this.token, required this.reportId});
}
class UpdateReportEvent extends ReportsEvent {
  final String token, reportId, title, description, hospitalName;
  final List<String> images;

  UpdateReportEvent({required this.token, required this.reportId, required this.title, required this.description, required this.hospitalName, required this.images});
}
class GetAllReportEvents extends ReportsEvent {
  final String token, folderId;

  GetAllReportEvents({required this.token, required this.folderId});
}