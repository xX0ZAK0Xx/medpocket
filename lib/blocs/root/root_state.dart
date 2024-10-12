part of 'root_bloc.dart';

sealed class RootState {}

abstract class RootActionState extends RootState {}

final class RootInitial extends RootState {}

class NavigateToHomeState extends RootState {}

class NavigateToMedicineState extends RootState {}

class NavigateToProfileState extends RootState {}

class NavigateToReportsState extends RootState {}

class ShowExistAlertState extends RootState {}