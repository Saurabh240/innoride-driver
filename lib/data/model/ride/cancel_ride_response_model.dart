import 'dart:convert';

import 'package:ovoride_driver/data/model/global/ride/ride_model.dart';

CancelRideListResponseModel cancelRideListResponseModelFromJson(String str) =>
    CancelRideListResponseModel.fromJson(json.decode(str));

class CancelRideListResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  CancelRideListResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory CancelRideListResponseModel.fromJson(Map<String, dynamic> json) =>
      CancelRideListResponseModel(
        remark: json["remark"],
        status: json["status"],
        message: json["message"] == null
            ? []
            : List<String>.from(json["message"]!.map((x) => x)),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  CancelRideData? cancelRides;

  Data({
    this.cancelRides,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        cancelRides: json["rides"] == null
            ? null
            : CancelRideData.fromJson(json["rides"]),
      );

  Map<String, dynamic> toJson() => {
        "cancel_rides": cancelRides?.toJson(),
      };
}

class CancelRideData {
  List<RideModel>? data;
  dynamic nextPageUrl;

  CancelRideData({
    this.data,
    this.nextPageUrl,
  });

  factory CancelRideData.fromJson(Map<String, dynamic> json) => CancelRideData(
        data: json["data"] == null
            ? []
            : List<RideModel>.from(
                json["data"]!.map((x) => RideModel.fromJson(x))),
        nextPageUrl: json["next_page_url"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
      };
}
