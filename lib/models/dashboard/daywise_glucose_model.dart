// To parse this JSON data, do
//
//     final dayWiseGlucoseModel = dayWiseGlucoseModelFromJson(jsonString);

import 'dart:convert';

import '../model.dart';

DayWiseGlucoseModel dayWiseGlucoseModelFromJson(String str) => DayWiseGlucoseModel.fromJson(json.decode(str));

String dayWiseGlucoseModelToJson(DayWiseGlucoseModel data) => json.encode(data.toJson());

class DayWiseGlucoseModel {
    final bool? success;
    final int? status;
    final String? message;
    final List<DayWiseGlucoseData>? data;
    final Meta? meta;

    DayWiseGlucoseModel({
        this.success,
        this.status,
        this.message,
        this.data,
        this.meta,
    });

    factory DayWiseGlucoseModel.fromJson(Map<String, dynamic> json) => DayWiseGlucoseModel(
        success: json["success"],
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<DayWiseGlucoseData>.from(json["data"]!.map((x) => DayWiseGlucoseData.fromJson(x))),
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

class DayWiseGlucoseData {
    final String? id;
    final String? userId;
    final double? glucose;
    final DateTime? date;
    final int? v;

    DayWiseGlucoseData({
        this.id,
        this.userId,
        this.glucose,
        this.date,
        this.v,
    });

    factory DayWiseGlucoseData.fromJson(Map<String, dynamic> json) => DayWiseGlucoseData(
        id: json["_id"],
        userId: json["user_id"],
        glucose: json["glucose"]?.toDouble(),
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "user_id": userId,
        "glucose": glucose,
        "date": date?.toIso8601String(),
        "__v": v,
    };
}