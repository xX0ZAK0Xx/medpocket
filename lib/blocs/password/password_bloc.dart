import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'password_event.dart';
part 'password_state.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  bool passwordVisible = false;
  PasswordBloc() : super(PasswordInitial()) {
    on<TogglePasswordEvent>(togglePasswordEvent);
  }

  FutureOr<void> togglePasswordEvent(TogglePasswordEvent event, Emitter<PasswordState> emit) {
    passwordVisible =!passwordVisible;
    emit(TogglePasswordState());
  }
}
