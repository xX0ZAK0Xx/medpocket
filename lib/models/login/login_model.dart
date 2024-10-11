import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
    final bool? success;
    final String? message;
    final Data? data;
    final String? token;

    LoginModel({
        this.success,
        this.message,
        this.data,
        this.token,
    });

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
        "token": token,
    };
}

class Data {
    final int? id;
    final String? name;
    final String? email;
    final String? mobileNumber;
    final String? photo;
    final String? uniqueId;
    final DateTime? createdAt;
    final int? agencyId;
    final dynamic refId;
    final String? agencyName;
    final String? btocCommission;
    final String? agencyLogo;
    final int? roleId;

    Data({
        this.id,
        this.name,
        this.email,
        this.mobileNumber,
        this.photo,
        this.uniqueId,
        this.createdAt,
        this.agencyId,
        this.refId,
        this.agencyName,
        this.btocCommission,
        this.agencyLogo,
        this.roleId,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        mobileNumber: json["mobile_number"],
        photo: json["photo"],
        uniqueId: json["unique_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        agencyId: json["agency_id"],
        refId: json["ref_id"],
        agencyName: json["agency_name"],
        btocCommission: json["btoc_commission"],
        agencyLogo: json["agency_logo"],
        roleId: json["role_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "mobile_number": mobileNumber,
        "photo": photo,
        "unique_id": uniqueId,
        "created_at": createdAt?.toIso8601String(),
        "agency_id": agencyId,
        "ref_id": refId,
        "agency_name": agencyName,
        "btoc_commission": btocCommission,
        "agency_logo": agencyLogo,
        "role_id": roleId,
    };
}
