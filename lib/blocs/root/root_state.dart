part of 'root_bloc.dart';

sealed class RootState {}

abstract class RootActionState extends RootState {}

final class RootInitial extends RootState {}

class NavigateToHomeState extends RootState {}

class NavigateToPreRegistrationState extends RootState {}

class NavigateToProfileState extends RootState {}

class NavigateToPaymentState extends RootState {}

class ShowExistAlertState extends RootState {}