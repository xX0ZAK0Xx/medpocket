import 'dart:convert';

import '../model.dart';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
    final bool? success;
    final int? status;
    final String? message;
    final ProfileData? data;
    final Meta? meta;

    ProfileModel({
        this.success,
        this.status,
        this.message,
        this.data,
        this.meta,
    });

    factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        success: json["success"],
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : ProfileData.fromJson(json["data"]),
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

class ProfileData {
    final String? name;
    final String? phoneNumber;
    final String? email;
    final String? bloodGroup;
    final DateTime? dateOfBirth;
    final String? gender;

    ProfileData({
        this.name,
        this.phoneNumber,
        this.email,
        this.bloodGroup,
        this.dateOfBirth,
        this.gender,
    });

    factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        name: json["name"],
        phoneNumber: json["phone_number"],
        email: json["email"],
        bloodGroup: json["blood_group"],
        dateOfBirth: json["date_of_birth"] == null ? null : DateTime.parse(json["date_of_birth"]),
        gender: json["gender"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "phone_number": phoneNumber,
        "email": email,
        "blood_group": bloodGroup,
        "date_of_birth": dateOfBirth?.toIso8601String(),
        "gender": gender,
    };
}