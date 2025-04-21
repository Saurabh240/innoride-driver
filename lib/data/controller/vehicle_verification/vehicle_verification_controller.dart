import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/core/utils/url_container.dart';
import 'package:ovoride_driver/data/model/authorization/authorization_response_model.dart';
import 'package:ovoride_driver/data/model/global/formdata/global_keyc_formData.dart';
import 'package:ovoride_driver/data/model/global/ride/app_service_model.dart';
import 'package:ovoride_driver/data/model/global/ride/ride_rulse_model.dart';
import 'package:ovoride_driver/data/model/kyc/kyc_pending_data_model.dart';
import 'package:ovoride_driver/data/model/vehicle_verification/vehicle_verification_model.dart';
import 'package:ovoride_driver/data/repo/vehicle_verification/vehicle_verification_repo.dart';
import 'package:ovoride_driver/presentation/components/snack_bar/show_custom_snackbar.dart';

import '../../../core/helper/date_converter.dart';

class VehicleVerificationController extends GetxController {
  VehicleVerificationRepo repo;
  VehicleVerificationController({required this.repo});
  File? imageFile;

  bool isLoading = true;
  List<GlobalFormModel> formList = [];

  String selectOne = MyStrings.selectOne;

  VehicleKycResponseModel model = VehicleKycResponseModel();
  bool isNoDataFound = false;
  bool isAlreadyVerified = false;
  bool isAlreadyPending = false;

  List<KycPendingData> pendingData = [];
  AppService selectedService = AppService(id: '-1');
  Brand selectedBrand = Brand(id: '-1');
  List<RiderRule> selectedRiderRules = [];

  String path = '';
  String serviceImagePath = '';
  String brandImagePath = '';

  List<AppService> services = [];
  List<Brand> brands = [];
  List<RiderRule> riderRules = [];

  beforeInitLoadKycData() async {
    setStatusTrue();

    try {
      model = await repo.getVahicleVerificationKycData();
      if (model.data != null &&
          model.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
        if (model.remark?.toLowerCase() == 'under_review') {
          isAlreadyPending = true;
        }

        printX('pList?.first.name ${model.data?.vehicleData?.length}');
        path = '${UrlContainer.domainUrl}/${model.data?.path ?? ''}';
        serviceImagePath =
            '${UrlContainer.domainUrl}/${model.data?.serviceImagePath ?? ''}';
        brandImagePath =
            '${UrlContainer.domainUrl}/${model.data?.brandImagePath ?? ''}';

        selectedService = model.data?.selectedServices ?? AppService(id: '-1');
        selectedBrand = model.data?.selectedBrand ?? Brand(id: '-1');

        riderRules.addAll(model.data?.riderRules ?? []);

        List<KycPendingData>? pList = model.data?.vehicleData;
        if (pList != null && pList.isNotEmpty) {
          pendingData.clear();
          pendingData.addAll(pList);
        }

        selectedService = model.data?.selectedServices ?? AppService(id: "-1");
        selectedBrand = model.data?.selectedBrand ?? Brand(id: "-1");

        List<GlobalFormModel>? tList = model.data?.form?.list;
        List<AppService>? tservices = model.data?.services;
        List<Brand>? tbrands = model.data?.brands;
        List<RiderRule>? triderRules = model.data?.riderRules;

        if (tservices != null && tservices.isNotEmpty) {
          services.addAll(tservices);
        }
        if (tbrands != null && tbrands.isNotEmpty) {
          brands.addAll(tbrands);
        }
        if (triderRules != null && triderRules.isNotEmpty) {
          riderRules.clear();
          riderRules.addAll(triderRules);
        }

        if (tList != null && tList.isNotEmpty) {
          formList.clear();
          for (var element in tList) {
            if (element.type == 'select') {
              bool? isEmpty = element.options?.isEmpty;
              bool empty = isEmpty ?? true;
              if (element.options != null && empty != true) {
                element.options?.insert(0, selectOne);
                element.selectedValue = element.options?.first;
                formList.add(element);
              }
            } else {
              formList.add(element);
            }
          }
        }
        if (model.remark?.toLowerCase() == 'already_verified') {
          isAlreadyVerified = true;
        }
        isNoDataFound = false;

        update();
      } else {
        isNoDataFound = true;
      }
    } finally {
      setStatusFalse();
    }
    setStatusFalse();
  }

  setStatusTrue() {
    isLoading = true;
    update();
  }

  setStatusFalse() {
    isLoading = false;
    update();
  }

  void selectRideRule(RiderRule rule) {
    if (!selectedRiderRules.contains(rule)) {
      selectedRiderRules.add(rule);
    }
    update();
  }

