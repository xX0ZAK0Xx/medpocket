import 'dart:convert';

import '../model.dart';

AuthModel authModelFromJson(String str) => AuthModel.fromJson(json.decode(str));

String loginModelToJson(AuthModel data) => json.encode(data.toJson());

class AuthModel {
    final bool? success;
    final int? status;
    final String? message;
    final Data? data;
    final Meta? meta;

    AuthModel({
        this.success,
        this.status,
        this.message,
        this.data,
        this.meta,
    });

    factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
        success: json["success"],
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
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

class Data {
    final String? id;
    final String? name;
    final String? email;

    Data({
        this.id,
        this.name,
        this.email,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
    };
}