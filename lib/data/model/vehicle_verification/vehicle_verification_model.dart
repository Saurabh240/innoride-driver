// To parse this JSON data, do
//
//     final kycResponseModel = kycResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:ovoride_driver/data/model/global/formdata/global_keyc_formData.dart';
import 'package:ovoride_driver/data/model/global/ride/app_service_model.dart';
import 'package:ovoride_driver/data/model/global/ride/ride_rulse_model.dart';
import 'package:ovoride_driver/data/model/kyc/kyc_pending_data_model.dart';

VehicleKycResponseModel kycResponseModelFromJson(String str) =>
    VehicleKycResponseModel.fromJson(json.decode(str));

class VehicleKycResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  VehicleKycResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory VehicleKycResponseModel.fromJson(Map<String, dynamic> json) =>
      VehicleKycResponseModel(
        remark: json["remark"],
        status: json["status"],
        message: json["message"] == null
            ? []
            : List<String>.from(json["message"]!.map((x) => x)),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  GlobalKYCForm? form;
  List<AppService>? services;
  List<Brand>? brands;
  List<RiderRule>? riderRules;
  //pending data
  List<KycPendingData>? vehicleData;
  AppService? selectedServices;
  Brand? selectedBrand;

  String? path;
  String? serviceImagePath;
  String? brandImagePath;

  Data(
      {this.form,
      this.services,
      this.brands,
      this.riderRules,
      this.vehicleData,
      this.selectedServices,
      this.selectedBrand,
      this.path,
      this.serviceImagePath,
      this.brandImagePath});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        form:
            json["form"] == null ? null : GlobalKYCForm.fromJson(json["form"]),
        services: json["services"] == null
            ? []
            : List<AppService>.from(
                json["services"]!.map((x) => AppService.fromJson(x))),
        brands: json["brands"] == null
            ? []
            : List<Brand>.from(json["brands"]!.map((x) => Brand.fromJson(x))),
        riderRules: json["rider_rules"] == null
            ? []
            : List<RiderRule>.from(
                json["rider_rules"]!.map((x) => RiderRule.fromJson(x))),
        selectedServices: json["service"] == null
            ? null
            : AppService.fromJson(json["service"]),
        selectedBrand:
            json["brand"] == null ? null : Brand.fromJson(json["brand"]),
        vehicleData: json["vehicle_data"] == null
            ? []
            : List<KycPendingData>.from(
                json["vehicle_data"]!.map((x) => KycPendingData.fromJson(x))),
        path: json["file_path"].toString(),
        serviceImagePath: json["service_image_path"].toString(),
        brandImagePath: json["brand_image_path"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "services": services == null
            ? []
            : List<dynamic>.from(services!.map((x) => x.toJson())),
        "brands": brands == null
            ? []
            : List<dynamic>.from(brands!.map((x) => x.toJson())),
        "rider_rules": riderRules == null
            ? []
            : List<dynamic>.from(riderRules!.map((x) => x.toJson())),
      };
}

class Brand {
  String? id;
  String? name;
  String? image;
  String? createdAt;
  String? updatedAt;
  String? imageWithPath;

  Brand({
    this.id,
    this.name,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.imageWithPath,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        id: json["id"].toString(),
        name: json["name"],
        image: json["image"],
        createdAt: json["created_at"]?.toString(),
        updatedAt: json["updated_at"]?.toString(),
        imageWithPath: json["image_with_path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "image_with_path": imageWithPath,
      };
}
