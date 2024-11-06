part of 'setup_profile_bloc.dart';

@immutable
sealed class SetupProfileState {}

final class SetupProfileInitial extends SetupProfileState {}

final class ChangeHeightState extends SetupProfileState {}
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