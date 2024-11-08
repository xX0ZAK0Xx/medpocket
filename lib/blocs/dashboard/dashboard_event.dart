part of 'dashboard_bloc.dart';

sealed class DashboardEvent {}

class GetDashboardEvent extends DashboardEvent {}
//?Height and Weight Update Event
class UpdateHeightWeightEvent extends DashboardEvent {
  final int feet, inch, weight;

  UpdateHeightWeightEvent({required this.feet, required this.inch, required this.weight});
}
//?Blood Pressure Update Event
class UpdateBloodPressureEvent extends DashboardEvent {
  final int high, low;

  UpdateBloodPressureEvent({required this.high, required this.low});
}