import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medpocket/database/local_db.dart';

import '../../configs/app_constants.dart';
import '../../configs/app_urls.dart';
import '../../models/model.dart';
import '../../repositories/repositories.dart';

part 'medicine_event.dart';
part 'medicine_state.dart';

class MedicineBloc extends Bloc<MedicineEvent, MedicineState> {
  List<MedicineDataFull> allMedicine = [];

  MedicineBloc() : super(MedicineInitial()) {
    on<GetAllMedicineEvent>(getAllMedicineEvent);
    on<GetTodaysMedicineEvent>(getTodaysMedicineEvent);
    on<UpdateMedicineEvent>(updateMedicineEvent);
    on<DeleteMedicineEvent>(deleteMedicineEvent);
    on<CreateMedicineEvent>(createMedicineEvent);
    on<MarkAsTakenEvent>(markAsTakenEvent);
    on<GetSingleMedicineEvent>(getSingleMedicineEvent);
  }

  FutureOr<void> getAllMedicineEvent(GetAllMedicineEvent event, Emitter<MedicineState> emit) async {
    emit(GetAllMedicineLoadingState());
    try {
      final res = await getResponse(url: AppUrls.allMedicine(userId: await LocalDB.getId() ?? ""), from: "Get AllMedicine Event", token: event.token,);
      final AllMedicineModel allMedicineModel = allMedicineModelFromJson(res);

      if(allMedicineModel.success == true && allMedicineModel.data != null) {
        emit(GetAllMedicineSuccessState());
      }else{
        emit(GetAllMedicineFailedState(errorMessage: allMedicineModel.message??"Something went wrong"));
      }
    } catch (e, k) {
      logger.e("$e: $k");
      emit(GetAllMedicineFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> getTodaysMedicineEvent(GetTodaysMedicineEvent event, Emitter<MedicineState> emit) async {
  }

  FutureOr<void> updateMedicineEvent(UpdateMedicineEvent event, Emitter<MedicineState> emit) async {
  }

  FutureOr<void> deleteMedicineEvent(DeleteMedicineEvent event, Emitter<MedicineState> emit) async {
  }

  FutureOr<void> createMedicineEvent(CreateMedicineEvent event, Emitter<MedicineState> emit) async {
  }

  FutureOr<void> markAsTakenEvent(MarkAsTakenEvent event, Emitter<MedicineState> emit) async {
  }

  FutureOr<void> getSingleMedicineEvent(GetSingleMedicineEvent event, Emitter<MedicineState> emit) async {
  }
}
