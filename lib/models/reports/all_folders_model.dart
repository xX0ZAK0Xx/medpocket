import 'dart:convert';

import '../model.dart';

AllFoldersListModel allFoldersListModelFromJson(String str) => AllFoldersListModel.fromJson(json.decode(str));

String allFoldersListModelToJson(AllFoldersListModel data) => json.encode(data.toJson());

class AllFoldersListModel {
    final bool? success;
    final int? status;
    final String? message;
    final List<FolderData>? data;
    final Meta? meta;

    AllFoldersListModel({
        this.success,
        this.status,
        this.message,
        this.data,
        this.meta,
    });

    factory AllFoldersListModel.fromJson(Map<String, dynamic> json) => AllFoldersListModel(
        success: json["success"],
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<FolderData>.from(json["data"]!.map((x) => FolderData.fromJson(x))),
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

class FolderData {
    final String? id;
    final String? name;
    final DateTime? createdAt;

    FolderData({
        this.id,
        this.name,
        this.createdAt,
    });

    factory FolderData.fromJson(Map<String, dynamic> json) => FolderData(
        id: json["_id"],
        name: json["name"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "createdAt": createdAt?.toIso8601String(),
    };
}