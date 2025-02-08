part of 'medicine_bloc.dart';
sealed class MedicineState {}
final class MedicineInitial extends MedicineState {}

//!Get All Medicine
final class GetAllMedicineLoadingState extends MedicineState{}
final class GetAllMedicineSuccessState extends MedicineState{}
final class GetAllMedicineFailedState extends MedicineState{
  final String errorMessage;

  GetAllMedicineFailedState({required this.errorMessage});
}

//!Get Single Medicine
final class GetSingleMedicineLoadingState extends MedicineState{}
final class GetSingleMedicineSuccessState extends MedicineState{
  final MedicineDataFull medicine;

  GetSingleMedicineSuccessState({required this.medicine});
}
final class GetSingleMedicineFailedState extends MedicineState{
  final String errorMessage;

  GetSingleMedicineFailedState({required this.errorMessage});
}

//! Get Todays Medicine 
final class GetTodaysMedicineLoadingState extends MedicineState{}
final class GetTodaysMedicineSuccessState extends MedicineState{
  final List<TodaysMedicineData> todaysMedicineList;

  GetTodaysMedicineSuccessState({required this.todaysMedicineList});
}
final class GetTodaysMedicineFailedState extends MedicineState {
  final String errorMessage;

  GetTodaysMedicineFailedState({required this.errorMessage});
}

//!Update Medicine State
final class UpdateMedicineLoadingState extends MedicineState{}
final class UpdateMedicineSuccessState extends MedicineState{}
final class UpdateMedicineFailedState extends MedicineState{
  final String errorMessage;

  UpdateMedicineFailedState({required this.errorMessage});
}

//!Delete Medicine State
final class DeleteMedicineLoadingState extends MedicineState{}
final class DeleteMedicineSuccessState extends MedicineState{}
final class DeleteMedicineFailedState extends MedicineState{
  final String errorMessage;

  DeleteMedicineFailedState({required this.errorMessage});
}

//!Mark as Taken State
final class MarkAsTakenMedicineLoadingState extends MedicineState{}
final class MarkAsTakenMedicineSuccessState extends MedicineState{}
final class MarkAsTakenMedicineFailedState extends MedicineState{
  final String errorMessage;

  MarkAsTakenMedicineFailedState({required this.errorMessage});
}

//!Create Medicine State
final class CreateMedicineLoadingState extends MedicineState{}
final class CreateMedicineSuccessState extends MedicineState{}
final class CreateMedicineFailedState extends MedicineState{
  final String errorMessage;

  CreateMedicineFailedState({required this.errorMessage});
}