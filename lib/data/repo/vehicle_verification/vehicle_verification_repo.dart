import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/core/utils/method.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/core/utils/url_container.dart';
import 'package:ovoride_driver/data/model/authorization/authorization_response_model.dart';
import 'package:ovoride_driver/data/model/global/formdata/global_keyc_formData.dart';
import 'package:ovoride_driver/data/model/global/response_model/response_model.dart';
import 'package:ovoride_driver/data/model/global/ride/app_service_model.dart';
import 'package:ovoride_driver/data/model/global/ride/ride_rulse_model.dart';
import 'package:ovoride_driver/data/model/vehicle_verification/vehicle_verification_model.dart';
import 'package:ovoride_driver/data/services/api_service.dart';
import 'package:ovoride_driver/presentation/components/snack_bar/show_custom_snackbar.dart';

class VehicleVerificationRepo {
  ApiClient apiClient;
  VehicleVerificationRepo({required this.apiClient});

  Future<VehicleKycResponseModel> getVahicleVerificationKycData() async {
    String url =
        '${UrlContainer.baseUrl}${UrlContainer.vehicleVerificationFormUrl}';
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);

    if (responseModel.statusCode == 200) {
      VehicleKycResponseModel model = VehicleKycResponseModel.fromJson(
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
      return VehicleKycResponseModel();
    }
  }

  List<Map<String, String>> fieldList = [];
  List<ModelDynamicValue> filesList = [];

  Future<AuthorizationResponseModel> submitVehicleVerificationKycData({
    required List<GlobalFormModel> formList,
    required List<RiderRule> rideRuleList,
    required Brand brand,
    required AppService service,
  }) async {
    apiClient.initToken();
    await modelToMap(formList);

    String url =
        '${UrlContainer.baseUrl}${UrlContainer.vehicleVerificationFormUrl}';

    var request = http.MultipartRequest('POST', Uri.parse(url));

    Map<String, String> finalMap = {
      'service_id': service.id!,
      'brand_id': brand.id!,
    };

    for (int i = 0; i < rideRuleList.length; i++) {
      String id = rideRuleList[i].id.toString();
      finalMap['rules[$i]'] = id;
    }

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
    printX(finalMap);
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
