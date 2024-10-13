part of 'setup_profile_bloc.dart';

@immutable
sealed class SetupProfileEvent {}

class ChangeHeightEvent extends SetupProfileEvent{
  final int height;

  ChangeHeightEvent({required this.height});
}

class ChangeWeightEvent extends SetupProfileEvent{
  final int weight;

  ChangeWeightEvent({required this.weight});
}

class SelecteBloodGroupEvent extends SetupProfileEvent{
  final String bloodGroup;

  SelecteBloodGroupEvent({required this.bloodGroup});
}

class SelecteGenderEvent extends SetupProfileEvent{
  final String gender;

  SelecteGenderEvent({required this.gender});
}