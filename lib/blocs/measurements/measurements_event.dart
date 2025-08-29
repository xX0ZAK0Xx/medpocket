part of 'measurements_bloc.dart';

sealed class MeasurementsEvent {}

// class ChangDaysEvent extends MeasurementsEvent {
//   final int days;

//   ChangDaysEvent({required this.days});
// }

class GetMeasurementsEvent extends MeasurementsEvent {
  final int days;

  GetMeasurementsEvent({required this.days});
}