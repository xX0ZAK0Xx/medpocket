import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
    final bool? success;
    final String? message;
    final ProfileData? data;

    ProfileModel({
        this.success,
        this.message,
        this.data,
    });

    factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : ProfileData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
    };
}

class ProfileData {
    final int? id;
    final String? name;
    final String? email;
    final String? mobileNumber;
    final String? photo;
    final dynamic uniqueId;
    final DateTime? createdAt;
    final int? agencyId;
    final dynamic refId;
    final String? agencyName;
    final String? btocCommission;
    final String? agencyLogo;
    final int? roleId;
    final double? balance;
    final String? due;
    final List<Permission>? permission;

    ProfileData({
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
        this.balance,
        this.due,
        this.permission,
    });

    factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
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
        balance: json["balance"]?.toDouble(),
        due: json["due"],
        permission: json["permission"] == null ? [] : List<Permission>.from(json["permission"]!.map((x) => Permission.fromJson(x))),
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
        "balance": balance,
        "due": due,
        "permission": permission == null ? [] : List<dynamic>.from(permission!.map((x) => x.toJson())),
    };
}

class Permission {
    final int? id;
    final int? moduleId;
    final String? moduleName;
    final int? read;
    final int? write;
    final int? update;
    final int? delete;

    Permission({
        this.id,
        this.moduleId,
        this.moduleName,
        this.read,
        this.write,
        this.update,
        this.delete,
    });

    factory Permission.fromJson(Map<String, dynamic> json) => Permission(
        id: json["id"],
        moduleId: json["module_id"],
        moduleName: json["module_name"],
        read: json["read"],
        write: json["write"],
        update: json["update"],
        delete: json["delete"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "module_id": moduleId,
        "module_name": moduleName,
        "read": read,
        "write": write,
        "update": update,
        "delete": delete,
    };
}
