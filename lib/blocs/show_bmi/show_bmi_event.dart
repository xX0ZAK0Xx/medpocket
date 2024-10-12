part of 'show_bmi_bloc.dart';

sealed class ShowBmivent {}

class ToggleDateRangeEvent extends ShowBmivent{
  final int index;

  ToggleDateRangeEvent({required this.index});
}