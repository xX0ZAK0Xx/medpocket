import 'dart:convert';

import '../model.dart';

AllReportsOfFolderModel allReportsOfFolderModelFromJson(String str) => AllReportsOfFolderModel.fromJson(json.decode(str));

String allReportsOfFolderModelToJson(AllReportsOfFolderModel data) => json.encode(data.toJson());

class AllReportsOfFolderModel {
    final bool? success;
    final int? status;
    final String? message;
    final List<ReportOfFolderData>? data;
    final Meta? meta;

    AllReportsOfFolderModel({
        this.success,
        this.status,
        this.message,
        this.data,
        this.meta,
    });

    factory AllReportsOfFolderModel.fromJson(Map<String, dynamic> json) => AllReportsOfFolderModel(
        success: json["success"],
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<ReportOfFolderData>.from(json["data"]!.map((x) => ReportOfFolderData.fromJson(x))),
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

class ReportOfFolderData {
    final String? id;
    final String? userId;
    final String? folderId;
    final String? title;
    final String? description;
    final String? hospitalName;
    final List<String>? images;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final int? v;

    ReportOfFolderData({
        this.id,
        this.userId,
        this.folderId,
        this.title,
        this.description,
        this.hospitalName,
        this.images,
        this.createdAt,
        this.updatedAt,
        this.v,
    });

    factory ReportOfFolderData.fromJson(Map<String, dynamic> json) => ReportOfFolderData(
        id: json["_id"],
        userId: json["userId"],
        folderId: json["folderId"],
        title: json["title"],
        description: json["description"],
        hospitalName: json["hospitalName"],
        images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "folderId": folderId,
        "title": title,
        "description": description,
        "hospitalName": hospitalName,
        "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
    };
}