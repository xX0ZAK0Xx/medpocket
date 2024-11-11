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
    final double? averageBmi;
    final double? maxBmi;
    final double? minBmi;

    DashboardData({
        this.glucose,
        this.measurements,
        this.pressure,
        this.averageBmi,
        this.maxBmi,
        this.minBmi,
    });

    factory DashboardData.fromJson(Map<String, dynamic> json) => DashboardData(
        glucose: json["glucose"] == null ? null : DashboardGlucose.fromJson(json["glucose"]),
        measurements: json["measurements"] == null ? null : DashboardMeasurements.fromJson(json["measurements"]),
        pressure: json["pressure"] == null ? null : DashboardPressure.fromJson(json["pressure"]),
        averageBmi: json["averageBmi"]?.toDouble(),
        maxBmi: json["maxBmi"]?.toDouble(),
        minBmi: json["minBmi"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "glucose": glucose?.toJson(),
        "measurements": measurements?.toJson(),
        "pressure": pressure?.toJson(),
        "averageBmi": averageBmi,
        "maxBmi": maxBmi,
        "minBmi": minBmi,
    };
}

class DashboardGlucose {
    final double? glucose;
    final List<TodayGlucose>? todayGlucose;
    final DateTime? date;

    DashboardGlucose({
        this.glucose,
        this.todayGlucose,
        this.date,
    });

    factory DashboardGlucose.fromJson(Map<String, dynamic> json) => DashboardGlucose(
        glucose: json["glucose"]?.toDouble(),
        todayGlucose: json["todayGlucose"] == null ? [] : List<TodayGlucose>.from(json["todayGlucose"]!.map((x) => TodayGlucose.fromJson(x))),
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
    );

    Map<String, dynamic> toJson() => {
        "glucose": glucose,
        "todayGlucose": todayGlucose == null ? [] : List<dynamic>.from(todayGlucose!.map((x) => x.toJson())),
        "date": date?.toIso8601String(),
    };
}

class TodayGlucose {
    final String? id;
    final String? userId;
    final double? glucose;
    final DateTime? date;
    final int? v;

    TodayGlucose({
        this.id,
        this.userId,
        this.glucose,
        this.date,
        this.v,
    });

    factory TodayGlucose.fromJson(Map<String, dynamic> json) => TodayGlucose(
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
    final List<TodayPressure>? todayPressure;
    final DateTime? data;

    DashboardPressure({
        this.lowPressure,
        this.highPressure,
        this.todayPressure,
        this.data,
    });

    factory DashboardPressure.fromJson(Map<String, dynamic> json) => DashboardPressure(
        lowPressure: json["low_pressure"],
        highPressure: json["high_pressure"],
        todayPressure: json["todayPressure"] == null ? [] : List<TodayPressure>.from(json["todayPressure"]!.map((x) => TodayPressure.fromJson(x))),
        data: json["data"] == null ? null : DateTime.parse(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "low_pressure": lowPressure,
        "high_pressure": highPressure,
        "todayPressure": todayPressure == null ? [] : List<dynamic>.from(todayPressure!.map((x) => x.toJson())),
        "data": data?.toIso8601String(),
    };
}

class TodayPressure {
    final String? id;
    final String? userId;
    final int? highPressure;
    final int? lowPressure;
    final DateTime? date;
    final int? v;

    TodayPressure({
        this.id,
        this.userId,
        this.highPressure,
        this.lowPressure,
        this.date,
        this.v,
    });

    factory TodayPressure.fromJson(Map<String, dynamic> json) => TodayPressure(
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