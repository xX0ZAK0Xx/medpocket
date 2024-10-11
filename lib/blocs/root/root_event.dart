part of 'root_bloc.dart';

sealed class RootEvent {}

class RootInitialEvent extends RootEvent {}

class NavigateToHomeEvent extends RootEvent {}

class NavigateToPreRegistrationEvent extends RootEvent {}

class NavigateToPaymentEvent extends RootEvent {}

class NavigateToProfileEvent extends RootEvent {}

class BackNavigationEvent extends RootEvent {} // New event for back navigation
