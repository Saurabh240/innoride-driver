import 'dart:convert';

import 'package:ovoride_driver/data/model/global/user/global_driver_model.dart';

ReferenceResponseModel referenceResponseModelFromJson(String str) =>
    ReferenceResponseModel.fromJson(json.decode(str));

class ReferenceResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  ReferenceResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory ReferenceResponseModel.fromJson(Map<String, dynamic> json) =>
      ReferenceResponseModel(
        remark: json["remark"],
        status: json["status"],
        message: json["message"] == null
            ? []
            : List<String>.from(json["message"]!.map((x) => x)),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  GlobalDriverInfo? user;
  List<ReferenceUser>? referenceUsers;

  Data({
    this.user,
    this.referenceUsers,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: json["driver"] == null
            ? null
            : GlobalDriverInfo.fromJson(json["driver"]),
        referenceUsers: json["reference_drivers"] == null
            ? []
            : List<ReferenceUser>.from(json["reference_drivers"]!
                .map((x) => ReferenceUser.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "reference_drivers": referenceUsers == null
            ? []
            : List<dynamic>.from(referenceUsers!.map((x) => x.toJson())),
      };
}

class ReferenceUser {
  String? username;
  String? email;
  String? firstname;
  String? lastname;
  String? imageWithPath;

  ReferenceUser({
    this.username,
    this.email,
    this.firstname,
    this.lastname,
    this.imageWithPath,
  });

  factory ReferenceUser.fromJson(Map<String, dynamic> json) => ReferenceUser(
        username: json["username"],
        email: json["email"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        imageWithPath: json["image_with_path"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "firstname": firstname,
        "lastname": lastname,
        "image_with_path": imageWithPath,
      };
}
