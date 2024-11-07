part of 'setup_profile_bloc.dart';

@immutable
sealed class SetupProfileEvent {}

class ChangeFeetEvent extends SetupProfileEvent{
  final int feet;

  ChangeFeetEvent({required this.feet});
}
class ChangeInchEvent extends SetupProfileEvent{
  final int inch;

  ChangeInchEvent({required this.inch});
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

class CreateSetupProfileEvent extends SetupProfileEvent{
  final String fullName, phoneNumber, bloodGroup, dateOfBirth, gender, image;
  final double height;
  final int weight;

  CreateSetupProfileEvent({required this.fullName, required this.phoneNumber, required this.bloodGroup, required this.dateOfBirth, required this.gender, this.image = "", required this.height, required this.weight});
}

class GetProfileEvent extends SetupProfileEvent{}