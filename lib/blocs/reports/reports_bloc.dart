
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medpocket/models/model.dart';

import '../../configs/app_constants.dart';
import '../../configs/app_urls.dart';
import '../../database/local_db.dart';
import '../../repositories/repositories.dart';

part 'reports_event.dart';
part 'reports_state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  List<FolderData> folderList = [];
  
  ReportsBloc() : super(ReportsInitial()) {
    //?Folder
    on<GetAllFoldersEvent>(getAllFoldersEvent);
    on<CreateFolderEvent>(createFolderEvent);
    on<UpdateFolderEvent>(updateFolderEvent);
    on<DeleteFolderEvent>(deleteFolderEvent);

    //?Reports
    on<GetAllReportEvents>(getAllReportEvents);
    on<CreateReportEvent>(createReportEvent);
    on<UpdateReportEvent>(updateReportEvent);
    on<DeleteReportEvent>(deleteReportEvent);
  }

  FutureOr<void> getAllFoldersEvent(GetAllFoldersEvent event, Emitter<ReportsState> emit) async {
    if(folderList.isEmpty) emit(GetAllFolderLoadingState());
    try {
      final res = await getResponse(url: AppUrls.reportFolder(getAll: true, userId: await LocalDB.getId()??""), from: "Get All Folders Event", token: event.token);
      final AllFoldersListModel allFoldersListModel = allFoldersListModelFromJson(res);
      if(allFoldersListModel.success == true && allFoldersListModel.data != null) {
        folderList = allFoldersListModel.data ?? [];
        emit(GetAllFolderSuccessState());
      }else{
        emit(GetAllFolderFailedState(errorMessage: allFoldersListModel.message??"Something went wrong"));
      }
    } catch (e, k) {
      logger.e("$e: $k");
      emit(GetAllFolderFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> createFolderEvent(CreateFolderEvent event, Emitter<ReportsState> emit) async {
    emit(CreateFolderLoadingState());
    try {
      final Map<String, String> payload = {
          "user_id": await LocalDB.getId()??"",
          "name": event.name
      };
      final res = await postResponse(url: AppUrls.reportFolder(create: true), token: event.token, payload: payload);
      final ResponseModel responseModel = responseModelFromJson(res);
      if(responseModel.success == true) {
        emit(CreateFolderSuccessState());
      }else{
        emit(CreateFolderFailedState(errorMessage: responseModel.message??"Something went wrong"));
      }
    } catch (e, k) {
      logger.e("$e: $k");
      emit(CreateFolderFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> updateFolderEvent(UpdateFolderEvent event, Emitter<ReportsState> emit) async {
    emit(UpdateFolderLoadingState());
    try {
      final Map<String, String> payload = {
          "name": event.name
      };
      final res = await putResponse(url: AppUrls.reportFolder(update: true, id: event.folderId), token: event.token, payload: payload);
      final ResponseModel responseModel = responseModelFromJson(res);
      if(responseModel.success == true) {
        emit(UpdateFolderSuccessState());
      }else{
        emit(UpdateFolderFailedState(errorMessage: responseModel.message??"Something went wrong"));
      }
    } catch (e, k) {
      logger.e("$e: $k");
      emit(UpdateFolderFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> deleteFolderEvent(DeleteFolderEvent event, Emitter<ReportsState> emit) async {
    emit(DeleteFolderLoadingState());
    try {
      final res = await deleteResponse(url: AppUrls.reportFolder(delete: true, id: event.folderId), token: event.token, from: "delete folder");
      final ResponseModel responseModel = responseModelFromJson(res);
      if(responseModel.success == true) {
        emit(DeleteFolderSuccessState());
      }else{
        emit(DeleteFolderFailedState(errorMessage: responseModel.message??"Something went wrong"));
      }
    } catch (e, k) {
      logger.e("$e: $k");
      emit(DeleteFolderFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> getAllReportEvents(GetAllReportEvents event, Emitter<ReportsState> emit) async {
    emit(GetAllReportLoadingState());
    try {
      final res = await getResponse(url: AppUrls.reports(getAll: true, userId: await LocalDB.getId()??"", folderId: event.folderId), from: "Get All Reports Event", token: event.token);
      final AllReportsOfFolderModel allReportsOfFolderModel = allReportsOfFolderModelFromJson(res);
      if(allReportsOfFolderModel.success == true && allReportsOfFolderModel.data != null) {
        emit(GetAllReportSuccessState(reportList: allReportsOfFolderModel.data!));
      }else{
        emit(GetAllReportFailedState(errorMessage: allReportsOfFolderModel.message??"Something went wrong"));
      }
    } catch (e, k) {
      logger.e("$e: $k");
      emit(GetAllReportFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> createReportEvent(CreateReportEvent event, Emitter<ReportsState> emit) async {
    emit(CreateReportLoadingState());
    try {
      final Map<String, String> payload = {
          "userId": await LocalDB.getId()??"",
          "folderId": event.folderId,
          "title": event.title,
          "description": event.description,
          "hospitalName" : event.hospitalName,
      };
      Map<String, String> imagePayload = {
        for (int i = 0; i < event.images.length; i++) 'photo_$i': event.images[i],
      };
      final res = await postImageResponse(url: AppUrls.reports(upload: true), token: event.token, payload: payload, imageName: "images", photoPath: imagePayload);
      final ResponseModel responseModel = responseModelFromJson(res);
      if(responseModel.success == true) {
        emit(CreateReportSuccessState());
      }else{
        emit(CreateReportFailedState(errorMessage: responseModel.message??"Something went wrong"));
      }
    } catch (e, k) {
      logger.e("$e: $k");
      emit(CreateReportFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> updateReportEvent(UpdateReportEvent event, Emitter<ReportsState> emit) async {
    emit(UpdateReportLoadingState());
    try {
      final Map<String, String> payload = {
          "title": event.title,
          "description": event.description,
          "hospitalName" : event.hospitalName,
      };
      Map<String, String> imagePayload = {
        for (int i = 0; i < event.images.length; i++) 'photo_$i': event.images[i],
      };
      final res = await putImageResponse(url: AppUrls.reports(update: true, id: event.reportId), token: event.token, payload: payload, photoPath: imagePayload, from: "Update Report", imageName: "images");
      final ResponseModel responseModel = responseModelFromJson(res);
      if(responseModel.success == true) {
        emit(UpdateReportSuccessState());
      }else{
        emit(UpdateReportFailedState(errorMessage: responseModel.message??"Something went wrong"));
      }
    } catch (e, k) {
      logger.e("$e: $k");
      emit(UpdateReportFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> deleteReportEvent(DeleteReportEvent event, Emitter<ReportsState> emit) async {
    emit(DeleteReportLoadingState());
    try {
      final res = await deleteResponse(url: AppUrls.reports(delete: true, id: event.reportId), token: event.token, from: "delete report");
      final ResponseModel responseModel = responseModelFromJson(res);
      if(responseModel.success == true) {
        emit(DeleteReportSuccessState());
      }else{
        emit(DeleteReportFailedState(errorMessage: responseModel.message??"Something went wrong"));
      }
    } catch (e, k) {
      logger.e("$e: $k");
      emit(DeleteReportFailedState(errorMessage: e.toString()));
    }
  }
}
