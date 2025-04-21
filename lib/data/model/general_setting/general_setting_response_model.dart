import 'dart:convert';

import 'package:ovoride_driver/data/model/country_model/country_model.dart';

GeneralSettingResponseModel generalSettingResponseModelFromJson(String str) =>
    GeneralSettingResponseModel.fromJson(json.decode(str));

String generalSettingResponseModelToJson(GeneralSettingResponseModel data) =>
    json.encode(data.toJson());

class GeneralSettingResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  GeneralSettingResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory GeneralSettingResponseModel.fromJson(Map<String, dynamic> json) =>
      GeneralSettingResponseModel(
        remark: json["remark"],
        status: json["status"],
        message: json["message"] == null
            ? []
            : List<String>.from(json["message"]!.map((x) => x)),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "remark": remark,
        "status": status,
        "message":
            message == null ? [] : List<dynamic>.from(message!.map((x) => x)),
        "data": data?.toJson(),
      };
}

class Data {
  GeneralSetting? generalSetting;
  String? notificationAudioPath;
  String? socialLoginRedirect;

  Data({
    this.generalSetting,
    this.socialLoginRedirect,
    this.notificationAudioPath,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        generalSetting: json["general_setting"] == null
            ? null
            : GeneralSetting.fromJson(json["general_setting"]),
        socialLoginRedirect: json["social_login_redirect"],
        notificationAudioPath: json["notification_audio_path"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "general_setting": generalSetting?.toJson(),
        "social_login_redirect": socialLoginRedirect,
        "notification_audio_path": notificationAudioPath,
      };
}

class GeneralSetting {
  int? id;
  String? siteName;
  String? curText;
  String? curSym;
  String? emailFrom;
  String? emailFromName;
  String? smsTemplate;
  String? smsFrom;
  String? pushTitle;
  String? pushTemplate;
  String? baseColor;
  String? secondaryColor;
  FirebaseConfig? firebaseConfig;
  GlobalShortcodes? globalShortcodes;
  String? kv;
  String? ev;
  String? en;
  String? sv;
  String? sn;
  String? pn;
  String? forceSsl;
  String? inAppPayment;
  String? maintenanceMode;
  String? securePassword;
  String? agree;
  String? multiLanguage;
  String? registration;
  String? activeTemplate;
  SocialiteCredentials? socialiteCredentials;
  String? lastCron;
  String? availableVersion;
  int? systemCustomized;
  int? paginateNumber;
  int? currencyFormat;
  String? timeFormat;
  String? dateFormat;
  int? allowPrecision;
  String? thousandSeparator;
  String? googleMapsApi;
  String? centerLat;
  String? centerLong;
  String? googleLogin;
  String? appleLogin;
  double? minDistance;
  PusherConfig? pusherConfig;
  int? userCancellationLimit;
  int? driverRegistration;
  dynamic createdAt;
  String? updatedAt;
  List<Countries>? operatingCountry;
  String? notificationAudio;

  GeneralSetting({
    this.id,
    this.siteName,
    this.curText,
    this.curSym,
    this.emailFrom,
    this.emailFromName,
    this.smsTemplate,
    this.smsFrom,
    this.pushTitle,
    this.pushTemplate,
    this.baseColor,
    this.secondaryColor,
    this.firebaseConfig,
    this.globalShortcodes,
    this.kv,
    this.ev,
    this.en,
    this.sv,
    this.sn,
    this.pn,
    this.forceSsl,
    this.inAppPayment,
    this.maintenanceMode,
    this.securePassword,
    this.agree,
    this.multiLanguage,
    this.registration,
    this.activeTemplate,
    this.socialiteCredentials,
    this.lastCron,
    this.availableVersion,
    this.systemCustomized,
    this.paginateNumber,
    this.currencyFormat,
    this.timeFormat,
    this.dateFormat,
    this.allowPrecision,
    this.thousandSeparator,
    this.googleMapsApi,
    this.centerLat,
    this.centerLong,
    this.minDistance,
    this.googleLogin,
    this.appleLogin,
    this.pusherConfig,
    this.userCancellationLimit,
    this.driverRegistration,
    this.createdAt,
    this.updatedAt,
    this.operatingCountry,
    this.notificationAudio,
  });

  factory GeneralSetting.fromJson(Map<String, dynamic> json) => GeneralSetting(
        id: json["id"],
        siteName: json["site_name"],
        curText: json["cur_text"],
        curSym: json["cur_sym"],
        emailFrom: json["email_from"],
        emailFromName: json["email_from_name"],
        smsTemplate: json["sms_template"],
        smsFrom: json["sms_from"],
        pushTitle: json["push_title"],
        pushTemplate: json["push_template"],
        baseColor: json["base_color"],
        secondaryColor: json["secondary_color"],
        firebaseConfig: json["firebase_config"] == null
            ? null
            : FirebaseConfig.fromJson(json["firebase_config"]),
        globalShortcodes: json["global_shortcodes"] == null
            ? null
            : GlobalShortcodes.fromJson(json["global_shortcodes"]),
        kv: json["kv"].toString(),
        ev: json["ev"].toString(),
        en: json["en"].toString(),
        sv: json["sv"].toString(),
        sn: json["sn"].toString(),
        pn: json["pn"].toString(),
        forceSsl: json["force_ssl"].toString(),
        inAppPayment: json["in_app_payment"].toString(),
        maintenanceMode: json["maintenance_mode"].toString(),
        securePassword: json["secure_password"].toString(),
        agree: json["agree"].toString(),
        multiLanguage: json["multi_language"].toString(),
        registration: json["registration"].toString(),
        activeTemplate: json["active_template"].toString(),
        socialiteCredentials: json["socialite_credentials"] == null
            ? null
            : SocialiteCredentials.fromJson(json["socialite_credentials"]),
        lastCron: json["last_cron"].toString(),
        availableVersion: json["available_version"].toString(),
        systemCustomized: json["system_customized"],
        paginateNumber: json["paginate_number"],
        currencyFormat: json["currency_format"],
        timeFormat: json["time_format"],
        dateFormat: json["date_format"],
        allowPrecision: json["allow_precision"],
        thousandSeparator: json["thousand_separator"],
        googleMapsApi: json["google_maps_api"],
        centerLat: json["center_lat"],
        centerLong: json["center_long"],
        googleLogin: json["google_login"].toString(),
        appleLogin: json["apple_login"].toString(),
        minDistance: json["min_distance"]?.toDouble(),
        pusherConfig: json["pusher_config"] == null
            ? null
            : PusherConfig.fromJson(json["pusher_config"]),
        userCancellationLimit: json["user_cancellation_limit"],
        driverRegistration: json["driver_registration"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        operatingCountry: json["operating_country"] == null
            ? []
            : List<Countries>.from(
                json["operating_country"]!.map((x) => Countries.fromJson(x))),
        notificationAudio: json["notification_audio"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "site_name": siteName,
        "cur_text": curText,
        "cur_sym": curSym,
        "email_from": emailFrom,
        "email_from_name": emailFromName,
        "sms_template": smsTemplate,
        "sms_from": smsFrom,
        "push_title": pushTitle,
        "push_template": pushTemplate,
        "base_color": baseColor,
        "secondary_color": secondaryColor,
        "firebase_config": firebaseConfig?.toJson(),
        "global_shortcodes": globalShortcodes?.toJson(),
        "kv": kv,
        "ev": ev,
        "en": en,
        "sv": sv,
        "sn": sn,
        "pn": pn,
        "force_ssl": forceSsl,
        "in_app_payment": inAppPayment,
        "maintenance_mode": maintenanceMode,
        "secure_password": securePassword,
        "agree": agree,
        "multi_language": multiLanguage,
        "registration": registration,
        "active_template": activeTemplate,
        "socialite_credentials": socialiteCredentials?.toJson(),
        "last_cron": lastCron,
        "available_version": availableVersion,
        "system_customized": systemCustomized,
        "paginate_number": paginateNumber,
        "currency_format": currencyFormat,
        "time_format": timeFormat,
        "date_format": dateFormat,
        "allow_precision": allowPrecision,
        "thousand_separator": thousandSeparator,
        "google_maps_api": googleMapsApi,
        "center_lat": centerLat,
        "center_long": centerLong,
        "google_login": googleLogin,
        "apple_login": appleLogin,
        "min_distance": minDistance,
        "pusher_config": pusherConfig?.toJson(),
        "user_cancellation_limit": userCancellationLimit,
        "driver_registration": driverRegistration,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "operating_country": operatingCountry?.map((x) => x.toJson()).toList(),
        "notification_audio": notificationAudio,
      };
}

class FirebaseConfig {
  String? apiKey;
  String? authDomain;
  String? projectId;
  String? storageBucket;
  String? messagingSenderId;
  String? appId;
  String? measurementId;

  FirebaseConfig({
    this.apiKey,
    this.authDomain,
    this.projectId,
    this.storageBucket,
    this.messagingSenderId,
    this.appId,
    this.measurementId,
  });

  factory FirebaseConfig.fromJson(Map<String, dynamic> json) => FirebaseConfig(
        apiKey: json["apiKey"],
        authDomain: json["authDomain"],
        projectId: json["projectId"],
        storageBucket: json["storageBucket"],
        messagingSenderId: json["messagingSenderId"],
        appId: json["appId"],
        measurementId: json["measurementId"],
      );

  Map<String, dynamic> toJson() => {
        "apiKey": apiKey,
        "authDomain": authDomain,
        "projectId": projectId,
        "storageBucket": storageBucket,
        "messagingSenderId": messagingSenderId,
        "appId": appId,
        "measurementId": measurementId,
      };
}

class GlobalShortcodes {
  String? siteName;
  String? siteCurrency;
  String? currencySymbol;

  GlobalShortcodes({
    this.siteName,
    this.siteCurrency,
    this.currencySymbol,
  });

  factory GlobalShortcodes.fromJson(Map<String, dynamic> json) =>
      GlobalShortcodes(
        siteName: json["site_name"],
        siteCurrency: json["site_currency"],
        currencySymbol: json["currency_symbol"],
      );

  Map<String, dynamic> toJson() => {
        "site_name": siteName,
        "site_currency": siteCurrency,
        "currency_symbol": currencySymbol,
      };
}

class PusherConfig {
  String? appKey;
  String? appId;
  String? appSecret;
  String? cluster;

  PusherConfig({
    this.appKey,
    this.appId,
    this.appSecret,
    this.cluster,
  });

  factory PusherConfig.fromJson(Map<String, dynamic> json) => PusherConfig(
        appKey: json["app_key"],
        appId: json["app_id"],
        appSecret: json["app_secret"],
        cluster: json["cluster"],
      );

  Map<String, dynamic> toJson() => {
        "app_key": appKey,
        "app_id": appId,
        "app_secret": appSecret,
        "cluster": cluster,
      };
}

class SocialiteCredentials {
  Facebook? google;
  Facebook? facebook;
  Facebook? linkedin;

  SocialiteCredentials({
    this.google,
    this.facebook,
    this.linkedin,
  });

  factory SocialiteCredentials.fromJson(Map<String, dynamic> json) =>
      SocialiteCredentials(
        google:
            json["google"] == null ? null : Facebook.fromJson(json["google"]),
        facebook: json["facebook"] == null
            ? null
            : Facebook.fromJson(json["facebook"]),
        linkedin: json["linkedin"] == null
            ? null
            : Facebook.fromJson(json["linkedin"]),
      );

  Map<String, dynamic> toJson() => {
        "google": google?.toJson(),
        "facebook": facebook?.toJson(),
        "linkedin": linkedin?.toJson(),
      };
}

class Facebook {
  String? clientId;
  String? clientSecret;
  String? status;
  String? info;

  Facebook({
    this.clientId,
    this.clientSecret,
    this.status,
    this.info,
  });

  factory Facebook.fromJson(Map<String, dynamic> json) => Facebook(
        clientId: json["client_id"].toString(),
        clientSecret: json["client_secret"].toString(),
        status: json["status"].toString(),
        info: json["info"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "client_id": clientId,
        "client_secret": clientSecret,
        "status": status,
        "info": info,
      };
}
