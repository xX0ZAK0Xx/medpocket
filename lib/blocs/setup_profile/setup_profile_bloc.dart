import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

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
}
