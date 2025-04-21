import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ovoride_driver/core/helper/shared_preference_helper.dart';
import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/core/route/route.dart';
import 'package:ovoride_driver/core/utils/method.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/data/model/authorization/authorization_response_model.dart';
import 'package:ovoride_driver/data/model/country_model/country_model.dart';
import 'package:ovoride_driver/data/model/general_setting/general_setting_response_model.dart';
import 'package:ovoride_driver/data/model/global/response_model/response_model.dart';
import 'package:ovoride_driver/data/model/global/response_model/unverified_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient extends GetxService {
  SharedPreferences sharedPreferences;
  ApiClient({required this.sharedPreferences});

  Future<ResponseModel> request(
    String uri,
    String method,
    Map<String, dynamic>? params, {
    bool passHeader = false,
    bool isOnlyAcceptType = false,
  }) async {
    Uri url = Uri.parse(uri);
    http.Response response;

    try {
      if (method == Method.postMethod) {
        if (passHeader) {
          initToken();
          if (isOnlyAcceptType) {
            response = await http.post(url, body: params, headers: {
              "Accept": "application/json",
              "dev-token":
                  "\$2y\$12\$mEVBW3QASB5HMBv8igls3ejh6zw2A0Xb480HWAmYq6BY9xEifyBjG",
            });
          } else {
            response = await http.post(url, body: params, headers: {
              "Accept": "application/json",
              "Authorization": "$tokenType $token",
              "dev-token":
                  "\$2y\$12\$mEVBW3QASB5HMBv8igls3ejh6zw2A0Xb480HWAmYq6BY9xEifyBjG",
            });
          }
        } else {
          response = await http.post(
            url,
            body: params,
            headers: {
              "dev-token":
                  "\$2y\$12\$mEVBW3QASB5HMBv8igls3ejh6zw2A0Xb480HWAmYq6BY9xEifyBjG",
            },
          );
        }
      } else if (method == Method.postMethod) {
        if (passHeader) {
          initToken();
          response = await http.post(url, body: params, headers: {
            "Accept": "application/json",
            "Authorization": "$tokenType $token",
            "dev-token":
                "\$2y\$12\$mEVBW3QASB5HMBv8igls3ejh6zw2A0Xb480HWAmYq6BY9xEifyBjG",
          });
        } else {
          response = await http.post(url, body: params, headers: {
            "dev-token":
                "\$2y\$12\$mEVBW3QASB5HMBv8igls3ejh6zw2A0Xb480HWAmYq6BY9xEifyBjG",
          });
        }
      } else if (method == Method.deleteMethod) {
        response = await http.delete(url);
      } else if (method == Method.updateMethod) {
        response = await http.patch(url);
      } else {
        if (passHeader) {
          initToken();
          response = await http.get(url, headers: {
            "Accept": "application/json",
            "Authorization": "$tokenType $token",
            "dev-token":
                "\$2y\$12\$mEVBW3QASB5HMBv8igls3ejh6zw2A0Xb480HWAmYq6BY9xEifyBjG",
          });
        } else {
          response = await http.get(
            url,
            headers: {
              "dev-token":
                  "\$2y\$12\$mEVBW3QASB5HMBv8igls3ejh6zw2A0Xb480HWAmYq6BY9xEifyBjG",
            },
          );
        }
      }

      printX('url--------------${uri.toString()}');
      printX('params-----------${params.toString()}');
      printX('status-----------${response.statusCode}');
      printX('body-------------${response.body.toString()}');
      printX('token------------$token');

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          Get.offAllNamed(RouteHelper.loginScreen);
        }
        try {
          AuthorizationResponseModel model =
              AuthorizationResponseModel.fromJson(jsonDecode(response.body));
          if (model.remark == 'profile_incomplete') {
            Get.toNamed(RouteHelper.profileCompleteScreen);
          } else if (model.remark == 'vehicle_verification' ||
              model.remark == 'vehicle_verification_pending') {
            Get.offAndToNamed(RouteHelper.vehicleVerificationScreen);
          } else if (model.remark == 'unverified') {
            UnVarifiedUserResponseModel model =
                UnVarifiedUserResponseModel.fromJson(jsonDecode(response.body));
            checkAndGotoUnveriedScreen(model);
          } else if (model.remark == 'unauthenticated') {
            sharedPreferences.setBool(
                SharedPreferenceHelper.rememberMeKey, false);
            sharedPreferences.remove(SharedPreferenceHelper.token);
            Get.offAllNamed(RouteHelper.loginScreen);
          } else if (model.remark == 'document_unverified' ||
              model.remark == 'document_verification_pending') {
            Get.toNamed(RouteHelper.driverProfileVerificationScreen);
          } else if (model.remark == 'vehicle_unverified') {
            Get.toNamed(RouteHelper.vehicleVerificationScreen);
          }
        } catch (e) {
          e.toString();
        }
        return ResponseModel(true, 'Success', 200, response.body);
      } else if (response.statusCode == 401) {
        sharedPreferences.setBool(SharedPreferenceHelper.rememberMeKey, false);
        Get.offAllNamed(RouteHelper.loginScreen);
        return ResponseModel(
            false, MyStrings.unAuthorized.tr, 401, response.body);
      } else if (response.statusCode == 500) {
        return ResponseModel(
            false, MyStrings.serverError.tr, 500, response.body);
      } else {
        return ResponseModel(
            false, MyStrings.somethingWentWrong.tr, 499, response.body);
      }
    } on SocketException {
      return ResponseModel(false, MyStrings.noInternet.tr, 503, '');
    } on FormatException {
      return ResponseModel(false, MyStrings.badResponseMsg.tr, 400, '');
    } catch (e) {
      printX(e);
      return ResponseModel(false, MyStrings.somethingWentWrong.tr, 499, '');
    }
  }

  checkAndGotoUnveriedScreen(UnVarifiedUserResponseModel model) {
    var data = model.data;
    bool needSmsVerification = data?.mobileVerified == "0" ? true : false;
    bool needEmailVerification = data?.emailVerified == "0" ? true : false;
    if (needEmailVerification) {
      sharedPreferences.setBool(SharedPreferenceHelper.rememberMeKey, false);
      Get.offAllNamed(RouteHelper.emailVerificationScreen, arguments: [
        needSmsVerification,
        false,
        false,
      ]);
    } else if (needSmsVerification) {
      sharedPreferences.setBool(SharedPreferenceHelper.rememberMeKey, false);
      Get.offAllNamed(RouteHelper.smsVerificationScreen,
          arguments: [false, false]);
    } else {
      sharedPreferences.setBool(SharedPreferenceHelper.rememberMeKey, false);
      sharedPreferences.remove(SharedPreferenceHelper.token);
      Get.offAllNamed(RouteHelper.loginScreen);
    }
  }

  String token = '';
  String tokenType = '';

  initToken() {
    if (sharedPreferences.containsKey(SharedPreferenceHelper.accessTokenKey)) {
      String? t =
          sharedPreferences.getString(SharedPreferenceHelper.accessTokenKey);
      String? tType =
          sharedPreferences.getString(SharedPreferenceHelper.accessTokenType);
      token = t ?? '';
      tokenType = tType ?? 'Bearer';
    } else {
      token = '';
      tokenType = 'Bearer';
    }
  }

  storeGeneralSetting(GeneralSettingResponseModel model) {
    String json = jsonEncode(model.toJson());
    sharedPreferences.setString(SharedPreferenceHelper.generalSettingKey, json);
    getGSData();
  }

  GeneralSettingResponseModel getGSData() {
    String pre =
        sharedPreferences.getString(SharedPreferenceHelper.generalSettingKey) ??
            '';
    GeneralSettingResponseModel model =
        GeneralSettingResponseModel.fromJson(jsonDecode(pre));
    return model;
  }

  storeNotificationAudio(String notificationAudioPath) {
    sharedPreferences.setString(
        SharedPreferenceHelper.notificationAudioKey, notificationAudioPath);
  }

  String getNotificationAudio() {
    String pre = sharedPreferences
            .getString(SharedPreferenceHelper.notificationAudioKey) ??
        '';
    return pre;
  }

  bool isReferEnable() {
    sharedPreferences.getString(SharedPreferenceHelper.generalSettingKey) ?? '';
    return false;
  }

  bool isNotificationAudioEnable() {
    String pre = sharedPreferences
            .getString(SharedPreferenceHelper.notificationAudioEnableKey) ??
        '';
    return pre == '1' ? true : false;
  }

  storeNotificationAudioEnable(bool isEnable) {
    sharedPreferences.setString(
        SharedPreferenceHelper.notificationAudioEnableKey,
        isEnable ? '1' : '0');
  }

  String getCurrencyOrUsername(
      {bool isCurrency = true, bool isSymbol = false}) {
    if (isCurrency) {
      String pre = sharedPreferences
              .getString(SharedPreferenceHelper.generalSettingKey) ??
          '';
      GeneralSettingResponseModel model =
          GeneralSettingResponseModel.fromJson(jsonDecode(pre));
      String currency = isSymbol
          ? model.data?.generalSetting?.curSym ?? ''
          : model.data?.generalSetting?.curText ?? '';
      return currency;
    } else {
      String username =
          sharedPreferences.getString(SharedPreferenceHelper.userNameKey) ?? '';
      return username;
    }
  }

  List<Countries> getOperatingCountry() {
    String pre =
        sharedPreferences.getString(SharedPreferenceHelper.generalSettingKey) ??
            '';
    GeneralSettingResponseModel model =
        GeneralSettingResponseModel.fromJson(jsonDecode(pre));
    List<Countries> country =
        model.data?.generalSetting?.operatingCountry ?? [];
    return country;
  }

  String getUserEmail() {
    String email =
        sharedPreferences.getString(SharedPreferenceHelper.userEmailKey) ?? '';
    return email;
  }

  String getUserPhone() {
    String phone = sharedPreferences
            .getString(SharedPreferenceHelper.userPhoneNumberKey) ??
        '';
    return phone;
  }

  bool getPasswordStrengthStatus() {
    String pre =
        sharedPreferences.getString(SharedPreferenceHelper.generalSettingKey) ??
            '';
    GeneralSettingResponseModel model =
        GeneralSettingResponseModel.fromJson(jsonDecode(pre));
    bool checkPasswordStrength =
        model.data?.generalSetting?.securePassword.toString() == '0'
            ? false
            : true;
    return checkPasswordStrength;
  }

  storePushSetting(PusherConfig pusherConfig) {
    String json = jsonEncode(pusherConfig.toJson());
    sharedPreferences.setString(
        SharedPreferenceHelper.pusherConfigSettingKey, json);
    getGSData();
  }

  String getTemplateName() {
    String pre =
        sharedPreferences.getString(SharedPreferenceHelper.generalSettingKey) ??
            '';
    GeneralSettingResponseModel model =
        GeneralSettingResponseModel.fromJson(jsonDecode(pre));
    String templateName = model.data?.generalSetting?.activeTemplate ?? '';
    return templateName;
  }

  String getReferAmount() {
    String pre =
        sharedPreferences.getString(SharedPreferenceHelper.generalSettingKey) ??
            '';
    GeneralSettingResponseModel.fromJson(jsonDecode(pre));
    return "referAmount";
  }

  bool isGoogleLoginEnable() {
    String pre =
        sharedPreferences.getString(SharedPreferenceHelper.generalSettingKey) ??
            '';
    GeneralSettingResponseModel model =
        GeneralSettingResponseModel.fromJson(jsonDecode(pre));
    bool enable = model.data?.generalSetting?.googleLogin == '1' ? true : false;
    return enable;
  }

  bool isAppleLoginEnable() {
    String pre =
        sharedPreferences.getString(SharedPreferenceHelper.generalSettingKey) ??
            '';
    GeneralSettingResponseModel model =
        GeneralSettingResponseModel.fromJson(jsonDecode(pre));
    bool enable = model.data?.generalSetting?.appleLogin == '1' ? true : false;
    return enable;
  }

  PusherConfig getPushConfig() {
    String pre = sharedPreferences
            .getString(SharedPreferenceHelper.pusherConfigSettingKey) ??
        '';
    PusherConfig model = PusherConfig.fromJson(jsonDecode(pre));
    return model;
  }
}
