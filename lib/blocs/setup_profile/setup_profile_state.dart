part of 'setup_profile_bloc.dart';

@immutable
sealed class SetupProfileState {}

final class SetupProfileInitial extends SetupProfileState {}

final class ChangeHeightState extends SetupProfileState {}
final class ChangeWeightState extends SetupProfileState {}
final class SelectBloodGroupState extends SetupProfileState {}
final class SelectGenderState extends SetupProfileState {}