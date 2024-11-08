import 'dart:convert';

import '../model.dart';

DashboardModel dashboardModelFromJson(String str) => DashboardModel.fromJson(json.decode(str));

String dashboardModelToJson(DashboardModel data) => json.encode(data.toJson());

class DashboardModel {
    final bool? success;
    final int? status;
    final String? message;
    final DashboardData? data;
    final Meta? meta;

    DashboardModel({
        this.success,
        this.status,
        this.message,
        this.data,
        this.meta,
    });

    factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
        success: json["success"],
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : DashboardData.fromJson(json["data"]),
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

class DashboardData {
    final DashboardGlucose? glucose;
    final DashboardMeasurements? measurements;
    final DashboardPressure? pressure;

    DashboardData({
        this.glucose,
        this.measurements,
        this.pressure,
    });

    factory DashboardData.fromJson(Map<String, dynamic> json) => DashboardData(
        glucose: json["glucose"] == null ? null : DashboardGlucose.fromJson(json["glucose"]),
        measurements: json["measurements"] == null ? null : DashboardMeasurements.fromJson(json["measurements"]),
        pressure: json["pressure"] == null ? null : DashboardPressure.fromJson(json["pressure"]),
    );

    Map<String, dynamic> toJson() => {
        "glucose": glucose?.toJson(),
        "measurements": measurements?.toJson(),
        "pressure": pressure?.toJson(),
    };
}

class DashboardGlucose {
    final double? glucose;
    final DateTime? date;

    DashboardGlucose({
        this.glucose,
        this.date,
    });

    factory DashboardGlucose.fromJson(Map<String, dynamic> json) => DashboardGlucose(
        glucose: json["glucose"]?.toDouble(),
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
    );

    Map<String, dynamic> toJson() => {
        "glucose": glucose,
        "date": date?.toIso8601String(),
    };
}

class DashboardMeasurements {
    final double? height;
    final int? weight;
    final double? bmi;
    final DateTime? date;

    DashboardMeasurements({
        this.height,
        this.weight,
        this.bmi,
        this.date,
    });

    factory DashboardMeasurements.fromJson(Map<String, dynamic> json) => DashboardMeasurements(
        height: json["height"]?.toDouble(),
        weight: json["weight"],
        bmi: json["bmi"]?.toDouble(),
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
    );

    Map<String, dynamic> toJson() => {
        "height": height,
        "weight": weight,
        "bmi": bmi,
        "date": date?.toIso8601String(),
    };
}

class DashboardPressure {
    final int? lowPressure;
    final int? highPressure;
    final DateTime? data;

    DashboardPressure({
        this.lowPressure,
        this.highPressure,
        this.data,
    });

    factory DashboardPressure.fromJson(Map<String, dynamic> json) => DashboardPressure(
        lowPressure: json["low_pressure"],
        highPressure: json["high_pressure"],
        data: json["data"] == null ? null : DateTime.parse(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "low_pressure": lowPressure,
        "high_pressure": highPressure,
        "data": data?.toIso8601String(),
    };
}