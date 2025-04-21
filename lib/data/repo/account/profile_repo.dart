import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ovoride_driver/core/helper/shared_preference_helper.dart';
import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/core/utils/method.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/core/utils/url_container.dart';
import 'package:ovoride_driver/data/model/authorization/authorization_response_model.dart';
import 'package:ovoride_driver/data/model/global/response_model/response_model.dart';
import 'package:ovoride_driver/data/model/profile/profile_response_model.dart';
import 'package:ovoride_driver/data/services/api_service.dart';
import 'package:ovoride_driver/presentation/components/snack_bar/show_custom_snackbar.dart';

import '../../model/profile/profile_post_model.dart';
import '../../model/profile_complete/profile_complete_post_model.dart';

class ProfileRepo {
  ApiClient apiClient;

  ProfileRepo({required this.apiClient});

  Future<bool> updateProfile(ProfilePostModel model, bool isProfile) async {
    try {
      apiClient.initToken();

      String url =
          '${UrlContainer.baseUrl}${isProfile ? UrlContainer.updateProfileEndPoint : UrlContainer.profileCompleteEndPoint}';

      var request = http.MultipartRequest('POST', Uri.parse(url));

      Map<String, String> finalMap = {
        'firstname': model.firstname,
        'lastname': model.lastName,
        'address': model.address ?? '',
        'zip': model.zip ?? '',
        'state': model.state ?? "",
        'city': model.city ?? '',
      };
      printX(finalMap);

      request.headers.addAll(<String, String>{
        'Authorization': 'Bearer ${apiClient.token}',
        "dev-token":
            "\$2y\$12\$mEVBW3QASB5HMBv8igls3ejh6zw2A0Xb480HWAmYq6BY9xEifyBjG",
      });

      if (model.image != null) {
        request.files.add(http.MultipartFile('image',
            model.image!.readAsBytes().asStream(), model.image!.lengthSync(),
            filename: model.image!.path.split('/').last));
      }

      request.fields.addAll(finalMap);

      http.StreamedResponse response = await request.send();

      String jsonResponse = await response.stream.bytesToString();

      AuthorizationResponseModel authorizationResponseModel =
          AuthorizationResponseModel.fromJson(jsonDecode(jsonResponse));

      if (authorizationResponseModel.status?.toLowerCase() ==
          MyStrings.success.toLowerCase()) {
        CustomSnackBar.success(
            successList:
                authorizationResponseModel.message ?? [MyStrings.success]);
        return true;
      } else {
        CustomSnackBar.error(
            errorList: authorizationResponseModel.message ??
                [MyStrings.requestFail.tr]);
        return false;
      }
    } catch (e) {
      printX(e.toString());

      return false;
    }
  }

  Future<ResponseModel> completeProfile(ProfileCompletePostModel model) async {
    dynamic params = model.toMap();
    String url =
        '${UrlContainer.baseUrl}${UrlContainer.profileCompleteEndPoint}';
    ResponseModel responseModel = await apiClient
        .request(url, Method.postMethod, params, passHeader: true);
    return responseModel;
  }

  Future<dynamic> deleteAccount() async {
    try {
      String url = '${UrlContainer.baseUrl}${UrlContainer.userDeleteEndPoint}';
      ResponseModel response = await apiClient
          .request(url, Method.postMethod, null, passHeader: true);
      return response;
    } catch (e) {
      return ResponseModel(false, MyStrings.somethingWentWrong.tr, 300, '');
    }
  }

  Future<ProfileResponseModel> loadProfileInfo() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.getProfileEndPoint}';

    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);

    if (responseModel.statusCode == 200) {
      ProfileResponseModel model =
          ProfileResponseModel.fromJson(jsonDecode(responseModel.responseJson));
      if (model.status == 'success') {
        return model;
      } else {
        return ProfileResponseModel();
      }
    } else {
      return ProfileResponseModel();
    }
  }

  Future<dynamic> getCountryList() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.countryEndPoint}';
    ResponseModel model = await apiClient.request(url, Method.getMethod, null);
    return model;
  }

  Future<dynamic> getZoneList(String page) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.zones}?page=$page';
    ResponseModel model = await apiClient.request(url, Method.getMethod, null);
    return model;
  }

  Future<ResponseModel> logout() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.logoutUrl}';

    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    await clearSharedPrefData();
    return responseModel;
  }

  Future<void> clearSharedPrefData() async {
    await apiClient.sharedPreferences
        .setString(SharedPreferenceHelper.userNameKey, '');
    await apiClient.sharedPreferences
        .setString(SharedPreferenceHelper.userEmailKey, '');
    await apiClient.sharedPreferences
        .setString(SharedPreferenceHelper.accessTokenType, '');
    await apiClient.sharedPreferences
        .setString(SharedPreferenceHelper.accessTokenKey, '');
    await apiClient.sharedPreferences
        .setBool(SharedPreferenceHelper.rememberMeKey, false);
    return Future.value();
  }
}
