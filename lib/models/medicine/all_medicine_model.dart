import 'dart:convert';

import 'package:flutter/widgets.dart';

import '../model.dart';

AllMedicineModel allMedicineModelFromJson(String str) => AllMedicineModel.fromJson(json.decode(str));

String allMedicineModelToJson(AllMedicineModel data) => json.encode(data.toJson());

class AllMedicineModel {
    final bool? success;
    final int? status;
    final String? message;
    final List<MedicineDataFull>? data;
    final Meta? meta;

    AllMedicineModel({
        this.success,
        this.status,
        this.message,
        this.data,
        this.meta,
    });

    factory AllMedicineModel.fromJson(Map<String, dynamic> json) => AllMedicineModel(
        success: json["success"],
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<MedicineDataFull>.from(json["data"]!.map((x) => MedicineDataFull.fromJson(x))),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "meta": meta?.toJson(),
    };
}

class MedicineDataFull {
    final MedicineDuration? duration;
    final String? id;
    final String? userId;
    final TextEditingController? medicineName;
    final TextEditingController? type;
    final TextEditingController? description;
    final Dosage? dosage;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final int? v;

    MedicineDataFull({
        this.duration,
        this.id,
        this.userId,
        this.medicineName,
        this.type,
        this.description,
        this.dosage,
        this.createdAt,
        this.updatedAt,
        this.v,
    });

    factory MedicineDataFull.fromJson(Map<String, dynamic> json) => MedicineDataFull(
        duration: json["duration"] == null ? null : MedicineDuration.fromJson(json["duration"]),
        id: json["_id"],
        userId: json["userId"],
        medicineName: TextEditingController(text: json["medicineName"] ?? ""),
        type: TextEditingController(text: json["type"] ?? ""),
        description: TextEditingController(text: json["description"] ?? ""),
        dosage: json["dosage"] == null ? null : Dosage.fromJson(json["dosage"]),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "duration": duration?.toJson(),
        "_id": id,
        "userId": userId,
        "medicineName": medicineName?.value,
        "type": type?.text,
        "description": description?.text,
        "dosage": dosage?.toJson(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
    };
}

class Dosage {
    final Dose? morning;
    final Dose? afternoon;
    final Dose? evening;
    final String? id;

    Dosage({
        this.morning,
        this.afternoon,
        this.evening,
        this.id,
    });

    factory Dosage.fromJson(Map<String, dynamic> json) => Dosage(
        morning: json["morning"] == null ? null : Dose.fromJson(json["morning"]),
        afternoon: json["afternoon"] == null ? null : Dose.fromJson(json["afternoon"]),
        evening: json["evening"] == null ? null : Dose.fromJson(json["evening"]),
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "morning": morning?.toJson(),
        "afternoon": afternoon?.toJson(),
        "evening": evening?.toJson(),
        "_id": id,
    };
}

class Dose {
    final ValueNotifier<bool>? take;
    final ValueNotifier<bool>? afterMeal;

    Dose({
        this.take,
        this.afterMeal,
    });

    factory Dose.fromJson(Map<String, dynamic> json) => Dose(
        take: ValueNotifier<bool>(json["take"]??false),
        afterMeal: ValueNotifier<bool>(json["afterMeal"]??false),
    );

    Map<String, dynamic> toJson() => {
        "take": take,
        "afterMeal": afterMeal,
    };
}

class MedicineDuration {
    final ValueNotifier<DateTime?>? start;
    final ValueNotifier<DateTime?>? end;

    MedicineDuration({
        this.start,
        this.end,
    });

    factory MedicineDuration.fromJson(Map<String, dynamic> json) => MedicineDuration(
        start: json["start"] == null ? null : ValueNotifier<DateTime?>(DateTime.parse(json["start"])),
        end: json["end"] == null ? null : ValueNotifier<DateTime?>(DateTime.parse(json["end"])),
    );

    Map<String, dynamic> toJson() => {
        "start": start?.value?.toIso8601String(),
        "end": end?.value?.toIso8601String(),
    };
}