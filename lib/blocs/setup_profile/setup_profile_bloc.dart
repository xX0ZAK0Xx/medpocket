import 'dart:async';
import 'dart:isolate';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:medpocket/configs/app_urls.dart';
import 'package:medpocket/database/local_db.dart';
import 'package:medpocket/models/common/common_mod.dart';
import 'package:medpocket/repositories/post_response.dart';

import '../../configs/app_constants.dart';

part 'setup_profile_event.dart';
part 'setup_profile_state.dart';

class SetupProfileBloc extends Bloc<SetupProfileEvent, SetupProfileState> {
  int height = 160;
  int weight = 60;
  String bloodGroup = 'A+', gender = 'Male';
  SetupProfileBloc() : super(SetupProfileInitial()) {
    on<ChangeHeightEvent>(changeHeightEvent);
    on<ChangeWeightEvent>(changeWeightEvent);
    on<SelecteBloodGroupEvent>(selecteBloodGroupEvent);
    on<SelecteGenderEvent>(selecteGenderEvent);

    on<CreateSetupProfileEvent>(createSetupProfileEvent);
  }

  FutureOr<void> changeHeightEvent(ChangeHeightEvent event, Emitter<SetupProfileState> emit) {
    height = event.height;
    emit(ChangeHeightState());
  }


  FutureOr<void> changeWeightEvent(ChangeWeightEvent event, Emitter<SetupProfileState> emit) {
    weight = event.weight;
    emit(ChangeWeightState());
  }

  FutureOr<void> selecteBloodGroupEvent(SelecteBloodGroupEvent event, Emitter<SetupProfileState> emit) {
    bloodGroup = event.bloodGroup;
    emit(SelectBloodGroupState());
  }

  FutureOr<void> selecteGenderEvent(SelecteGenderEvent event, Emitter<SetupProfileState> emit) {
    gender = event.gender;
    emit(SelectGenderState());
  }

  FutureOr<void> createSetupProfileEvent(CreateSetupProfileEvent event, Emitter<SetupProfileState> emit) async {
    emit(CreateSetupProfileLoadingState());
    try {
      final Map<String, String> payload = {
        "name" : event.fullName,
        "phone_number" : event.phoneNumber,
        "blood_group": event.bloodGroup,
        "date_of_birth" : event.dateOfBirth,
        "gender" : event.gender,
        "height" : event.height.toString(),
        "weight" : event.weight.toString(),
      };
      final res = await postImageResponse(url: AppUrls.profileSetup(id: await LocalDB.getId()??""), payload: payload, token: "", photoPath: {"file": event.image});
      final ResponseModel responseModel = await Isolate.run(()=> responseModelFromJson(res));
      if(responseModel.success == true){
        emit(CreateSetupProfileSuccessState());
      }else{
        logger.e(responseModel.message);
        emit(CreateSetupProfileFailedState(errorMessage: responseModel.message??"Something went wrong"));
      }
    } catch (e) {
      logger.e(e.toString());
      emit(CreateSetupProfileFailedState(errorMessage: "Something went wrong"));
    }
  }
}
