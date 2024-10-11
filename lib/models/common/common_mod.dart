import 'dart:convert';

ResponseModel responseModelFromJson(String str) => ResponseModel.fromJson(json.decode(str));

String responseModelToJson(ResponseModel data) => json.encode(data.toJson());

class ResponseModel {
  final bool? success;
  final String? message;
  final String? title;
  final String? token;

  ResponseModel({
    this.success,
    this.message,
    this.title,
    this.token,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
    success: json["success"],
    message: json["message"],
    title: json["title"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "title": title,
    "token": token
  };
}
