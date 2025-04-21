import 'dart:convert';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/route/route.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/data/model/general_setting/general_setting_response_model.dart';
import 'package:ovoride_driver/data/model/global/response_model/response_model.dart';
import 'package:ovoride_driver/data/repo/auth/general_setting_repo.dart';
import 'package:ovoride_driver/data/repo/menu_repo/menu_repo.dart';
import 'package:ovoride_driver/presentation/components/snack_bar/show_custom_snackbar.dart';

class MyMenuController extends GetxController {
  MenuRepo menuRepo;
  GeneralSettingRepo repo;
  MyMenuController({required this.menuRepo, required this.repo});

  bool logoutLoading = false;
  bool isLoading = true;
  bool noInternet = false;

  bool balTransferEnable = true;
  bool langSwitchEnable = true;

  void loadData() async {
    isLoading = true;
    update();

    await configureMenuItem();
    isLoading = false;
    update();
  }

  Future<void> logout() async {
    logoutLoading = true;
    update();

    await menuRepo.logout();
    CustomSnackBar.success(successList: [MyStrings.logoutSuccessMsg]);

    logoutLoading = false;
    update();
    Get.offAllNamed(RouteHelper.loginScreen);
  }

  bool isTransferEnable = true;
  bool isWithdrawEnable = true;
  bool isInvoiceEnable = true;

  configureMenuItem() async {
    update();

    ResponseModel response = await repo.getGeneralSetting();

    if (response.statusCode == 200) {
      GeneralSettingResponseModel model = GeneralSettingResponseModel.fromJson(
          jsonDecode(response.responseJson));
      if (model.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
        bool langStatus =
            model.data?.generalSetting?.multiLanguage == '0' ? false : true;
        langSwitchEnable = langStatus;
        repo.apiClient.storeGeneralSetting(model);
        update();
      } else {
        List<String> message = [MyStrings.somethingWentWrong];
        CustomSnackBar.error(errorList: model.message ?? message);
        return;
      }
    } else {
      if (response.statusCode == 503) {
        update();
      }
      CustomSnackBar.error(errorList: [response.message]);
      return;
    }
  }

  bool isDeletBtnLoading = false;

  Future<void> deleteAccount() async {
    isDeletBtnLoading = true;
    update();

    await menuRepo.deleteAccount();
    CustomSnackBar.success(successList: [MyStrings.deleteAccount]);

    isDeletBtnLoading = false;
    update();
    Get.offAllNamed(RouteHelper.loginScreen);
  }
}
