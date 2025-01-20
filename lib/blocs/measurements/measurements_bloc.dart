import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medpocket/configs/app_constants.dart';
import 'package:medpocket/configs/app_urls.dart';
import 'package:medpocket/database/local_db.dart';
import 'package:medpocket/models/model.dart';
import 'package:medpocket/repositories/get_response.dart';

part 'measurements_event.dart';
part 'measurements_state.dart';

class MeasurementsBloc extends Bloc<MeasurementsEvent, MeasurementsState> {
  bool loadedMeasurements = false;
  int days = 7;
  MeasurementsBloc() : super(MeasurementsInitial()) {
    on<GetMeasurementsEvent>(getMeasurementsEvent);
    on<ChangDaysEvent>(changDaysEvent);
  }

  FutureOr<void> getMeasurementsEvent(GetMeasurementsEvent event, Emitter<MeasurementsState> emit) async {
    if (!loadedMeasurements) {
      emit(GetMeasurementsLoadingState());
    }
    try {
      final res = await getResponse(url: AppUrls.daywiseMeasurements(id: await LocalDB.getId()??"", days: days), from: "Get Measurements");
      final MeasurementsModel measurementsModel = measurementsModelFromJson(res);
      if (measurementsModel.success == true) {
        loadedMeasurements = true;
        emit(GetMeasurementsSuccessState(measurementsData: measurementsModel.data??[]));
      }else{
        emit(GetMeasurementsFailedState(errorMessage: measurementsModel.message?? "Failed to get measurements"));
        logger.e(measurementsModel.message?? "Failed to get measurements");
      }
    } catch (e) {
        emit(GetMeasurementsFailedState(errorMessage: e.toString()));
        logger.e(e.toString());
    }
  }

  FutureOr<void> changDaysEvent(ChangDaysEvent event, Emitter<MeasurementsState> emit) {
    days = event.days;
    emit(ChangeDaysState());
  }
}
