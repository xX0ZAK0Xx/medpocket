part of 'dashboard_bloc.dart';

sealed class DashboardState {}

final class DashboardInitial extends DashboardState {}

final class GetDashboardLoadingState extends DashboardState {
  final DashboardData dashboardData;

  GetDashboardLoadingState({required this.dashboardData});
}
final class GetDashboardSuccessState extends DashboardState {
  final DashboardData dashboardData;

  GetDashboardSuccessState({required this.dashboardData});
}
final class GetDashboardFailedState extends DashboardState {
  final String errorMessage;

  GetDashboardFailedState({required this.errorMessage});
}