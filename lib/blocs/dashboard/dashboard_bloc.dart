import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:medpocket/configs/app_constants.dart';
import 'package:medpocket/configs/app_urls.dart';
import 'package:medpocket/database/local_db.dart';
import 'package:medpocket/models/model.dart';
import 'package:medpocket/utils/utils.dart';

import '../../repositories/repositories.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  int feet = 0, inch = 0, weight = 0, highPressure = 0, lowPressure = 0;
  double glucose = 0.0;

  DashboardBloc() : super(DashboardInitial()) {
    on<GetDashboardEvent>(getDashboardEvent);

    on<UpdateHeightWeightEvent>(updateHeightWeightEvent);
    on<UpdateBloodPressureEvent>(updateBloodPressureEvent);
    on<UpdateGlucoseEvent>(updateGlucoseEvent);

    on<GetDaywiseGlucoseEvent>(getDaywiseGlucoseEvent);
    on<GetDaywisePressureEvent>(getDaywisePressureEvent);
  }

  FutureOr<void> getDashboardEvent(GetDashboardEvent event, Emitter<DashboardState> emit) async {
    emit(GetDashboardLoadingState(dashboardData: DashboardData(
      glucose: DashboardGlucose(
        date: DateTime.now(),
        glucose: glucose,
      ),
      measurements: DashboardMeasurements(
        bmi: 0,
        height: feetInchesToCm(foot: feet, inch: inch),
        weight: weight,
        date: DateTime.now()
      ),
      pressure: DashboardPressure(
        data: DateTime.now(),
        highPressure: highPressure,
        lowPressure: lowPressure,
      )
    )));
    try {
      final res = await getResponse(url: AppUrls.dashboard(id: await LocalDB.getId()??""), from: "Get Dashboard Data");
      final DashboardModel dashboardModel = dashboardModelFromJson(res);
      if(dashboardModel.success == true) {
        feet = cmToFeetInches(dashboardModel.data?.measurements?.height??0).foot;
        inch = cmToFeetInches(dashboardModel.data?.measurements?.height??0).inch;
        weight = dashboardModel.data?.measurements?.weight??0;
        highPressure = dashboardModel.data?.pressure?.highPressure??0;
        lowPressure = dashboardModel.data?.pressure?.lowPressure??0;
        glucose = dashboardModel.data?.glucose?.glucose??0;
        emit(GetDashboardSuccessState(dashboardData: DashboardData(
          glucose: DashboardGlucose(glucose: glucose, date: dashboardModel.data?.glucose?.date?? DateTime.now()),
          measurements: DashboardMeasurements(
            height: feetInchesToCm(foot: feet, inch: inch),
            weight: weight,
            bmi: dashboardModel.data?.measurements?.bmi??0,
            date: dashboardModel.data?.measurements?.date?? DateTime.now(),
          ),
          pressure: DashboardPressure(highPressure: highPressure, lowPressure: lowPressure, data: dashboardModel.data?.pressure?.data?? DateTime.now())
        )));
      }else{
        emit(GetDashboardFailedState(errorMessage: dashboardModel.message??"Failed to get dashboard data"));
        logger.e(dashboardModel.message??"Failed to get dashboard data");
      }
    } catch (e) {
        logger.e(e.toString());
        emit(GetDashboardFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> updateHeightWeightEvent(UpdateHeightWeightEvent event, Emitter<DashboardState> emit) async {
    emit(UpdateHeightWeightLoadingState());
    try {
      final payload = {
        "height" : feetInchesToCm(foot: event.feet, inch: event.inch).toString(),
        "weight" : event.weight.toString(),
      };
      logger.d("payload: $payload");
      final res = await postResponse(url: AppUrls.measurements(id: await LocalDB.getId()??""), payload: payload);
      final ResponseModel responseModel = responseModelFromJson(res);
      if(responseModel.success == true) {
        emit(UpdateHeightWeightSuccessState());
      }else{
        emit(UpdateHeightWeightFailedState(errorMessage: responseModel.message??"Failed to update height and weight"));
        logger.e(responseModel.message??"Failed to update height and weight");
      }
    } catch (e) {
      emit(UpdateHeightWeightFailedState(errorMessage: e.toString()));
      logger.e(e.toString());
    }
  }

  FutureOr<void> updateBloodPressureEvent(UpdateBloodPressureEvent event, Emitter<DashboardState> emit) async {
    emit(UpdateBloodPressureLoadingState());
    try {
      final payload = {
        "high_pressure" : event.high.toString(),
        "low_pressure" : event.low.toString(),
      };
      logger.d("payload: $payload");
      final res = await postResponse(url: AppUrls.pressure(id: await LocalDB.getId()??""), payload: payload);
      final ResponseModel responseModel = responseModelFromJson(res);
      if(responseModel.success == true) {
        emit(UpdateBloodPressureSuccessState());
      }else{
        emit(UpdateBloodPressureFailedState(errorMessage: responseModel.message??"Failed to update blood pressure"));
        logger.e(responseModel.message??"Failed to update blood pressure");
      }
    } catch (e) {
      emit(UpdateBloodPressureFailedState(errorMessage: e.toString()));
      logger.e(e.toString());
    }
  }

  FutureOr<void> updateGlucoseEvent(UpdateGlucoseEvent event, Emitter<DashboardState> emit) async {
    emit(UpdateGlucoseLoadingState());
    try {
      final payload = {
        "glucose" : event.glucose.toString(),
      };
      logger.d("payload: $payload");
      final res = await postResponse(url: AppUrls.glucose(id: await LocalDB.getId()??""), payload: payload);
      final ResponseModel responseModel = responseModelFromJson(res);
      if(responseModel.success == true) {
        emit(UpdateGlucoseSuccessState());
      }else{
        emit(UpdateGlucoseFailedState(errorMessage: responseModel.message??"Failed to update blood pressure"));
        logger.e(responseModel.message??"Failed to update blood pressure");
      }
    } catch (e) {
      emit(UpdateGlucoseFailedState(errorMessage: e.toString()));
      logger.e(e.toString());
    }
  }

  FutureOr<void> getDaywisePressureEvent(GetDaywisePressureEvent event, Emitter<DashboardState> emit)async {
    emit(GetDaywisePressureLoadingState());
    try {
      final res = await getResponse(url: AppUrls.daywisePressure(id: await LocalDB.getId()??"", days: 1), from: "Get Daywise Pressure Data");
      final DayWisePressuresModel dayWisePressuresModel = dayWisePressuresModelFromJson(res);
      if(dayWisePressuresModel.success == true) {
        emit(GetDaywisePressureSuccessState(dayWisePressureList: dayWisePressuresModel.data?? []));
      }else{
        logger.e(dayWisePressuresModel.message??"Failed to get daywise pressure data");
        emit(GetDaywisePressureFailedState(errorMessage: dayWisePressuresModel.message??"Failed to get daywise pressure data"));
      }
    } catch (e) {
      logger.e(e.toString());
      emit(GetDaywisePressureFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> getDaywiseGlucoseEvent(GetDaywiseGlucoseEvent event, Emitter<DashboardState> emit)async {
    emit(GetDaywiseGlucoseLoadingState());
    try {
      final res = await getResponse(url: AppUrls.daywiseGlucose(id: await LocalDB.getId()??"", days: 1), from: "Get Daywise Glucose Data");
      final DayWiseGlucoseModel dayWiseGlucoseModel = dayWiseGlucoseModelFromJson(res);
      if(dayWiseGlucoseModel.success == true) {
        emit(GetDaywiseGlucoseSuccessState(dayWiseGlucoseList: dayWiseGlucoseModel.data?? []));
      }else{
        logger.e(dayWiseGlucoseModel.message??"Failed to get daywise Glucose data");
        emit(GetDaywisePressureFailedState(errorMessage: dayWiseGlucoseModel.message??"Failed to get daywise Glucose data"));
      }
    } catch (e) {
      logger.e(e.toString());
      emit(GetDaywisePressureFailedState(errorMessage: e.toString()));
    }
  }
}
