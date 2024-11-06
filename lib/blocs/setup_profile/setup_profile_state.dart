part of 'setup_profile_bloc.dart';

@immutable
sealed class SetupProfileState {}

final class SetupProfileInitial extends SetupProfileState {}

final class ChangeFeetState extends SetupProfileState {}
final class ChangeInchState extends SetupProfileState {}
final class ChangeWeightState extends SetupProfileState {}
final class SelectBloodGroupState extends SetupProfileState {}
final class SelectGenderState extends SetupProfileState {}

//?Setup Profile
final class CreateSetupProfileLoadingState extends SetupProfileState{}
final class CreateSetupProfileSuccessState extends SetupProfileState{}
final class CreateSetupProfileFailedState extends SetupProfileState{
  final String errorMessage;

  CreateSetupProfileFailedState({required this.errorMessage});
}

//? Get Profile
final class GetProfileLoadingState extends SetupProfileState{}
final class GetProfileSuccessState extends SetupProfileState{
  final ProfileData data;

  GetProfileSuccessState({required this.data});
}
final class GetProfileFailedState extends SetupProfileState{
  final String errorMessage;

  GetProfileFailedState({required this.errorMessage});
}