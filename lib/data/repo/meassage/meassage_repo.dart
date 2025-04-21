import 'dart:convert';
import 'dart:io';

import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/core/utils/method.dart';
import 'package:ovoride_driver/core/utils/url_container.dart';
import 'package:ovoride_driver/data/model/global/response_model/response_model.dart';
import 'package:ovoride_driver/data/services/api_service.dart';
import 'package:http/http.dart' as http;

import '../../../core/utils/my_strings.dart';
import '../../../presentation/components/snack_bar/show_custom_snackbar.dart';
import '../../model/authorization/authorization_response_model.dart';

class MessageRepo {
  ApiClient apiClient;
  MessageRepo({required this.apiClient});

  Future<ResponseModel> getRideMessageList({
    required String id,
    required String page,
  }) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.rideMessageList}/$id?page=$page";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<bool> sendMessage({
    required String id,
    required String txt,
    File? file,
  }) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.sendMessage}/$id";
    apiClient.initToken();
    Map<String, String> params = {'message': txt};
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(<String, String>{
      'Authorization': 'Bearer ${apiClient.token}',
      "dev-token":
          "\$2y\$12\$mEVBW3QASB5HMBv8igls3ejh6zw2A0Xb480HWAmYq6BY9xEifyBjG",
    });
    if (file != null) {
      request.files.add(http.MultipartFile(
          'image', file.readAsBytes().asStream(), file.lengthSync(),
          filename: file.path.split('/').last));
    }
    request.fields.addAll(params);
    http.StreamedResponse response = await request.send();

    String jsonResponse = await response.stream.bytesToString();
    AuthorizationResponseModel model =
        AuthorizationResponseModel.fromJson(jsonDecode(jsonResponse));
    printX(model.status?.toLowerCase());
    printX(MyStrings.success.toLowerCase());
    if (model.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
      return true;
    } else {
      CustomSnackBar.error(errorList: model.message ?? [MyStrings.requestFail]);
      return false;
    }
  }
}
