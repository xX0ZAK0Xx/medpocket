part of 'show_bmi_bloc.dart';

sealed class ShowBmiState {}

final class ShowBmiInitial extends ShowBmiState {}

final class ToggleDateRangeState extends ShowBmiState {
  final int index;

  ToggleDateRangeState({required this.index});
}
