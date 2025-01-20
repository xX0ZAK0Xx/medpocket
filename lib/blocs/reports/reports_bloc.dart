
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
  ReportsBloc() : super(ReportsInitial()) {
    //?Folder
    on<GetAllFoldersEvent>(getAllFoldersEvent);
    on<CreateFolderEvent>(createFolderEvent);
    on<UpdateFolderEvent>(updateFolderEvent);
    on<DeleteFolderEvent>(deleteFolderEvent);
  }

  FutureOr<void> getAllFoldersEvent(GetAllFoldersEvent event, Emitter<ReportsState> emit) async {
    emit(GetAllFolderLoadingState());
    try {
      final res = await getResponse(url: AppUrls.reportFolder(getAll: true, userId: await LocalDB.getId()??""), from: "Get All Folders Event", token: event.token);
      final AllFoldersListModel allFoldersListModel = allFoldersListModelFromJson(res);
      if(allFoldersListModel.success == true && allFoldersListModel.data != null) {
        emit(GetAllFolderSuccessState(folderList: allFoldersListModel.data!));
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
    emit(UpdateFolderLoadingState());
    try {
      final res = await deleteResponse(url: AppUrls.reportFolder(delete: true, id: event.folderId), token: event.token, from: "delete folder");
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
}
