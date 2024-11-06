import 'dart:convert';

import '../model.dart';

AuthModel authModelFromJson(String str) => AuthModel.fromJson(json.decode(str));

String loginModelToJson(AuthModel data) => json.encode(data.toJson());

class AuthModel {
    final bool? success;
    final int? status;
    final String? message;
    final AuthData? data;
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
        data: json["data"] == null ? null : AuthData.fromJson(json["data"]),
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

class AuthData {
    final String? id;
    final String? name;
    final String? email;
    final bool? allSetup;

    AuthData({
        this.id,
        this.allSetup,
        this.name,
        this.email,
    });

    factory AuthData.fromJson(Map<String, dynamic> json) => AuthData(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        allSetup: json["all_setup"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "all_setup": allSetup,
    };
}