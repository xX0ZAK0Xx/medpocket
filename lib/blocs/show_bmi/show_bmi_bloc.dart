import 'dart:async';

import 'package:bloc/bloc.dart';

part 'show_bmi_event.dart';
part 'show_bmi_state.dart';

class ShowBmiBloc extends Bloc<ShowBmivent, ShowBmiState> {
  ShowBmiBloc() : super(ShowBmiInitial()) {
    on<ToggleDateRangeEvent>(toggleDateRangeEvent);
  }

  FutureOr<void> toggleDateRangeEvent(ToggleDateRangeEvent event, Emitter<ShowBmiState> emit) {
    emit(ToggleDateRangeState(index: event.index));
  }
}
