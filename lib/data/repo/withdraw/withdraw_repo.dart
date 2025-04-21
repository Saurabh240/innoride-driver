import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ovoride_driver/core/utils/method.dart' as request;
import 'package:ovoride_driver/data/model/global/formdata/global_keyc_formData.dart';

import '../../../core/utils/my_strings.dart';
import '../../../core/utils/url_container.dart';
import '../../../presentation/components/snack_bar/show_custom_snackbar.dart';
import '../../model/authorization/authorization_response_model.dart';
import '../../model/global/response_model/response_model.dart';
import '../../model/withdraw/withdraw_history_response_model.dart';
import '../../services/api_service.dart';
import '../driver_profile_verification/driver_kyc_repo.dart';

class WithdrawRepo {
  ApiClient apiClient;
  WithdrawRepo({required this.apiClient});

  Future<dynamic> getAllWithdrawMethod() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.withdrawMethodUrl}';

    ResponseModel responseModel = await apiClient
        .request(url, request.Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<dynamic> getWithdrawConfirmScreenData(String trxId) async {
    String url =
        '${UrlContainer.baseUrl}${UrlContainer.withdrawConfirmScreenUrl}$trxId';

    ResponseModel responseModel = await apiClient
        .request(url, request.Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<dynamic> addWithdrawRequest(
      int methodCode, double amount, String? authMode) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.addWithdrawRequestUrl}';
    Map<String, dynamic> params = {
      'method_code': methodCode.toString(),
      'amount': amount.toString()
    };

    if (authMode != null &&
        authMode.isNotEmpty &&
        authMode.toLowerCase() != MyStrings.selectOne.toLowerCase()) {
      params['auth_mode'] = authMode.toLowerCase();
    }

    ResponseModel responseModel = await apiClient
        .request(url, request.Method.postMethod, params, passHeader: true);
    return responseModel;
  }

  List<Map<String, String>> fieldList = [];
  List<ModelDynamicValue> filesList = [];

  Future<dynamic> confirmWithdrawRequest(
      String trx, List<GlobalFormModel> list, String twoFactorCode) async {
    String url =
        '${UrlContainer.baseUrl}${UrlContainer.withdrawRequestConfirm}';

    apiClient.initToken();
    await modelToMap(list);

    var request = http.MultipartRequest('POST', Uri.parse(url));

    Map<String, String> finalMap = {};

    for (var element in fieldList) {
      finalMap.addAll(element);
    }

    request.headers.addAll(<String, String>{
      'Authorization': 'Bearer ${apiClient.token}',
      "dev-token":
          "\$2y\$12\$mEVBW3QASB5HMBv8igls3ejh6zw2A0Xb480HWAmYq6BY9xEifyBjG",
    });

    for (var file in filesList) {
      request.files.add(http.MultipartFile(file.key ?? '',
          file.value.readAsBytes().asStream(), file.value.lengthSync(),
          filename: file.value.path.split('/').last));
    }
    request.fields.addAll({'trx': trx});

    if (twoFactorCode.isNotEmpty) {
      request.fields.addAll({'authenticator_code': twoFactorCode});
    }

    request.fields.addAll(finalMap);

    http.StreamedResponse response = await request.send();
    String jsonResponse = await response.stream.bytesToString();
    AuthorizationResponseModel model =
        AuthorizationResponseModel.fromJson(jsonDecode(jsonResponse));

    return model;
  }

  Future<dynamic> getAllWithdrawHistory(int page,
      {String searchText = ""}) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.withdrawHistoryUrl}?page=$page&search=$searchText";

    ResponseModel responseModel = await apiClient
        .request(url, request.Method.getMethod, null, passHeader: true);

    if (responseModel.statusCode == 200) {
      WithdrawHistoryResponseModel model =
          WithdrawHistoryResponseModel.fromJson(
              jsonDecode(responseModel.responseJson));

      if (model.status == 'success') {
        return model;
      } else {
        CustomSnackBar.error(
            errorList: model.message ?? [MyStrings.somethingWentWrong]);
        return WithdrawHistoryResponseModel();
      }
    } else {
      return WithdrawHistoryResponseModel();
    }
  }

  Future<dynamic> modelToMap(List<GlobalFormModel> list) async {
    for (var e in list) {
      if (e.type == 'checkbox') {
        if (e.cbSelected != null && e.cbSelected!.isNotEmpty) {
          for (int i = 0; i < e.cbSelected!.length; i++) {
            fieldList.add({'${e.label}[$i]': e.cbSelected![i]});
          }
        }
      } else if (e.type == 'file') {
        if (e.imageFile != null) {
          filesList.add(ModelDynamicValue(e.label, e.imageFile!));
        }
      } else {
        if (e.selectedValue != null && e.selectedValue.toString().isNotEmpty) {
          fieldList.add({e.label ?? '': e.selectedValue});
        }
      }
    }
  }
}
