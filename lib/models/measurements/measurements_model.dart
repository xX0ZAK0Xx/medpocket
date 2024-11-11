import 'dart:convert';

import '../model.dart';

MeasurementsModel measurementsModelFromJson(String str) => MeasurementsModel.fromJson(json.decode(str));

String measurementsModelToJson(MeasurementsModel data) => json.encode(data.toJson());

class MeasurementsModel {
    final bool? success;
    final int? status;
    final String? message;
    final List<MeasurementsData>? data;
    final Meta? meta;

    MeasurementsModel({
        this.success,
        this.status,
        this.message,
        this.data,
        this.meta,
    });

    factory MeasurementsModel.fromJson(Map<String, dynamic> json) => MeasurementsModel(
        success: json["success"],
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<MeasurementsData>.from(json["data"]!.map((x) => MeasurementsData.fromJson(x))),
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

class MeasurementsData {
    final String? id;
    final String? userId;
    final num? height;
    final num? weight;
    final num? bmi;
    final DateTime? date;
    final int? v;

    MeasurementsData({
        this.id,
        this.userId,
        this.height,
        this.weight,
        this.bmi,
        this.date,
        this.v,
    });

    factory MeasurementsData.fromJson(Map<String, dynamic> json) => MeasurementsData(
        id: json["_id"],
        userId: json["user_id"],
        height: json["height"]?.toDouble(),
        weight: json["weight"],
        bmi: json["bmi"]?.toDouble(),
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "user_id": userId,
        "height": height,
        "weight": weight,
        "bmi": bmi,
        "date": date?.toIso8601String(),
        "__v": v,
    };
}