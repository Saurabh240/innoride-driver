import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/data/model/global/response_model/response_model.dart';
import 'package:ovoride_driver/data/model/global/user/global_driver_model.dart';
import 'package:ovoride_driver/data/model/refer/reference_response_model.dart';
import 'package:ovoride_driver/data/repo/refer/reference_repo.dart';
import 'package:ovoride_driver/presentation/components/snack_bar/show_custom_snackbar.dart';
import 'package:share_plus/share_plus.dart';

class ReferenceController extends GetxController {
  ReferenceRepo repo;
  ReferenceController({required this.repo});

  bool isLoading = false;
  String currency = "";
  String currencySym = "";

  String referAmount = "";

  List<ReferenceUser> referUsers = [];
  GlobalDriverInfo driver = GlobalDriverInfo();

  Future<void> getReferData() async {
    currency = repo.apiClient.getCurrencyOrUsername(isCurrency: true);
    currencySym = repo.apiClient.getCurrencyOrUsername(isSymbol: true);
    referAmount = repo.apiClient.getReferAmount();
    isLoading = true;
    update();

    try {
      ResponseModel responseModel = await repo.getReferData();
      if (responseModel.statusCode == 200) {
        ReferenceResponseModel model = ReferenceResponseModel.fromJson(
            jsonDecode(responseModel.responseJson));
        if (model.status == "success") {
          driver = model.data?.user ?? GlobalDriverInfo();
          referUsers.clear();
          referUsers = model.data?.referenceUsers ?? [];
          update();
        } else {
          CustomSnackBar.error(
              errorList: model.message ?? [MyStrings.somethingWentWrong]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printX(e);
    }

    isLoading = false;
    update();
  }

  Future<void> shareImage() async {
    final box = Get.context!.findRenderObject() as RenderBox?;
    await Share.share(
      (driver.username ?? '').toUpperCase(),
      subject: MyStrings.share.tr,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }
}
