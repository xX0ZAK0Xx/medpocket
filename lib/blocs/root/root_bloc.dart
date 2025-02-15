import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'root_event.dart';
part 'root_state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  int currentPage = 0;
  final List<int> _pageHistory = [];

  RootBloc() : super(RootInitial()) {
    on<RootInitialEvent>(rootInitialEvent);
    on<NavigateToHomeEvent>(navigateToHomeEvent);
    on<NavigateToMedicineEvent>(navigateToMedicineEvent);
    on<NavigateToReportsEvent>(navigateToReportsEvent);
    on<NavigateToProfileEvent>(navigateToProfileEvent);
    on<BackNavigationEvent>(backNavigationEvent); // Handle back button event
  }

  FutureOr<void> rootInitialEvent(RootInitialEvent event, Emitter<RootState> emit) {
    currentPage = 0;
    emit(NavigateToHomeState());
    _pageHistory.clear(); // Clear history on app start
    // currentPage = 1;
    // emit(NavigateToMedicineState());
  }

  FutureOr<void> navigateToHomeEvent(NavigateToHomeEvent event, Emitter<RootState> emit) {
    _updatePageHistory(0);
    emit(NavigateToHomeState());
  }

  FutureOr<void> navigateToMedicineEvent(NavigateToMedicineEvent event, Emitter<RootState> emit) {
    _updatePageHistory(1);
    emit(NavigateToMedicineState());
  }

  FutureOr<void> navigateToReportsEvent(NavigateToReportsEvent event, Emitter<RootState> emit) {
    _updatePageHistory(2);
    emit(NavigateToReportsState());
  }

  FutureOr<void> navigateToProfileEvent(NavigateToProfileEvent event, Emitter<RootState> emit) {
    _updatePageHistory(3);
    emit(NavigateToProfileState());
  }

  FutureOr<void> backNavigationEvent(BackNavigationEvent event, Emitter<RootState> emit) {
    if (_pageHistory.isNotEmpty) {
      _pageHistory.removeLast(); // Remove current page
      final lastPage = _pageHistory.isNotEmpty ? _pageHistory.last : 0; // Get last visited page
      currentPage = lastPage;

      switch (currentPage) {
        case 0:
          emit(NavigateToHomeState());
          break;
        case 1:
          emit(NavigateToMedicineState());
          break;
        case 2:
          emit(NavigateToReportsState());
          break;
        case 3:
          emit(NavigateToProfileState());
          break;
      }
    }else{
      emit(ShowExistAlertState());
    }
  }

  void _updatePageHistory(int newPageIndex) {
    if (currentPage != newPageIndex) {
      _pageHistory.add(newPageIndex);
      currentPage = newPageIndex;
    }
  }
}
