part of 'medicine_bloc.dart';
sealed class MedicineEvent {}

class GetTodaysMedicineEvent extends MedicineEvent{
  final String token;

  GetTodaysMedicineEvent({required this.token});
}

class GetAllMedicineEvent extends MedicineEvent{
  final String token;

  GetAllMedicineEvent({required this.token});
}

class GetSingleMedicineEvent extends MedicineEvent{
  final String medicineId;

  GetSingleMedicineEvent({required this.medicineId});
}

class UpdateMedicineEvent extends MedicineEvent{
  final String token, medicineId;

  UpdateMedicineEvent({required this.token, required this.medicineId});
}

class DeleteMedicineEvent extends MedicineEvent{
  final String token, medicineId;

  DeleteMedicineEvent({required this.token, required this.medicineId});
}

class CreateMedicineEvent extends MedicineEvent{
  final String token;
  final List<MedicineDataFull> medicineList;

  CreateMedicineEvent({required this.token, required this.medicineList});
}

class MarkAsTakenEvent extends MedicineEvent{
  final String token, medicineId, slotName;
  final bool hasTaken;

  MarkAsTakenEvent({required this.token, required this.medicineId, required this.slotName, required this.hasTaken});
}