  void selectService(AppService service) {
    selectedService = service;
    update();
  }

  void selectBrand(Brand brand) {
    selectedBrand = brand;
    update();
  }

  bool submitLoading = false;
  submitKycData() async {
    List<String> list = hasError();

    if (list.isNotEmpty) {
      CustomSnackBar.error(errorList: list);
      return;
    }

    submitLoading = true;
    update();

    AuthorizationResponseModel response =
        await repo.submitVehicleVerificationKycData(
      formList: formList,
      rideRuleList: selectedRiderRules,
      service: selectedService,
      brand: selectedBrand,
    );

    if (response.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
      isAlreadyPending = true;
      Get.back();
      CustomSnackBar.success(
          successList: response.message ?? [MyStrings.success.tr]);
    } else {
      CustomSnackBar.error(
          errorList: response.message ?? [MyStrings.requestFail.tr]);
    }

    submitLoading = false;
    update();
  }

  List<String> hasError() {
    List<String> errorList = [];
    errorList.clear();
    for (var element in formList) {
      if (element.isRequired == 'required') {
        if (element.type == 'checkbox') {
          if (element.cbSelected == null) {
            errorList.add('${element.name} ${MyStrings.isRequired}');
          }
        } else if (element.type == 'file') {
          if (element.imageFile == null) {
            errorList.add('${element.name} ${MyStrings.isRequired}');
          }
        } else {
          if (element.selectedValue == '' ||
              element.selectedValue == selectOne) {
            errorList.add('${element.name} ${MyStrings.isRequired}');
          }
        }
      }
    }
    return errorList;
  }

  void changeSelectedValue(value, int index) {
    formList[index].selectedValue = value;
    update();
  }

  void changeSelectedRadioBtnValue(int listIndex, int selectedIndex) {
    formList[listIndex].selectedValue =
        formList[listIndex].options?[selectedIndex];
    update();
  }

  void changeSelectedCheckBoxValue(int listIndex, String value) {
    List<String> list = value.split('_');
    int index = int.parse(list[0]);
    bool status = list[1] == 'true' ? true : false;

    List<String>? selectedValue = formList[listIndex].cbSelected;

    if (selectedValue != null) {
      String? value = formList[listIndex].options?[index];
      if (status) {
        if (!selectedValue.contains(value)) {
          selectedValue.add(value!);
          formList[listIndex].cbSelected = selectedValue;
          update();
        }
      } else {
        if (selectedValue.contains(value)) {
          selectedValue.removeWhere((element) => element == value);
          formList[listIndex].cbSelected = selectedValue;
          update();
        }
      }
    } else {
      selectedValue = [];
      String? value = formList[listIndex].options?[index];
      if (status) {
        if (!selectedValue.contains(value)) {
          selectedValue.add(value!);
          formList[listIndex].cbSelected = selectedValue;
          update();
        }
      } else {
        if (selectedValue.contains(value)) {
          selectedValue.removeWhere((element) => element == value);
          formList[listIndex].cbSelected = selectedValue;
          update();
        }
      }
    }
  }

  void changeSelectedDateTimeValue(int index, BuildContext context) async {
    printX("tap");

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        final DateTime selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        formList[index].selectedValue =
            DateConverter.estimatedDateTime(selectedDateTime);
        formList[index].textEditingController?.text =
            DateConverter.estimatedDateTime(selectedDateTime);

        update();
      }
    }

    update();
  }

  void changeSelectedDateOnlyValue(int index, BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final DateTime selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
      );

      formList[index].selectedValue =
          DateConverter.estimatedDate(selectedDateTime);
      formList[index].textEditingController?.text =
          DateConverter.estimatedDate(selectedDateTime);
      printX(formList[index].textEditingController?.text);
      printX(formList[index].selectedValue);
      update();
    }

    update();
  }

  void changeSelectedTimeOnlyValue(int index, BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      final DateTime selectedDateTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        pickedTime.hour,
        pickedTime.minute,
      );

      formList[index].selectedValue =
          DateConverter.estimatedTime(selectedDateTime);
      formList[index].textEditingController?.text =
          DateConverter.estimatedTime(selectedDateTime);
      printX(formList[index].textEditingController?.text);
      printX(formList[index].selectedValue);
      update();
    }

    update();
  }

  void pickFile(int index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf', 'doc', 'docx']);

    if (result == null) return;

    formList[index].imageFile = File(result.files.single.path!);
    String fileName = result.files.single.name;
    formList[index].selectedValue = fileName;
    update();
    return;
  }
}
