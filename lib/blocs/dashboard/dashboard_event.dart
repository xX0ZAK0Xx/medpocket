part of 'dashboard_bloc.dart';

sealed class DashboardEvent {}

class GetDashboardEvent extends DashboardEvent {}
class UpdateHeightWeightEvent extends DashboardEvent {
  final int feet, inch, weight;

  UpdateHeightWeightEvent({required this.feet, required this.inch, required this.weight});
}