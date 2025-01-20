part of 'measurements_bloc.dart';

sealed class MeasurementsState {}

final class MeasurementsInitial extends MeasurementsState {}

final class GetMeasurementsLoadingState extends MeasurementsState {}
final class GetMeasurementsSuccessState extends MeasurementsState {
  final List<MeasurementsData> measurementsData;

  GetMeasurementsSuccessState({required this.measurementsData});
}
final class GetMeasurementsFailedState extends MeasurementsState {
  final String errorMessage;

  GetMeasurementsFailedState({required this.errorMessage});
}

final class ChangeDaysState extends MeasurementsState {}