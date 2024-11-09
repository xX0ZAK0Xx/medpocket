import 'dart:convert';

import '../model.dart';

DayWisePressuresModel dayWisePressuresModelFromJson(String str) => DayWisePressuresModel.fromJson(json.decode(str));

String dayWisePressuresModelToJson(DayWisePressuresModel data) => json.encode(data.toJson());

class DayWisePressuresModel {
    final bool? success;
    final int? status;
    final String? message;
    final List<DayWisePressureData>? data;
    final Meta? meta;

    DayWisePressuresModel({
        this.success,
        this.status,
        this.message,
        this.data,
        this.meta,
    });

    factory DayWisePressuresModel.fromJson(Map<String, dynamic> json) => DayWisePressuresModel(
        success: json["success"],
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<DayWisePressureData>.from(json["data"]!.map((x) => DayWisePressureData.fromJson(x))),
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

class DayWisePressureData {
    final String? id;
    final String? userId;
    final int? highPressure;
    final int? lowPressure;
    final DateTime? date;
    final int? v;

    DayWisePressureData({
        this.id,
        this.userId,
        this.highPressure,
        this.lowPressure,
        this.date,
        this.v,
    });

    factory DayWisePressureData.fromJson(Map<String, dynamic> json) => DayWisePressureData(
        id: json["_id"],
        userId: json["user_id"],
        highPressure: json["high_pressure"],
        lowPressure: json["low_pressure"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "user_id": userId,
        "high_pressure": highPressure,
        "low_pressure": lowPressure,
        "date": date?.toIso8601String(),
        "__v": v,
    };
}