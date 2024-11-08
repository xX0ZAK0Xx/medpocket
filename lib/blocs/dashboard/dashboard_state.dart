part of 'dashboard_bloc.dart';

sealed class DashboardState {}

final class DashboardInitial extends DashboardState {}

//?Get DashboardData
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

//?Update HeightWeight
final class UpdateHeightWeightLoadingState extends DashboardState {}
final class UpdateHeightWeightSuccessState extends DashboardState {}
final class UpdateHeightWeightFailedState extends DashboardState {
  final String errorMessage;

  UpdateHeightWeightFailedState({required this.errorMessage});
}

//?Update BloodPressure
final class UpdateBloodPressureLoadingState extends DashboardState {}
final class UpdateBloodPressureSuccessState extends DashboardState {}
final class UpdateBloodPressureFailedState extends DashboardState {
  final String errorMessage;

  UpdateBloodPressureFailedState({required this.errorMessage});
}