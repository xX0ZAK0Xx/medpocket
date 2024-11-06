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

class CreateSetupProfileEvent extends SetupProfileEvent{
  final String fullName, phoneNumber, bloodGroup, dateOfBirth, gender, image;
  final double height, weight;

  CreateSetupProfileEvent({required this.fullName, required this.phoneNumber, required this.bloodGroup, required this.dateOfBirth, required this.gender, required this.image, required this.height, required this.weight});
}