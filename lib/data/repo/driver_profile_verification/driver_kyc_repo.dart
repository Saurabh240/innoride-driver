import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ovoride_driver/core/utils/method.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/core/utils/url_container.dart';
import 'package:ovoride_driver/data/model/authorization/authorization_response_model.dart';
import 'package:ovoride_driver/data/model/global/formdata/global_keyc_formData.dart';
import 'package:ovoride_driver/data/model/global/response_model/response_model.dart';
import 'package:ovoride_driver/data/model/kyc/kyc_response_model.dart';
import 'package:ovoride_driver/data/services/api_service.dart';
import 'package:ovoride_driver/presentation/components/snack_bar/show_custom_snackbar.dart';

class DriverVerificationKycRepo {
  ApiClient apiClient;
  DriverVerificationKycRepo({required this.apiClient});

  Future<DriverKycResponseModel> getDriverVerificationKycData() async {
    String url =
        '${UrlContainer.baseUrl}${UrlContainer.driverVerificationFormUrl}';
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);

    if (responseModel.statusCode == 200) {
      DriverKycResponseModel model = DriverKycResponseModel.fromJson(
          jsonDecode(responseModel.responseJson));

      if (model.status == 'success') {
        return model;
      } else {
        if (model.remark?.toLowerCase() != 'already_verified' &&
            model.remark?.toLowerCase() != 'under_review') {
          CustomSnackBar.error(
              errorList: model.message ?? [MyStrings.somethingWentWrong]);
        }

        return model;
      }
    } else {
      return DriverKycResponseModel();
    }
  }

  List<Map<String, String>> fieldList = [];
  List<ModelDynamicValue> filesList = [];

  Future<AuthorizationResponseModel> submitDriverVerificationKycData(
      List<GlobalFormModel> list) async {
    apiClient.initToken();
    await modelToMap(list);
    String url =
        '${UrlContainer.baseUrl}${UrlContainer.driverVerificationFormUrl}';

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

    request.fields.addAll(finalMap);
    http.StreamedResponse response = await request.send();

    String jsonResponse = await response.stream.bytesToString();
    AuthorizationResponseModel model =
        AuthorizationResponseModel.fromJson(jsonDecode(jsonResponse));

    return model;
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
//
}

class ModelDynamicValue {
  String? key;
  dynamic value;
  ModelDynamicValue(this.key, this.value);
}
