part of 'root_bloc.dart';

sealed class RootEvent {}

class RootInitialEvent extends RootEvent {}

class NavigateToHomeEvent extends RootEvent {}

class NavigateToMedicineEvent extends RootEvent {}

class NavigateToReportsEvent extends RootEvent {}

class NavigateToProfileEvent extends RootEvent {}

class BackNavigationEvent extends RootEvent {} // New event for back navigation
