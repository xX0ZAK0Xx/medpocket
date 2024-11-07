import 'dart:async';
import 'dart:developer';
import 'dart:isolate';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:medpocket/configs/app_urls.dart';
import 'package:medpocket/database/local_db.dart';
import 'package:medpocket/models/model.dart';
import 'package:medpocket/repositories/get_response.dart';
import 'package:medpocket/repositories/post_response.dart';

import '../../configs/app_constants.dart';

part 'setup_profile_event.dart';
part 'setup_profile_state.dart';

class SetupProfileBloc extends Bloc<SetupProfileEvent, SetupProfileState> {
  int feet = 5;
  int inch = 5;
  int weight = 60;
  String bloodGroup = 'A+', gender = 'Male';
  SetupProfileBloc() : super(SetupProfileInitial()) {
    on<ChangeFeetEvent>(changeHeightEvent);
    on<ChangeInchEvent>(changeInchEvent);
    on<ChangeWeightEvent>(changeWeightEvent);
    on<SelecteBloodGroupEvent>(selecteBloodGroupEvent);
    on<SelecteGenderEvent>(selecteGenderEvent);

    on<CreateSetupProfileEvent>(createSetupProfileEvent);
    on<GetProfileEvent>(getProfileEvent);
  }

  FutureOr<void> changeHeightEvent(ChangeFeetEvent event, Emitter<SetupProfileState> emit) {
    feet = event.feet;
    emit(ChangeFeetState());
  }
  
  FutureOr<void> changeInchEvent(ChangeInchEvent event, Emitter<SetupProfileState> emit) {
    inch = event.inch;
    emit(ChangeInchState());
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
      logger.d("payload: $payload");
      final res = await postImageResponse(url: AppUrls.profileSetup(id: await LocalDB.getId()??""), payload: payload, token: "", photoPath: {"file": event.image});
      final ResponseModel responseModel = await Isolate.run(()=> responseModelFromJson(res));
      if(responseModel.success == true){
        emit(CreateSetupProfileSuccessState());
      }else{
        log(responseModel.message.toString());
        emit(CreateSetupProfileFailedState(errorMessage: responseModel.message??"Something went wrong"));
      }
    } catch (e) {
      logger.e(e.toString());
      emit(CreateSetupProfileFailedState(errorMessage: "Something went wrong"));
    }
  }

  FutureOr<void> getProfileEvent(GetProfileEvent event, Emitter<SetupProfileState> emit) async {
    emit(GetProfileLoadingState());
    try {
      final res = await getResponse(url: AppUrls.profile(id: await LocalDB.getId()??""), from: 'Get Profile');
      final ProfileModel responseModel = await Isolate.run(()=> profileModelFromJson(res));
      if(responseModel.success == true){
        emit(GetProfileSuccessState(data: responseModel.data??ProfileData()));
      }else{
        logger.e(responseModel.message);
        emit(GetProfileFailedState(errorMessage: responseModel.message??"Something went wrong"));
      }
    } catch (e) {
      logger.e(e.toString());
      emit(GetProfileFailedState(errorMessage: "Something went wrong"));
    }
  }
}
