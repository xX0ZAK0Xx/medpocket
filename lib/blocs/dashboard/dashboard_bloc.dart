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
        highPressure = dashboardModel.data?.pressure?.highPressure??0;
        lowPressure = dashboardModel.data?.pressure?.lowPressure??0;
        glucose = dashboardModel.data?.glucose?.glucose??0;
        emit(GetDashboardSuccessState(dashboardData: dashboardModel.data??DashboardData()));
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
}
