import 'dart:convert';

import '../model.dart';

TodaysMedicineModel todaysMedicineModelFromJson(String str) => TodaysMedicineModel.fromJson(json.decode(str));

String todaysMedicineModelToJson(TodaysMedicineModel data) => json.encode(data.toJson());

class TodaysMedicineModel {
    final bool? success;
    final int? status;
    final String? message;
    final TodaysMedicineData? data;
    final Meta? meta;

    TodaysMedicineModel({
        this.success,
        this.status,
        this.message,
        this.data,
        this.meta,
    });

    factory TodaysMedicineModel.fromJson(Map<String, dynamic> json) => TodaysMedicineModel(
        success: json["success"],
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : TodaysMedicineData.fromJson(json["data"]),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "status": status,
        "message": message,
        "data": data?.toJson(),
        "meta": meta?.toJson(),
    };
}

class TodaysMedicineData {
    final List<MedicineData>? morning;
    final List<MedicineData>? afternoon;
    final List<MedicineData>? evening;

    TodaysMedicineData({
        this.morning,
        this.afternoon,
        this.evening,
    });

    factory TodaysMedicineData.fromJson(Map<String, dynamic> json) => TodaysMedicineData(
        morning: json["morning"] == null ? [] : List<MedicineData>.from(json["morning"]!.map((x) => MedicineData.fromJson(x))),
        afternoon: json["afternoon"] == null ? [] : List<MedicineData>.from(json["afternoon"]!.map((x) => MedicineData.fromJson(x))),
        evening: json["evening"] == null ? [] : List<MedicineData>.from(json["evening"]!.map((x) => MedicineData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "morning": morning == null ? [] : List<dynamic>.from(morning!.map((x) => x.toJson())),
        "afternoon": afternoon == null ? [] : List<dynamic>.from(afternoon!.map((x) => x.toJson())),
        "evening": evening == null ? [] : List<dynamic>.from(evening!.map((x) => x.toJson())),
    };
}

class MedicineData {
    final String? id;
    final String? medicineName;
    final String? type;
    final bool? afterMeal;
    final bool? hasTaken;

    MedicineData({
        this.id,
        this.medicineName,
        this.type,
        this.afterMeal,
        this.hasTaken,
    });

    factory MedicineData.fromJson(Map<String, dynamic> json) => MedicineData(
        id: json["_id"],
        medicineName: json["medicineName"],
        type: json["type"],
        afterMeal: json["afterMeal"],
        hasTaken: json["hasTaken"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "medicineName": medicineName,
        "type": type,
        "afterMeal": afterMeal,
        "hasTaken": hasTaken,
    };
}