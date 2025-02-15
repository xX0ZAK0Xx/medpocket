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
  String token = "";

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
      token = event.token;
      final res = await getResponse(url: AppUrls.allMedicine(userId: await LocalDB.getId() ?? ""), from: "Get AllMedicine Event", token: event.token,);
      final AllMedicineModel allMedicineModel = allMedicineModelFromJson(res);

      if(allMedicineModel.success == true && allMedicineModel.data != null) {
        allMedicine = allMedicineModel.data ?? [];
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
    if(allMedicine.isEmpty)emit(GetTodaysMedicineLoadingState());
    try {
      final res = await getResponse(url: AppUrls.todaysMedicine(userId: await LocalDB.getId() ?? ""), from: "Get Todays Event", token: event.token,);
      final TodaysMedicineModel todaysMedicineModel = todaysMedicineModelFromJson(res);

      if(todaysMedicineModel.success == true && todaysMedicineModel.data != null) {
        emit(GetTodaysMedicineSuccessState(todaysMedicine: todaysMedicineModel.data!));
      }else{
        emit(GetTodaysMedicineFailedState(errorMessage: todaysMedicineModel.message??"Something went wrong"));
      }
    } catch (e, k) {
      logger.e("$e: $k");
      emit(GetTodaysMedicineFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> updateMedicineEvent(UpdateMedicineEvent event, Emitter<MedicineState> emit) async {
    emit(UpdateMedicineLoadingState());
    try {
      final Map<String, dynamic> payload = {
        "medicineName": event.name,
        "type": event.type,
        "description": event.description,
        "dosage": {
            "morning": {
                "take": event.morningTake,
                "afterMeal": event.morningAfterMeal
            },
            "afternoon": {
                "take": event.afterNoonTake,
                "afterMeal": event.afterNoonAfterMeal
            },
            "evening": {
                "take": event.eveningTake,
                "afterMeal": event.eveningAfterMeal
            }
        },
        "duration": {
            "start": event.start.toIso8601String(), // This will match today's start (midnight UTC)
            "end": event.end.toIso8601String() // This is the end of today (midnight UTC next day)
        }
      };
      logger.f("payload: $payload");
      final res = await putResponse(url: AppUrls.updateMedicine(medicineId: event.medicineId), token: event.token, payload: payload);
      final ResponseModel responseModel = responseModelFromJson(res);

      if(responseModel.success == true) {
        emit(UpdateMedicineSuccessState());
      }else{
        emit(UpdateMedicineFailedState(errorMessage: responseModel.message??"Something went wrong"));
      }
    } catch (e, k) {
      logger.e("$e: $k");
      emit(UpdateMedicineFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> deleteMedicineEvent(DeleteMedicineEvent event, Emitter<MedicineState> emit) async {
    emit(DeleteMedicineLoadingState());
    try {
      final res = await deleteResponse(url: AppUrls.deleteMedicine(medicineId: event.medicineId), token: event.token, from: "delete medicine");
      final ResponseModel responseModel = responseModelFromJson(res);
      if(responseModel.success == true) {
        emit(DeleteMedicineSuccessState());
      }else{
        emit(DeleteMedicineFailedState(errorMessage: responseModel.message??"Something went wrong"));
      }
    } catch (e, k) {
      logger.e("$e: $k");
      emit(DeleteMedicineFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> createMedicineEvent(CreateMedicineEvent event, Emitter<MedicineState> emit) async {
    emit(CreateMedicineLoadingState());
    try {
      final String userId = await LocalDB.getId() ?? "";
      final List payload = event.medicineList.map((medicine) => {
        "userId": userId,
        "medicineName": medicine.medicineName?.text,
        "type": medicine.type?.text,
        "description": "description",
        "dosage": {
            "morning": {
                "take": medicine.dosage?.morning?.take?.value,
                "afterMeal": medicine.dosage?.morning?.afterMeal?.value
            },
            "afternoon": {
                "take": medicine.dosage?.afternoon?.take?.value,
                "afterMeal": medicine.dosage?.afternoon?.afterMeal?.value
            },
            "evening": {
                "take": medicine.dosage?.evening?.take?.value,
                "afterMeal": medicine.dosage?.evening?.afterMeal?.value
            }
        },
        "duration": {
            "start": medicine.duration?.start?.value?.toUtc().toString(), // This will match today's start (midnight UTC)
            "end": medicine.duration?.end?.value?.toUtc().toString() // This is the end of today (midnight UTC next day)
        }
      }).toList();
      logger.i("payload: $payload");
      final res = await postResponse(url: AppUrls.createMedicine, token: event.token, payload: payload);
      logger.f("res: $res");
      final ResponseModel responseModel = responseModelFromJson(res);

      if(responseModel.success == true) {
        emit(CreateMedicineSuccessState());
      }else{
        emit(CreateMedicineFailedState(errorMessage: responseModel.message??"Something went wrong"));
      }
    } catch (e, k) {
      logger.e("$e: $k");
      emit(CreateMedicineFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> markAsTakenEvent(MarkAsTakenEvent event, Emitter<MedicineState> emit) async {
    emit(MarkAsTakenMedicineLoadingState());
    try {
      final Map<String, dynamic> payload = {
          "userId": await LocalDB.getId(),
          "medicineId": event.medicineId,
          "slotName": event.slotName.toLowerCase(),
          "hasTaken": event.hasTaken
      };
      logger.i("payload: $payload");
      final res = await putResponse(url: AppUrls.markAsTaken, token: event.token, payload: payload);
      final ResponseModel responseModel = responseModelFromJson(res);

      if(responseModel.success == true) {
        emit(MarkAsTakenMedicineSuccessState());
      }else{
        emit(MarkAsTakenMedicineFailedState(errorMessage: responseModel.message??"Something went wrong"));
      }
    } catch (e, k) {
      logger.e("$e: $k");
      emit(MarkAsTakenMedicineFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> getSingleMedicineEvent(GetSingleMedicineEvent event, Emitter<MedicineState> emit) async {
    try {
      emit(GetSingleMedicineLoadingState());

      int retryCount = 2;
      while (allMedicine.isEmpty && retryCount > 0) {
        final res = await getResponse(
          url: AppUrls.allMedicine(userId: await LocalDB.getId() ?? ""), 
          from: "Get AllMedicine Event", 
          token: token,
        );

        final AllMedicineModel allMedicineModel = allMedicineModelFromJson(res);
        if (allMedicineModel.success == true && allMedicineModel.data != null) {
          allMedicine = allMedicineModel.data ?? [];
        }
        retryCount--;
      }

      // Check if we have medicine data after fetching
      if (allMedicine.isEmpty) {
        emit(GetSingleMedicineFailedState(errorMessage: "Could not load data. Please try again later."));
        return;
      }

      // Try to find the medicine in the list
      final medicine = allMedicine.firstWhere(
        (medicine) => medicine.id == event.medicineId,
        orElse: () => MedicineDataFull(id: "-1"), // Default value
      );

      if (medicine.id == "-1") {
        emit(GetSingleMedicineFailedState(errorMessage: "Medicine not found."));
      } else {
        emit(GetSingleMedicineSuccessState(medicine: medicine));
      }
    } catch (e, k) {
      logger.e("$e, $k");
      emit(GetSingleMedicineFailedState(errorMessage: e.toString()));
    }
  }
}
